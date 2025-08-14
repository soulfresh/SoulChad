-- Fugitive
-- Git command interface
return {
  "tpope/vim-fugitive",
  lazy = false,
  init = function()
    vim.keymap.set("n", "<leader>gs", "<cmd> G <cr>", { desc = "Toggle the Git status view" })
  end,
}
