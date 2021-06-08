local Job = require 'plenary.job'
local scan = require 'plenary.scandir'
local api = vim.api
local M = {}

M.__buf = nil
M.__border_buf = nil
M.__win = nil
M.__border_win = nil

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

M._diff = function(test_case_id)

    local exec = M._exec
    local input_file = 'in' .. test_case_id
    local output_file = 'out' .. test_case_id
    local temp_file = output_file .. '.temp'

    Job:new({
        command = 'runner.sh',
        args = {exec, input_file, output_file, temp_file},
        cwd = M._path,
        env = {['PATH'] = '/home/h4rr9/.local/bin:/usr/bin'}
    }):sync()

    local output_job = Job:new({command = 'cat', args = {temp_file}, cwd = M._path, env = {['PATH'] = '/bin'}})
    local expected_output_job = Job:new({command = 'cat', args = {output_file}, cwd = M._path, env = {['PATH'] = '/bin'}})

    output_job:sync()
    expected_output_job:sync()
    M._cleanup({test_case_id})

    local result = {'output', string.rep('-', 50)}
    for _, v in pairs(output_job:result()) do table.insert(result, v) end

    table.insert(result, '')
    table.insert(result, '')
    table.insert(result, output_file)
    table.insert(result, string.rep('-', 50))
    for _, v in pairs(expected_output_job:result()) do table.insert(result, v) end
    return result

end

M._get_selection = function()

    local option = vim.api.nvim_get_current_line()
    option = option:gsub('^%s+', '')
    local is_valid_option = option:match('Test Case (%d+)')
    if is_valid_option == nil then return -1 end
    return tonumber(is_valid_option)
end

M._create_and_update_output_window = function()
    local selected = M._get_selection()
    if selected ~= -1 then
        api.nvim_win_close(M.__win, true)
        M._create_window({height_factor = 0.4, width_factor = 0.3})
        local contents = M._diff(selected)
        local title = '☀️    Output ' .. selected .. '   🌑'
        M._update_buf(contents, title, false)
    end
end

M._create_window = function(window_opts)

    M.__buf = api.nvim_create_buf(false, true) -- create new emtpy buffer
    M.__border_buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(M.__buf, 'bufhidden', 'wipe')
    -- get dimensions
    local width = api.nvim_get_option("columns")
    local height = api.nvim_get_option("lines")

    -- calculate our floating window size
    local win_height = math.ceil(height * window_opts.height_factor)
    local win_width = math.ceil(width * window_opts.width_factor)

    -- and its starting position
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- set some options
    local opts = {style = "minimal", relative = "editor", width = win_width, height = win_height, row = row, col = col}
    -- and finally create it with buffer attached

    local closingKeys = {
        '<Esc>', '<Leader>', '<C-o>', '<C-^>', '<C-i>', 'q', '<C-h>', '<C-j>', '<C-k>', '<C-l>', '<C-w><C-h>', '<C-w><C-j>', '<C-w><C-k>',
        '<C-w><C-l>'
    }
    for i = 1, #closingKeys do
        -- call nvim_buf_set_keymap(buf, 'n', closingKey, ':close<CR>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
        api.nvim_buf_set_keymap(M.__buf, 'n', closingKeys[i], ':close<CR>', {['silent'] = true, ['nowait'] = true, ['noremap'] = true})
    end

    local border_lines = {'╭' .. string.rep('─', win_width - 2) .. '╮'}
    local middle_line = '│' .. string.rep(' ', win_width - 2) .. '│'
    for _ = 1, (win_height - 2) do table.insert(border_lines, middle_line) end
    table.insert(border_lines, '╰' .. string.rep('─', win_width - 2) .. '╯')

    -- draw borders
    api.nvim_buf_set_lines(M.__border_buf, 0, -1, false, border_lines)

    -- change window paremeters to make main window smaler than border window
    M.__border_win = api.nvim_open_win(M.__border_buf, true, opts)

    opts.row = opts.row + 1
    opts.height = opts.height - 2
    opts.col = opts.col + 2
    opts.width = opts.width - 4

    M.__win = api.nvim_open_win(M.__buf, true, opts)
    -- fix bg colors from folke/zen-mode.nvim lua/zen-mode/view.lua:201
    -- api.nvim_win_set_option(win, "winhighlight", "VertSplit:" .. "Normal")
    api.nvim_win_set_option(M.__win, "winhighlight", "NormalFloat:Normal")
    api.nvim_win_set_option(M.__border_win, "winhighlight", "NormalFloat:Normal")
    -- find highlight group for Border
    -- vim.api.nvim_win_set_option(win, "winhighlight", "BorderFloat:" .. "Normal")
    -- close buffer when focus is changed
    api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. M.__border_buf)

end

M._cleanup = function(test_case_ids)

    local temp_files = {}
    for temp_file_id = 1, #test_case_ids do table.insert(temp_files, 'out' .. temp_file_id .. '.temp') end
    Job:new({command = 'rm', args = temp_files, cwd = M._path, env = {['PATH'] = '/usr/bin'}}):sync() -- or start()

end

M._run_test_cases = function(test_cases)

    local sort_helper = function(a, b)
        local a_id = a:match('Test Case (%d+)')
        local b_id = b:match('Test Case (%d+)')

        return (tonumber(a_id) < tonumber(b_id))
    end

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
            table.insert(command_output, "Test Case " .. test_cases[i] .. " Failed ❎")
        else
            table.insert(command_output, "Test Case " .. test_cases[i] .. " Passed ✅")
        end
    end
    -- :TODO implement sort_helper to sort based on test_cases[i] in
    -- command_output

    table.sort(command_output, sort_helper)

    return command_output
end

M._update_buf = function(result, title, centered)

    local function center(str)
        local width = api.nvim_win_get_width(0)
        local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
        return string.rep(' ', shift) .. str
    end
    if centered == true then for k, _ in pairs(result) do result[k] = center(result[k]) end end

    api.nvim_buf_set_option(M.__buf, 'modifiable', true)
    api.nvim_buf_set_lines(M.__buf, 0, -1, false, {center(title), ' '})
    api.nvim_buf_set_lines(M.__buf, 3, -1, false, result)

    api.nvim_buf_add_highlight(M.__buf, -1, 'WhidHeader', 0, 0, -1)
    api.nvim_buf_add_highlight(M.__buf, -1, 'whidSubHeader', 1, 0, -1)

    api.nvim_buf_add_highlight(M.__buf, -1, 'ctermbg', 0, 0, -1)
    api.nvim_buf_set_option(M.__buf, 'modifiable', false)

    api.nvim_win_set_cursor(M.__win, {3, 0})
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

    if next(test_cases) ~= nil then
        local output = M._run_test_cases(test_cases)
        M._create_window({height_factor = 0.4, width_factor = 0.2})

        -- map <cr> to open new floating window with diff / output files
        api.nvim_buf_set_keymap(M.__buf, 'n', '<cr>', "<cmd>lua require('runner')._create_and_update_output_window()<cr>",
                                {['silent'] = true, ['nowait'] = true, ['noremap'] = true})

        M._update_buf(output, '💀 Test Cases Status 💀', true)
        M._cleanup(test_cases)
    else
        assert(false, "🤷 No Test Cases found 🤷")
    end

end

return M
