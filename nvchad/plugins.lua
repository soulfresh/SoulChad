local overrides = require("custom.configs.overrides")
local cmp = require("cmp")

-- local function nextCompletion(fallback)
-- 	local copilot = require("copilot.suggestion")
-- 	if cmp.visible() then
-- 		cmp.select_next_item()
-- 	elseif require("luasnip").expand_or_jumpable() then
-- 		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
-- 	elseif copilot.is_visible() then
-- 		copilot.accept()
-- 	else
-- 		fallback()
-- 	end
-- end
--
-- local function previousCompletion(fallback)
-- 	local copilot = require("copilot.suggestion")
-- 	if cmp.visible() then
-- 		cmp.select_prev_item()
-- 	elseif require("luasnip").jumpable(-1) then
-- 		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
-- 	elseif copilot.is_visible() then
-- 		copilot.dismiss()
-- 	else
-- 		fallback()
-- 	end
-- end

---@type NvPluginSpec[]
local plugins = {
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
    'junegunn/vim-easy-align',
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
    end
  },

  -- Focus buffer
  -- https://github.com/Pocco81/true-zen.nvim
  {
    "Pocco81/true-zen.nvim",
		event = "VimEnter",
    config = function()
      require("true-zen").setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },

  -- TODO - This doesn't seem to work.
  -- Unception
  -- Prevent nested NVim sessions from being opened inside of terminal.
  -- https://github.com/samjwill/nvim-unception
  {
    "samjwill/nvim-unception",
		event = "TermEnter",
    -- If you have issues going back to the terminal after starting a nvim
    -- session within a terminal, try:
    -- https://github.com/samjwill/nvim-unception/wiki/Setup-with-terminal-toggling-plugins!
    init = function()
      -- Optional settings go here!
      -- e.g.) vim.g.unception_open_buffer_in_new_tab = true
    end
  },

  -- Rust language tooling
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    config = function() 
      require("rust-tools").setup({
    --     tools = {
    --       runnables = {
    --         use_telescope = true,
    --       },
    --       inlay_hints = {
    --         auto = true,
    --         show_parameter_hints = false,
    --         parameter_hints_prefix = "",
    --         other_hints_prefix = "",
    --       },
    --     },
    --
        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {
          on_attach = function(_, buffer)
            require("core.utils").load_mappings('lspconfig')
          end,

          -- settings = {
          --   -- to enable rust-analyzer settings visit:
          --   -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
          --   ["rust-analyzer"] = {
          --     -- enable clippy on save
          --     checkOnSave = {
          --       command = "clippy",
          --     },
          --   },
          -- },
        },
      })
    end,
  },

  -- Debugging server
  {
    'mfussenegger/nvim-dap'
  },

  -- Update imports when renaming files in nvim-tree
  -- https://github.com/antosha417/nvim-lsp-file-operations
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
		event = { "BufRead", "BufWinEnter", "BufNewFile" },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },


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
