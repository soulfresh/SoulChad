local has_dap, dap = pcall(require, "dap")
if not has_dap then
  vim.print('Failed to load dap plugin:', dap)
  return
end

local has_dapui, dapui = pcall(require, "dapui")
if not has_dapui then
  vim.print('Failed to load dap-ui plugin:', dapui)
  return
end

local has_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not has_dap_virtual_text then
  vim.print('Failed to load nvim-dap-virtual-text:', dap_virtual_text)
  return
end

vim.fn.sign_define('DapBreakpoint', { text='⬢', texthl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='⬢', texthl='DapBreakpointCondition', numhl='DapBreakpointCondition' })
vim.fn.sign_define('DapBreakpointRejected', { text='⬡', texthl='DapBreakpointRejected', numhl= 'DapBreakpointRejected' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', numhl= 'DapStopped' })

-- Setup the dap ui
dapui.setup()

-- TODO Are there dap related highlights we need to cache?
-- dofile(vim.g.base46_cache .. "dap")

-- Handle dap events to init/show/hide ui related features.
dap.listeners.before.event_initialized["dapui_config"] = function()
  local api = require "nvim-tree.api"
  local view = require "nvim-tree.view"
  if view.is_visible() then
    api.tree.close()
  end

  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if vim.api.nvim_get_option_value("ft", { buf = bufnr }) == "dap-repl" then
      return
    end
  end
  -- dapui:open()
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  dap_virtual_text.refresh()
end

dap.listeners.after.disconnect["dapui_config"] = function()
  -- TODO temporarily disabled while I'm getting debuging working
  -- require("dap.repl").close()
  -- dapui.close()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  -- dapui.close()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  -- dapui.close()
  dap_virtual_text.refresh()
end
