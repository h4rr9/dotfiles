lua << EOF

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-12', -- adjust as needed
  name = "lldb"
}


local function pick_process()
  local output = vim.fn.system({'ps', 'a'})
  local lines = vim.split(output, '\n')
  local procs = {}
  for _, line in pairs(lines) do
    -- output format
    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
    local parts = vim.fn.split(vim.fn.trim(line), ' \\+')
    local pid = parts[1]
    local name = table.concat({unpack(parts, 5)}, ' ')
    if pid and pid ~= 'PID' then
      pid = tonumber(pid)
      if pid ~= vim.fn.getpid() then
        table.insert(procs, { pid = tonumber(pid), name = name })
      end
    end
  end
  local choices = {'Select process'}
  for i, proc in ipairs(procs) do
    table.insert(choices, string.format("%d: pid=%d name=%s", i, proc.pid, proc.name))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #procs then
    return nil
  end
  return procs[choice].pid
end

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
    --pid=pick_process
  },
}


-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


local api = vim.api
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, 'n')
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, 'n', 'K')
      end
    end
  end
  api.nvim_set_keymap(
    'n', 'K', '<Cmd>lua require("dap.ui.variables").hover()<CR>', { silent = true })
end

dap.listeners.after['event_terminated']['me'] = function()
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(
      keymap.buffer,
      keymap.mode,
      keymap.lhs,
      keymap.rhs,
      { silent = keymap.silent == 1 }
    )
  end
  keymap_restore = {}
end

require("dapui").setup()
EOF

nnoremap <leader>dc <cmd>lua require('dap').continue()<cr>
nnoremap <leader>dsv <cmd>lua require('dap').step_over()<cr>
nnoremap <leader>dsi <cmd>lua require('dap').step_into()<cr>
nnoremap <leader>dso <cmd>lua require('dap').step_out()<cr>
nnoremap <leader>dtb <cmd>lua require('dap').toggle_breakpoint()<cr>
nnoremap <leader>dsbr <cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>
nnoremap <leader>dsbm <cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>
nnoremap <leader>dro <cmd>lua require('dap').repl.open()<cr>
nnoremap <leader>drl <cmd>lua require('dap').repl.run_last()<cr>

nnoremap <leader>dcc <cmd>lua require"telescope".extensions.dap.commands{}<cr>
nnoremap <leader>dco <cmd>lua require"telescope".extensions.dap.configurations{}<cr>
nnoremap <leader>dlb <cmd>lua require"telescope".extensions.dap.list_breakpoints{}<cr>
nnoremap <leader>dv <cmd>lua require"telescope".extensions.dap.variables{}<cr>
nnoremap <leader>df <cmd>lua require"telescope".extensions.dap.frames{}<cr>

