local Job = require 'plenary.job'
local scan = require 'plenary.scandir'
local api = vim.api
local M = {}

M.__buf = nil
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

M._create_window = function()
    M.__buf = api.nvim_create_buf(false, true) -- create new emtpy buffer

    api.nvim_buf_set_option(M.__buf, 'bufhidden', 'wipe')
    -- get dimensions
    local width = api.nvim_get_option("columns")
    local height = api.nvim_get_option("lines")

    -- calculate our floating window size
    local win_height = math.ceil(height * 0.4)
    local win_width = math.ceil(width * 0.2)

    -- and its starting position
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- set some options
    local opts = {style = "minimal", relative = "editor", width = win_width, height = win_height, row = row, col = col}
    -- and finally create it with buffer attached
    local border_buf = api.nvim_create_buf(false, true)

    local closingKeys = {'<Esc>', '<CR>', '<Leader>', '<C-o>', '<C-^>', '<C-i>', 'q'}
    for i = 1, #closingKeys do
        -- call nvim_buf_set_keymap(buf, 'n', closingKey, ':close<CR>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
        vim.api.nvim_buf_set_keymap(M.__buf, 'n', closingKeys[i], ':close<CR>', {['silent'] = true, ['nowait'] = true, ['noremap'] = true})
        vim.api.nvim_buf_set_keymap(border_buf, 'n', closingKeys[i], ':close<CR>', {['silent'] = true, ['nowait'] = true, ['noremap'] = true})
    end

    local border_lines = {'╭' .. string.rep('─', win_width - 2) .. '╮'}
    local middle_line = '│' .. string.rep(' ', win_width - 2) .. '│'
    for _ = 1, (win_height - 2) do table.insert(border_lines, middle_line) end
    table.insert(border_lines, '╰' .. string.rep('─', win_width - 2) .. '╯')

    api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
    local border_win = api.nvim_open_win(border_buf, true, opts)
    -- change window paremeters to make main window smaler than border window
    opts.row = opts.row + 1
    opts.height = opts.height - 2
    opts.col = opts.col + 2
    opts.width = opts.width - 4

    local win = api.nvim_open_win(M.__buf, true, opts)
    -- fix bg colors from folke/zen-mode.nvim lua/zen-mode/view.lua:201
    vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:" .. "Normal")
    vim.api.nvim_win_set_option(border_win, "winhighlight", "NormalFloat:" .. "Normal")
    -- close buffer when focus is changed
    api.nvim_command('au BufEnter,WinEnter,WinLeave <buffer> exe "silent bwipeout! "' .. M.__buf)
    api.nvim_command('au BufEnter,WinEnter,WinLeave  <buffer> exe "silent bwipeout! "' .. border_buf)
end

M._cleanup = function(test_case_ids)

    local temp_files = {}

    for temp_file_id = 1, #test_case_ids do table.insert(temp_files, 'out' .. temp_file_id .. '.temp') end

    Job:new({command = 'rm', args = temp_files, cwd = M._path, env = {['PATH'] = '/usr/bin'}}):sync() -- or start()
end

M._run_test_cases = function(test_cases)

    local command_output = {}
    local jobs = {}
    for i = 1, #test_cases do

        local exec = M._exec
        local input_file = 'in' .. test_cases[i]
        local output_file = 'out' .. test_cases[i]
        local temp_file = output_file .. '.temp'

        local job_obj = Job:new({
            command = 'runner.sh',
            args = {exec, input_file, output_file, temp_file},
            cwd = M._path,
            env = {['PATH'] = '/home/h4rr9/.local/bin:/usr/bin'}
        })

        job_obj:sync()
        jobs[i] = job_obj

    end
    for i = 1, #test_cases do
        if next(jobs[i]:result()) ~= nil then
            table.insert(command_output, "Test Case " .. i .. " Failed ❎")
        else
            table.insert(command_output, "Test Case " .. i .. " Passed ✅")
        end
    end
    return command_output

end

M._update_view = function(result)

    local function center(str)
        local width = api.nvim_win_get_width(0)
        local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
        return string.rep(' ', shift) .. str
    end

    for k, _ in pairs(result) do result[k] = center(result[k]) end

    api.nvim_buf_set_lines(M.__buf, 0, -1, false, {center('💀 Test Case Status 💀'), ''})
    api.nvim_buf_set_lines(M.__buf, 3, -1, false, result)

    api.nvim_buf_add_highlight(M.__buf, -1, 'WhidHeader', 0, 0, -1)
    api.nvim_buf_add_highlight(M.__buf, -1, 'whidSubHeader', 1, 0, -1)

    api.nvim_buf_add_highlight(M.__buf, -1, 'ctermbg', 0, 0, -1)
    api.nvim_buf_set_option(M.__buf, 'modifiable', false)
end

M._prepping = function()

    local ext = vim.fn.expand('%:e')

    if ext == 'cpp' then
        M._exec = vim.fn.expand('%:t:r')
        M._path = vim.fn.expand('%:p:h')

        local exec_file = scan.scan_dir(M._path, {depth = 1, search_pattern = M._exec .. '$'})

        assert(next(exec_file) ~= nil, "executable doesn't exist")
    elseif ext == 'py' then
        M._exec = vim.fn.expand('%:t')
        M._path = vim.fn.expand('%:p:h')

        vim.cmd(':silent exec "!chmod +x ' .. vim.fn.expand('%') .. '"')
    else
        assert(false, "file type not supported yet")
    end

end

M._get_test_cases = function()
    local test_cases = {}
    local test_cases_set = {}
    local possible_input_files = {}
    local possible_output_files = {}

    local input_files = scan.scan_dir(M._path, {depth = 1, search_pattern = 'in[0-9]+'})
    for i = 1, #input_files do
        local in_id = string.match(input_files[i], 'in(%d+)')
        possible_input_files[in_id] = true
    end

    local output_files = scan.scan_dir(M._path, {depth = 1, search_pattern = 'out[0-9]+'})
    for i = 1, #output_files do
        local out_id = string.match(output_files[i], 'out(%d+)')
        possible_output_files[out_id] = true
    end

    for k in pairs(possible_output_files) do test_cases_set[k] = possible_input_files[k] end
    for k, _ in pairs(test_cases_set) do test_cases[#test_cases + 1] = k end
    return test_cases
end

M.get_results = function()

    M._prepping()

    local test_cases = M._get_test_cases()

    M._create_window()
    if next(test_cases) ~= nil then
        local output = M._run_test_cases(test_cases)
        M._update_view(output)
        M._cleanup(test_cases)
    else
        local output = {"No Test Cases found 🤷"}
        M._update_view(output)
    end

end

return M
