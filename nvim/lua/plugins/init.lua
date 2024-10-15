return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format { bufnr = args.buf }
        end,
      })
    end,
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- vim stuff
        "lua-language-server",
        "stylua",

        -- web stuff
        "html-lsp",
        "css-lsp",
        "prettier",
        "eslint-lsp",

        -- cpp stuff
        "clangd",
        "codelldb",

        -- rust stuff
        "rust-analyzer",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "json5",
        "javascript",
        "typescript",
        "tsx",
        "graphql",
        "markdown",
        "markdown_inline",
        "c",
        "cpp",
        "rust",
        "toml",
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    -- Default configuration can be found in
    -- ~/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/nvimtree.lua
    opts = {
      -- One possible way to reduce the overhead of nvim-tree if nvim is hanging
      -- actions = {
      --   change_dir = {
      --     enable = false,
      --   },
      -- },

      view = {
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            return {
              relative = "editor",
              -- border = "rounded",
              width = 50,
              height = vim.opt.lines:get(),
              -- account for NvChad tabbufline
              row = 1,
              col = 0,
            }
          end,
        },
        -- Resize the window on each draw based on the longest line.
        -- adaptive_size = false,
        -- If `false`, the height and width of windows other than nvim-tree will be equalized.
        -- preserve_window_proportions = true,
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = {
        -- The scope start/end underline hides diagnostic underlines
        show_start = false,
        show_end = false,
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      local opts = require "nvchad.configs.cmp"

      -- Override NvChad C-Space mapping
      opts.mapping["<C-Space>"] = cmp.mapping(function()
        -- Don't show completion menu when inside a prompt window like renamer
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end)

      return opts
    end,
  },

  -- NvChad Shortcuts
  "NvChad/nvcommunity",
  { import = "nvcommunity.editor.telescope-undo" },
  -- { import = "nvcommunity.lsp.codeactionmenu" },
  -- { import = "nvcommunity.lsp.prettyhover" },
  -- { import = "nvcommunity.motion.hop" },

  -- Use `jk` as the escape key
  { "max397574/better-escape.nvim", enabled = false },

  -- Code action menu UI using Telescope
  -- https://github.com/aznhe21/actions-preview.nvim?tab=readme-ov-file
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "telescope.nvim" },
    -- keys = { "<leader>ca" },
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            },
          },
        },
      }
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension "ui-select"
    end,
  },

  -- Jump motions
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine" },
    opts = { keys = "etovxqpdygfblzhckisuran" },
    init = function()
      local map = vim.keymap.set

      map("n", "<Space>w", "<CMD> HopWord <CR>", { desc = "Hop to any word" })
      map("n", "<Space>t", "<CMD> HopNodes <CR>", { desc = "Hop around syntax tree (ie. scope)" })
      map("n", "<Space>s", "<CMD> HopLineStart<CR>", { desc = "Hop to line start" })
      map("n", "<Space>l", "<CMD> HopWordCurrentLine<CR>", { desc = "Hop in this line" })
    end,
  },

  -- Taboo
  -- Used to name tabs with my custom tabufline "tabs" module
  {
    "gcmt/taboo.vim",
    dependencies = { "NvChad/ui" },
    -- Needs to load up front so that NvChad tabufline can use it.
    lazy = false,
  },

  -- Update imports when renaming files in nvim-tree
  -- https://github.com/antosha417/nvim-lsp-file-operations
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  -- Split join lines
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    -- event = { "BufRead", "BufWinEnter", "BufNewFile" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    config = function()
      require("treesj").setup {
        -- https://github.com/Wansmer/treesj#settings
        use_default_keymaps = false,
        max_join_length = 1000,
      }
      -- tell treesitter to use the markdown parser for mdx files
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },

  -- Surround
  -- https://github.com/kylechui/nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
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

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    -- init = function()
    --   require("core.utils").load_mappings "comment"
    -- end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- Winbar file location and context
  {
    "utilyre/barbecue.nvim",
    event = "LspAttach",
    dependencies = {
      "soulfresh/base46",
      "SmiteshP/nvim-navic",
    },
    opts = function()
      local colors = require("base46").get_theme_tb "base_30"
      local mix = require("base46.colors").mix

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
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require "configs.typescript-tools"
    end,
  },
}
