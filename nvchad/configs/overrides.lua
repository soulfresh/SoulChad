local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "json",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "cpp",
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
  -- TODO: Some of these aren't being automatically installed because NPM isn't
  -- present when Mason first starts. Two things:
  -- 1. Try uninstalling to see if this is now fixed by adding node to Brewfile
  -- 2. See if ensure_installed is getting installed if I edit this list or only
  --    on NvChad's initial boorstrap
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
    "eslint_d",
    -- TODO Not sure if this is being used
    -- vscode eslint integration
    -- uses the eslint installed either in the current workspace or globally
    -- https://github.com/microsoft/vscode-eslint
    "eslint-lsp",
    -- modern JS debug adapter used in VSCode
    "js-debug-adapter",

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
    },
  },
}

M.telescope = {
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".docker",
      ".git",
      "yarn.lock",
      "go.sum",
      "go.mod",
      "tags",
      "mocks",
      "refactoring",
      "^.git/",
      "^./.git/",
      "^node_modules/",
      "^build/",
      "^dist/",
      "^target/",
      "^vendor/",
      "^lazy%-lock%.json$",
      "^package%-lock%.json$",
    },
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
      },
    },
  },
}

return M
