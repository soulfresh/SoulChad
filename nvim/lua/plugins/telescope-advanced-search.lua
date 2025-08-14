-- Customize Telescope file searches by directory, file type, hidden files, etc
-- https://github.com/molecule-man/telescope-menufacture
return {
  "molecule-man/telescope-menufacture",
  dependencies = { "telescope.nvim" },
  event = { "BufRead", "BufWinEnter", "BufNewFile" },
  -- init = function()
  --   -- Replace these default mappings with the ones for telescope_menufature
  --   vim.keymap.del("n", "<leader>ff")
  --   vim.keymap.del("n", "<leader>fw")
  --   vim.keymap.del("n", "<leader>fo")
  -- end,
  config = function()
    require("telescope").load_extension "menufacture"
  end,
}
