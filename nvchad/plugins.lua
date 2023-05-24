local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
    opts = {
      virtual_text = false,
      signs = {
        severity = { min = vim.diagnostic.severity.WARN }
      },
      float = {
        border = "single"
      }
    }
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
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
    enabled = false
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
    }
  },

	-- Fugitive
	-- Git command interface
  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  -- Flog
  -- Git branch graph
  {'rbong/vim-flog'},

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
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        -- https://github.com/Wansmer/treesj#settings
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      -- defaults = {
      --   prompt_prefix = " o  ",
      -- },
      extensions_list = { "themes", "terms", "projects" },
    },
  },

	-- Project Directory
	-- Quickly cd into previously visited locally installed git repositories
	{
    "ahmedkhalf/project.nvim",
    dependencies = { "telescope.nvim" },
    config = function()
      -- return require("custom.plugins.project").setup()
      local status_ok, project = pcall(require, "project_nvim")
      if not status_ok then
        print('Failed to load project.nvim')
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
        scope_chdir = 'tab',
        -- Path where project.nvim will store the project history for use in
        -- telescope
        datapath = vim.fn.stdpath("data"),
      })

      -- Use telescope for browsing projects: `:Telescope projects`
      require('telescope').load_extension 'projects'
      require'telescope'.extensions.projects.projects{}
    end,
	},

  -- Turn off friendly snippets because they are mostly snippets I don't use
  {
    "rafamadriz/friendly-snippets",
    enabled = false
  },

  -- Taboo
  {
    "gcmt/taboo.vim",
    dependencies = { "NvChad/ui" },
    lazy = false,
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
