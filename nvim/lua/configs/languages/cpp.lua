return {
  lspconfig = {
    servers = {
      "clangd",
      "cmake",
    },
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
