local M = {}

-- How to configure nvim-dap + vscode-js-debug
-- https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
M.plugins = {
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
			-- Debug adapter for Javascript debugging using the most recent VSCode
			-- functionality (as opposed to the old Chrome based debugger).
			-- https://github.com/microsoft/vscode-js-debug
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		-- run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		config = function()
			require("dap-vscode-js").setup({
				-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
				-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				-- debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				-- debugger_cmd = { "js-debug-adapter" },
				-- which adapters to register in nvim-dap
				adapters = {
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"node-terminal",
					"pwa-extensionHost",
          -- These don't seem to work but the tutorial suggests these are the
          -- values that will be set by VSCode generated launch.json files.
					"chrome",
					"node",
				},
				-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
				-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			})

			local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

			for _, language in ipairs(js_based_languages) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"../node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						-- internalConsoleOptions = "neverOpen",
					},
					-- Debug single node js files
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					-- Debug node processes like express applications
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					-- Debug web applications
					{
						type = "pwa-chrome",
						request = "launch",
						name = 'Start Chrome with "localhost"',
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
					-- TODO Jest tests
					-- 		{
					-- 			type = "pwa-node",
					-- 			request = "launch",
					-- 			name = "Debug Jest Tests",
					-- 			-- trace = true, -- include debugger info
					-- 			runtimeExecutable = "node",
					-- 			runtimeArgs = {
					-- 				"./node_modules/jest/bin/jest.js",
					-- 				"--runInBand",
					-- 			},
					-- 			rootPath = "${workspaceFolder}",
					-- 			cwd = "${workspaceFolder}",
					-- 			console = "integratedTerminal",
					-- 			internalConsoleOptions = "neverOpen",
					-- 		},
				}
			end

      -- Allow loading debug configurations from launch.json files.
      -- Launch.json documentation:
      -- https://code.visualstudio.com/docs/editor/debugging#_launchjson-attributes
      -- https://code.visualstudio.com/docs/cpp/launch-json-reference
      require('dap.ext.vscode').load_launchjs(nil,
        { ['pwa-node'] = js_based_languages,
          ['node'] = js_based_languages,
          ['chrome'] = js_based_languages,
          ['pwa-chrome'] = js_based_languages }
      )
		end,
	},
}

return M
