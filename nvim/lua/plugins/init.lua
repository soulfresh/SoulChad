return {
  {
    "stevearc/conform.nvim",
    -- This is what NvChad gives us by default but it conflicts with what I've
    -- added to configs.conform. However, keeping this here temporarily in case
    -- my changes to configs.conform don't work.
    -- init = function()
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     pattern = "*",
    --     callback = function(args)
    --       require("conform").format { bufnr = args.buf }
    --     end,
    --   })
    -- end,
    event = "BufWritePre",
    config = function()
      require("configs.conform")
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
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
      local cmp = require("cmp")
      local opts = require("nvchad.configs.cmp")

      -- Don't preselect the first item. While it's convenient most of the time,
      -- it causes issues when you're at the end of a line and want to start a
      -- new line. If cmp is open, it will select the first completion instead.
      opts.preselect = cmp.PreselectMode.None
      opts.completion = { completeopt = "menu,menuone,noselect" }

      -- Override NvChad mappings
      opts.mapping["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        -- Don't preselect the first item.
        select = false,
      })
      opts.mapping["<C-Space>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end)

      -- Override NvChad's Tab mappings to remove Tab usage with cmp because:
      -- 1. I use <C-n>/<C-p> to select completions
      -- 2. I generally don't want completions when expanding a snippet
      -- 3. I use <Tab> for Copilot completions
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        -- Do snippet if one has been selected from the cmp menu. Otherwise
        -- fallback to Copilot.
        local luasnip = require("luasnip")
        -- If something is selected in the cmp menu
        local shouldExpand = cmp.get_active_entry() and luasnip.expand_or_locally_jumpable()
        -- Or we are currently in snippet mode
        -- If in_snippet doesn't work, try get_active_snip
        local shouldJump = luasnip.in_snippet() and luasnip.expand_or_locally_jumpable()
        if shouldExpand or shouldJump then
          require("luasnip").expand_or_jump()
        -- elseif cmp.visible() then
        --   cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" })
      opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        -- if cmp.visible() then
        --   cmp.select_prev_item()
        if require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })

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
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
    end,
  },

  -- Customize Telescope file searches by directory, file type, hidden files, etc
  -- https://github.com/molecule-man/telescope-menufacture
  {
    "molecule-man/telescope-menufacture",
    dependencies = { "telescope.nvim" },
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  },

  -- Emoji/Dev Icon picker menu
  {
    "ziontee113/icon-picker.nvim",
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    -- keys = { "<C-D-Space>" },
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })

      local opts = { noremap = true, silent = true }

      vim.keymap.set({ "n", "i" }, "<C-D-Space>", "<cmd>IconPickerNormal emoji<cr>", opts)
      -- vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
      -- vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
    end,
  },

  -- Jump motions around current visible file.
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine" },
    opts = { keys = "etovxqpdygfblzhckisuran" },
    keys = {
      { "<Space>w", "<CMD> HopWord <CR>", mode = "n", desc = "Hop to any word" },
      { "<Space>c", "<CMD> HopNodes <CR>", mode = "n", desc = "Hop around code context (ie. scope/syntax tree)" },
      { "<Space>s", "<CMD> HopLineStart<CR>", mode = "n", desc = "Hop to line start" },
      -- { "<Space>l", "<CMD> HopWordCurrentLine<CR>", mode = "n", desc = "Hop in this line" },
    },
  },

  -- Inner Word Motions (camelCase, snake_case, kebap-case)
  -- https://github.com/chrisgrieser/nvim-spider
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "<Space>l",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Move forward within word (camelCase, snake_case, kebap-case)",
      },
      {
        "<Space>h",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Move backward within word (camelCase, snake_case, kebap-case)",
      },
    },
  },

  -- Buffer History Jump
  -- https://github.com/wilfreddenton/history.nvim/blob/master/README.md
  {
    "wilfreddenton/history.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("history").setup({
        keybinds = {
          back = "<Space>o",
          forward = "<Space>i",
          view = "<Space>u",
        },
      })
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
      require("treesj").setup({
        -- https://github.com/Wansmer/treesj#settings
        use_default_keymaps = false,
        max_join_length = 1000,
      })
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
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
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
      local colors = require("base46").get_theme_tb("base_30")
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
      require("configs.typescript-tools")
    end,
  },

  -- Toggle Cpp header files
  {
    "jakemason/ouroboros",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "cpp",
    opts = {
      switch_to_open_pane_if_possible = true,
    },
    keys = {
      { "th", "<cmd>Ouroboros<CR>", mode = "n", desc = "Cpp toggle header file" },
    },
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = false,
          keymap = {
            accept = "<Tab>",
            -- accept_word = false,
            -- accept_line = false,
            -- next = "<C-]>",
            -- prev = "<C-[>",
            dismiss = "<S-Tab>",
          },
        },
      })
    end,
  },

  -- Code Companion
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      -- TODO Get the copilot token from 1Password:
      -- https://codecompanion.olimorris.dev/getting-started.html#configuring-an-adapter
      -- adapters = {
      --   openai = function()
      --     return require("codecompanion.adapters").extend("openai", {
      --       env = {
      --         api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
      --       },
      --     })
      --   end,
      -- },
    },
  },
}
