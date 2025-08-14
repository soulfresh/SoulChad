-- Update imports when renaming files in nvim-tree
-- https://github.com/antosha417/nvim-lsp-file-operations
return {
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
}
