return {
  lspconfig = {
    servers = {
      "clangd"
    }
  },
  mason = {
    ensure_installed = {
      "clangd",
      "codelldb",
    },
  },
  treesitter = {
    ensure_installed = {
      "c",
      "cpp",
    },
  },
}
