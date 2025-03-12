return {
  lspconfig = {
    servers = {
      "html",
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
      "eslint",
      -- Using pmizio/typescript-tools.nvim instead
      -- "tsserver",

      -- TODO Try these out
      -- "css_variables",
      -- "cssls",
      -- "css_modules",
      "somesass_ls",
    },
  },
  mason = {
    ensure_installed = {
      "html-lsp",
      "css-lsp",
      "prettier",
      "eslint-lsp",
      -- TODO This isn't installing on startup
      "some-sass-language-server",
    },
  },
  treesitter = {
    ensure_installed = {
      "html",
      "css",
      "json5",
      "javascript",
      "typescript",
      "tsx",
      "graphql",
      "markdown",
      "markdown_inline",
    },
  },
}
