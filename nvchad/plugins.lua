local overrides = require("custom.configs.overrides")
local cmp = require("cmp")

-- codelldb file path
-- TODO Try to get this working using mason-registry
-- local mason_registry = require("mason-registry")
local mason_root = vim.fn.stdpath("data") .. "/mason"
local extension_path = mason_root .. "/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

-- The path in windows is different
if this_os:find("Windows") then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

---@type NvPluginSpec[]
local plugins = {
	{
		"NvChad/base46",
		branch = "feat/highlight-color-mix",
		url = "https://github.com/soulfresh/base46",
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- { "simrat39/rust-tools.nvim", name = "rust-tools" },
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
		opts = {
			virtual_text = false,
			signs = {
				severity = { min = vim.diagnostic.severity.WARN },
			},
			float = {
				border = "single",
			},
		},
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	"NvChad/nvcommunity",
	{ import = "nvcommunity.lsp.codeactionmenu" },
	{ import = "nvcommunity.lsp.prettyhover" },
	{ import = "nvcommunity.motion.hop" },

	-- Use `jk` as the escape key
	{
		"max397574/better-escape.nvim",
		enabled = false,
		-- event = "InsertEnter",
		-- config = function()
		--   require("better_escape").setup()
		-- end,
	},

	{
		"NvChad/nvterm",
		opts = {
			behavior = {
				autoclose_on_quit = {
					enabled = true,
					confirm = true,
				},
				auto_insert = false,
			},
		},
	},

	-- Startup dashboard plugin
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			local opts = require("custom.configs.alpha")

			dashboard.section.header = opts.override_options.header
			dashboard.section.buttons = opts.override_options.buttons
			-- alpha.setup(opts.override_options)
			-- alpha.setup(dashboard.config)
			alpha.setup({
				button = dashboard.button,
				section = dashboard.section,
				leader = dashboard.leader,
				layout = {
					{ type = "padding", val = 2 },
					opts.override_options.header,
					{ type = "padding", val = 2 },
					opts.override_options.buttons,
					-- footer
					{
						type = "text",
						val = "",
						opts = {
							position = "center",
							hl = "Number",
						},
					},
				},
				opts = {
					margin = 5,
				},
			})
		end,
	},

	-- Fugitive
	-- Git command interface
	{
		"tpope/vim-fugitive",
		lazy = false,
	},

	-- Flog
	-- Git branch graph
	{
		"rbong/vim-flog",
		cmd = { "Flog", "Flogsplit" },
	},

	-- Undo history for telescope
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "telescope.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					undo = {
						-- telescope-undo.nvim config, see below
					},
				},
			})
			require("telescope").load_extension("undo")
			-- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end,
	},

	-- Split join
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
		use_default_keymaps = false,
		max_join_length = 1000,
		config = function()
			require("treesj").setup({
				-- https://github.com/Wansmer/treesj#settings
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				prompt_prefix = "   ",
			},
			-- extensions_list = {},
			-- extensions_list = { "themes", "terms", "projects" },
			extensions_list = { "themes", "terms", "undo" },
		},
	},

	-- Project Directory
	-- Quickly cd into previously visited locally installed git repositories
	-- TODO This plugin seems to be breaking my tab working directory
	{
		"ahmedkhalf/project.nvim",
		enabled = false,
		dependencies = { "telescope.nvim" },
		config = function()
			-- return require("custom.plugins.project").setup()
			local status_ok, project = pcall(require, "project_nvim")
			if not status_ok then
				print("Failed to load project.nvim")
				return
			end

			project.setup({
				-- Manual mode doesn't automatically change your root directory, so you have
				-- the option to manually do so using `:ProjectRoot` command.
				manual_mode = false,
				-- Methods of detecting the root directory. **"lsp"** uses the native neovim
				-- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
				-- order matters: if one is not detected, the other is used as fallback. You
				-- can also delete or rearangne the detection methods.
				detection_methods = { "lsp", "pattern" },
				-- All the patterns used to detect root dir, when **"pattern"** is in
				-- detection_methods
				patterns = { ".git", ".hg", ".svn", "Makefile", "package.json" },
				-- Don't calculate root dir on specific directories
				-- Ex: { "~/.cargo/*", ... }
				exclude_dirs = {},
				-- Show hidden files in telescope
				show_hidden = true,
				-- When set to false, you will get a message when project.nvim changes your
				-- directory.
				silent_chdir = true,
				-- What scope to change the directory, valid options are
				-- * global (default)
				-- * tab
				-- * win
				scope_chdir = "tab",
				-- Path where project.nvim will store the project history for use in
				-- telescope
				datapath = vim.fn.stdpath("data"),
			})

			-- Use telescope for browsing projects: `:Telescope projects`
			require("telescope").load_extension("projects")
			require("telescope").extensions.projects.projects({})
		end,
	},

	-- Turn off friendly snippets because they are mostly snippets I don't use
	{
		"rafamadriz/friendly-snippets",
		enabled = false,
	},

	-- Taboo
	{
		"gcmt/taboo.vim",
		dependencies = { "NvChad/ui" },
		lazy = false,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
		config = function(_, opts)
			opts.sources[#opts.sources + 1] = { name = "copilot" }
			require("cmp").setup(opts)
		end,
		opts = {
			mapping = {
				-- Disable tab completion. See "Tab" mapping in `mappings.lua`
				-- ["<Tab>"] = cmp.mapping(function(fallback) fallback() end, {"i", "s"}),
				-- ["<S-Tab>"] = cmp.mapping(function(fallback) fallback() end, {"i", "s"}),
				["<Tab>"] = cmp.mapping(function(fallback)
					local copilot = require("copilot.suggestion")
					-- if cmp.visible() then
					--   cmp.select_next_item()
					if require("luasnip").expand_or_jumpable() then
						vim.fn.feedkeys(
							vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
							""
						)
					elseif copilot.is_visible() then
						copilot.accept()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					local copilot = require("copilot.suggestion")
					-- if cmp.visible() then
					--   cmp.select_prev_item()
					if require("luasnip").jumpable(-1) then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
					elseif copilot.is_visible() then
						copilot.dismiss()
					else
						fallback()
					end
				end, { "i", "s" }),
				-- ["<C-j>"] = cmp.mapping(nextCompletion, {"i", "s"}),
				-- ["<C-k>"] = cmp.mapping(previousCompletion, {"i", "s"}),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-Space>"] = cmp.mapping(function()
					if cmp.visible() then
						cmp.close()
					else
						cmp.complete()
					end
				end, {
					"i",
					"s",
				}),
				["<CR>"] = cmp.mapping({
					i = function(fallback)
						fallback()
						-- if cmp.visible() then
						--   cmp.confirm({
						--     behavior = cmp.ConfirmBehavior.Replace,
						--     select = false,
						--   })
						-- else
						--   fallback()
						-- end
					end,
					s = function()
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						})
					end,
				}),
				["<C-CR>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Replace,
								select = false,
							})
						else
							fallback()
						end
					end,
					s = function()
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						})
					end,
				}),
				-- ["<C-e>"] = false,
			},
		},
		-- opts = function()
		--   local config = require "plugins.configs.cmp"
		--   return vim.tbl_deep_extend("force", config, {
		--     sources = vim.tbl_deep_extend("force", config.sources, {
		--       { name = "copilot" },
		--     })
		--   })
		-- end,
	},

	-- GitHub copilot
	-- ['github/copilot.vim'] = {}
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				-- Disable copilot suggestions UI because we will use CMP instead.
				suggestion = {
					-- Leaving this enabled seems to prevent some suggestions from showing
					-- up in copilot-cmp. However, leaving it disabled seems to prevent
					-- multiline copilot suggestions from appearing in copilot-cmp.
					-- https://github.com/zbirenbaum/copilot-cmp/issues/87
					enabled = false,
					auto_trigger = false,
					-- keymap = {
					--   accept = "<C-,>",
					-- }
				},
				panel = {
					-- Leaving this enabled seems to prevent some suggestions from showing
					-- up in copilot-cmp. However, leaving it disabled seems to prevent
					-- multiline copilot suggestions from appearing in copilot-cmp.
					-- https://github.com/zbirenbaum/copilot-cmp/issues/87
					enabled = false,
					auto_refresh = true,
				},
			})
		end,
	},

	-- Copilot in nvim-cmp window
	-- TODO: This doesn't work yet.
	{
		"zbirenbaum/copilot-cmp",
		-- after = 'copilot.lua',
		-- after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup({
				-- method = "getCompletionsCycling",
			})
		end,
	},

	-- EasyAlign
	-- https://github.com/junegunn/vim-easy-align
	{
		"junegunn/vim-easy-align",
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
	},

	-- Surround
	-- https://github.com/kylechui/nvim-surround
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},

	-- Focus buffer
	-- https://github.com/Pocco81/true-zen.nvim
	{
		"Pocco81/true-zen.nvim",
		event = "VimEnter",
		config = function()
			require("true-zen").setup({
				-- your config goes here
				-- or just leave it empty :)
			})
		end,
	},

	-- TODO - This doesn't seem to work.
	-- Unception
	-- Prevent nested NVim sessions from being opened inside of terminal.
	-- https://github.com/samjwill/nvim-unception
	{
		"samjwill/nvim-unception",
		-- To work, this plugin needs to load on startup
		lazy = false,
		-- If you have issues going back to the terminal after starting a nvim
		-- session within a terminal, try:
		-- https://github.com/samjwill/nvim-unception/wiki/Setup-with-terminal-toggling-plugins!
		init = function()
			-- Optional settings go here!
			-- e.g.) vim.g.unception_open_buffer_in_new_tab = true
			vim.g.unception_block_while_host_edits = true
		end,
	},

	-- Rust language tooling
	-- {
	--   'simrat39/rust-tools.nvim',
	--   ft = 'rust',
	--   config = function()
	--     require("rust-tools").setup({
	--       tools = {
	--         hover_actions = {
	--           auto_focus = true,
	--         },
	--
	--         inlay_hints = {
	--           auto = true,
	--           only_current_line = true,
	--         },
	--       },
	--       dap = {
	--         adapter = require("rust-tools.dap").get_codelldb_adapter(
	--           codelldb_path,
	--           liblldb_path
	--         ),
	--       },
	--       -- all the opts to send to nvim-lspconfig
	--       -- these override the defaults set by rust-tools.nvim
	--       -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	--       server = {
	--         on_attach = function(_, buffer)
	--           require("core.utils").load_mappings('lspconfig')
	--         end,
	--         settings = {
	--           -- to enable rust-analyzer settings visit:
	--           -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
	--           ["rust-analyzer"] = {
	--             -- enable clippy on save
	--             checkOnSave = {
	--               command = "clippy",
	--             },
	--           },
	--         },
	--       },
	--     })
	--   end,
	-- },

	-- rust language tooling
	-- https://github.com/mrcjkb/rustaceanvim
	{
		"mrcjkb/rustaceanvim",
		version = "^3",
		ft = { "rust" },
		init = function()
			vim.g.rustaceanvim = {
				dap = {
					adapter = {
						type = "server",
						port = "${port}",
						host = "127.0.0.1",
						executable = {
							command = codelldb_path,
							args = { "--liblldb", liblldb_path, "--port", "${port}" },
						},
					},
				},
				-- server = {
				--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
				--   settings = {
				--     ["rust-analyzer"] = {
				--       checkOnSave = {
				--         command = "clippy",
				--       },
				--     },
				--   },
				-- },
			}
		end,
	},

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


	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
      "mfussenegger/nvim-dap",
      -- Debug adapter for Javascript debugging using the most recent VSCode
      -- functionality
      {
        "microsoft/vscode-js-debug",
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
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
				adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost", "node" },
				-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
				-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			})

      local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      for _, language in ipairs(js_based_languages) do
        require("dap").configurations[language] = {
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
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          -- Debug web applications
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with \"localhost\"",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
          }
        }
      end

      -- local dap = require('dap')
      -- dap.adapters.node2 = {
      --   type = 'executable',
      --   command = 'node',
      --   args = {
      --     os.getenv('HOME') ..
      --       '/.local/share/nvim/lazy/vscode-node-debug2/out/src/nodeDebug.js'
      --   }
      -- }

			-- for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
			-- 	dap.configurations[language] = {
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
			-- 	}
			-- end
		end,
	},

  -- Run Jest tests in a terminal.
  -- This just launches a terminal and starts Jest tests filtered to the test
  -- under cursor or the file. Also sets up nvim-dap for debugging Jest tests.
  -- Not quite as feature complete as Neotest but worked for me out of the box.
	{
		"David-Kunz/jester",
		opts = {
			path_to_jest_run = "yarn test",
      dap = {type = 'pwa-node'},
		},
	},

	-- Neotest
	-- This wasn't working out of the box with the snapshot repo. Probably just
	-- needs to follow the config docs for monorepos but giving jester plugin a quick try
	-- { "haydenmeade/neotest-jest" },
	-- { "antoinemadec/FixCursorHold.nvim" },
	--
	-- {
	-- 	"nvim-neotest/neotest",
	-- 	requires = {
	-- 		"haydenmeade/neotest-jest",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"antoinemadec/FixCursorHold.nvim",
	-- 	},
	-- 	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	-- 	config = function()
	-- 		require("neotest").setup({
	-- 			adapters = {
	-- 				require("neotest-jest")({
	-- 					jestCommand = "yarn test --",
	-- 					jestConfigFile = "jest.config.ts",
	-- 					env = { CI = true },
	-- 					cwd = function(path)
	-- 						return vim.fn.getcwd()
	-- 					end,
	-- 				}),
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- Update imports when renaming files in nvim-tree
	-- https://github.com/antosha417/nvim-lsp-file-operations
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
		config = function()
			require("lsp-file-operations").setup()
		end,
	},

	-- Winbar file location and context
	{
		"utilyre/barbecue.nvim",
		event = "LspAttach",
		dependencies = {
			"NvChad/base46",
			"SmiteshP/nvim-navic",
		},
		opts = function(_plugin, _opts)
			-- local base16 = require("base46").get_theme_tb "base_16"
			local colors = require("base46").get_theme_tb("base_30")
			local mix = require("base46.colors").mix

			-- local bg = mix( colors.teal, colors.black, 50 )
			-- local bg = mix( colors.orange, colors.black, 30 )
			-- local bg = mix( colors.yellow, colors.black, 30 )
			-- local bg = mix( colors.nord_blue, colors.black, 30 )
			local bg = mix(colors.blue, colors.black, 30)

			return {
				-- Whether to use navig to show the current cursor code context.
				show_navic = false,
				exclude_filetypes = { "gitcommit", "git" },
				theme = {
					normal = {
						bg = bg,
						fg = colors.one_bg,
					},
					basename = {
						fg = colors.darker_black,
						bg = bg,
						bold = true,
					},
				},
			}
		end,
		-- config = function(_, opts)
		--   dofile(vim.g.base46_cache .. "navic")
		--   require('barbecue').setup(opts)
		-- end,
	},

	-- Replacement for tsserver lsp config
	-- https://github.com/pmizio/typescript-tools.nvim
	{
		"pmizio/typescript-tools.nvim",
		ft = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
		config = function()
			require("custom.configs.typescript-tools")
		end,
	},

	-- Asynchronous linter for tools that don't support the LSP format (ex. eslint).
	-- Hooks into the native NVIM diagnostics for display.
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePre",
		config = function()
			require("custom.configs.nvim-lint")
		end,
	},

	-- Auto-format on save
	-- Will require some integration witll lsp-config
	-- { "lukas-reineke/lsp-format.nvim" },

	-- Dim unfocused windows
	-- {
	-- 	"levouh/tint.nvim",
	-- 	event = { "BufRead", "BufWinEnter", "BufNewFile" },
	-- },

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
