local M = {}

-- The list of languages you'd like to debug
local languages = {"js"}

-- TODO This may provide a simpler way to configure nvim-dap using 
-- libraries installed via mason:
-- https://github.com/jay-babu/mason-nvim-dap.nvim
M.plugins = {
	-- Debugging server
	{
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapToggleBreakpoint" },
    dependencies = {
      -- Show variable values as virtual text during debug sessions
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require "custom.configs.dap-virtual-text"
        end,
      },
      -- Debugging UI for a nicer debugging experience
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require "custom.configs.dap-ui"
        end,
      },
    },
  },
}

local utils = require('custom.utils')

for _, language in ipairs(languages) do
  local file = 'custom.configs.debugging.languages.' .. language
  local config = require(file)
  -- vim.print('M', vim.inspect(M))
  -- vim.print("config", vim.inspect(config))
  M.plugins = utils.concat(M.plugins, config.plugins)
  -- vim.print('after:')
  -- vim.print(vim.inspect(M.plugins))
end

return M
