local dap, dapui = require("dap"), require("dapui")
local vim = vim

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local pythonPath = '~/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python'
-- local venvPath = vim.fn.getcwd() .. '/venv/Scripts/python'
local localVenvPath = function()
  -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
  -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
  -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  elseif vim.fn.executable(cwd .. "/venv/Scripts/python") == 1 then
    return cwd .. "/venv/Scripts/python"
  elseif vim.fn.executable(cwd .. "/.venv/Scripts/python") == 1 then
    return cwd .. "/.venv/Scripts/python"
  elseif vim.fn.executable("/Program Files/Python39/python") == 1 then
    return "/Program Files/Python39/python"
  else
    return "/usr/bin/python"
  end
end

local venvPath = function()
  -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
  -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
  -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
  local curenvObj = require('swenv.api').get_current_venv()
  if curenvObj then
    local curenv = curenvObj.path
    if vim.fn.executable(curenv .. "/bin/python") == 1 then
      return curenv .. "/bin/python"
    elseif vim.fn.executable(curenv .. "/Scripts/python") == 1 then
      return curenv .. "/Scripts/python"
    elseif vim.fn.executable("/Program Files/Python39/python") == 1 then
      return "/Program Files/Python39/python"
    else
      return "/usr/bin/python"
    end
  else
    return "/usr/bin/python"
  end
end


require('dap-python').setup(pythonPath)
-- local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
-- dapui.setup()
-- require('dap-python').setup(path)

dap.adapters.localvenvpython = {
    type = 'executable';
    command = localVenvPath();
    args = { '-m', 'debugpy.adapter' };
}

dap.adapters.venvpython = {
    type = 'executable';
    command = venvPath();
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    type = "localvenvpython",
    request = "launch",
    name = "Run Venv run_app_resul",
    program = vim.fn.getcwd() .. '/gtcm/demo/run_app_resul.py',
  },
  {
    type = "localvenvpython",
    request = "launch",
    name = "Run Local Venv File",
    program = "${file}", -- This configuration will launch the current file if used.
  },
  {
    type = "venvpython",
    request = "launch",
    name = "Run virtualenv File",
    program = "${file}", -- This configuration will launch the current file if used.
  },
}

vim.fn.sign_define('DapBreakpoint',{ text ='🔴', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", {noremap = true})
vim.keymap.set('n', '<leader>n', require('dap').step_over)
vim.keymap.set('n', '<leader>si', require('dap').step_into)
vim.keymap.set('n', '<leader>so', require('dap').step_out)
-- vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint)
