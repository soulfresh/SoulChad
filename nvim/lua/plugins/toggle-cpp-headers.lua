-- Toggle Cpp header files
return {
  "jakemason/ouroboros",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = "cpp",
  opts = {
    switch_to_open_pane_if_possible = true,
  },
  keys = {
    { "th", "<cmd>Ouroboros<CR>", mode = "n", desc = "Cpp toggle header file" },
  },
}
