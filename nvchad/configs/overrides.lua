local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "graphql",
    "markdown",
    "markdown_inline",
    "rust",
    "toml",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "cssmodules-language-server",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
    "rust-analyzer",
    "codelldb",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  -- sync_root_with_cwd = false,

  actions = {
    change_dir = {
      enable = false,
    },
  },

  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = function ()
        return {
          relative = "editor",
          -- border = "rounded",
          width = 50,
          height = vim.opt.lines:get(),
          -- account for NvChad tabbufline
          row = 1,
          col = 0,
        }
      end
    },
    -- Resize the window on each draw based on the longest line.
    -- adaptive_size = false,
    -- If `false`, the height and width of windows other than nvim-tree will be equalized.
    -- preserve_window_proportions = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        folder = {
          -- For some reason the default folder icon defined by NvChad stopped
          -- working for me recently. This is the icon defined in the v1 branch.
          default = "",
        }
      }
    },
  },
}
  -- TODO use floating window
  -- https://github.com/nvim-tree/nvim-tree.lua/issues/135#issuecomment-1288002079

return M
