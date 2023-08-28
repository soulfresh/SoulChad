local overrides = require("custom.configs.overrides")
local cmp = require("cmp")

local function nextCompletion(fallback)
	local copilot = require("copilot.suggestion")
	if cmp.visible() then
		cmp.select_next_item()
	elseif require("luasnip").expand_or_jumpable() then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
	elseif copilot.is_visible() then
		copilot.accept()
	else
		fallback()
	end
end

local function previousCompletion(fallback)
	local copilot = require("copilot.suggestion")
	if cmp.visible() then
		cmp.select_prev_item()
	elseif require("luasnip").jumpable(-1) then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
	elseif copilot.is_visible() then
		copilot.dismiss()
	else
		fallback()
	end
end

---@type NvPluginSpec[]
local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
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

	-- Install a plugin
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
			print(vim.inspect(opts))
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
					auto_trigger = true,
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

  -- Breaking Telescope?
  -- {
  --   "godlygeek/tabular",
		-- event = { "BufRead", "BufWinEnter", "BufNewFile" },
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
