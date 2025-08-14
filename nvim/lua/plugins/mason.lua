return {
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
      "some-sass-language-server",

      -- cpp stuff
      "clangd",
      "codelldb",

      -- rust stuff
      "rust-analyzer",

      -- swift
      -- Required by sourcekit
      "tree-sitter-cli",

      -- ruby stuff
      -- Installing these with Mason is counter productive because they will
      -- be installed globally based on the ruby version available to Mason
      -- when it installs them. Since I'll be using `rbenv` or similar to
      -- manage ruby versions in the shell environment, I've instead updated
      -- my nvim root `init.lua` to correctly source `rbenv` so that
      -- `lsp_servers` are run based on the project ruby version and config.
      -- "ruby-lsp",
      -- "rubocop"
    },
  },
}
