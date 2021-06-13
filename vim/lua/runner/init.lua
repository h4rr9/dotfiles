local Job = require 'plenary.job'
local scan = require 'plenary.scandir'
local api = vim.api
local M = {}

M.__buf = nil
M.__win = nil

M.__start_win = nil

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
        M._create_window()
        local contents = M._diff(selected)
        local title = '☀️    Output ' .. selected .. '   🌑'
        M._update_buf(contents, title, false)
    end
end

M._create_window = function()
    -- save habndle to current window
    M.__start_win = api.nvim_get_current_win()

    -- open new vertical window
    api.nvim_command('botright vnew')
    M.__win = api.nvim_get_current_win()
    M.__buf = api.nvim_get_current_buf()

    -- unique buf name
    api.nvim_buf_set_name(M.__buf, "Test Cases Status")

    -- buf options
    api.nvim_buf_set_option(M.__buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(M.__buf, 'swapfile', false)
    api.nvim_buf_set_option(M.__buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(M.__buf, 'filetype', 'testcases-status')

    -- win options
    api.nvim_win_set_option(M.__win, 'wrap', false)
    api.nvim_win_set_option(M.__win, 'cursorline', true)

    -- :TODO set mappings here
    local closingKeys = {'<Esc>', '<Leader>', '<C-^>', 'q'}
    for i = 1, #closingKeys do
        api.nvim_buf_set_keymap(M.__buf, 'n', closingKeys[i], ':close<CR>', {['silent'] = true, ['nowait'] = true, ['noremap'] = true})
    end

end

M._cleanup = function(test_case_ids)

    local temp_files = {}
    for _, v in pairs(test_case_ids) do table.insert(temp_files, 'out' .. v .. '.temp') end
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

    for k, _ in pairs(possible_output_files) do test_cases_set[k] = possible_input_files[k] end
    for k, _ in pairs(test_cases_set) do test_cases[#test_cases + 1] = k end
    return test_cases
end

M.get_results = function()

    M._prepping()

    local test_cases = M._get_test_cases()

    if next(test_cases) ~= nil then
        local output = M._run_test_cases(test_cases)
        M._create_window()

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
