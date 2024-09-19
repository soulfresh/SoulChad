return {
  lspconfig = {
    servers = {
      "html",
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
      "eslint",
      -- Using pmizio/typescript-tools.nvim instead
      -- "tsserver",
    }
  },
  mason = {
    ensure_installed = {
      "html-lsp",
      "css-lsp" ,
      "prettier",
      "eslint-lsp",
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
