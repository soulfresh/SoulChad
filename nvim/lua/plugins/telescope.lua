return {
  "nvim-telescope/telescope.nvim",
  init = function()
    vim.keymap.set(
      "n",
      "<leader>fb",
      "<cmd> Telescope buffers only_cwd=true sort_lastused=true sort_mru=true ignore_current_buffer=true<CR>",
      { desc = "Find buffers" }
    )
    vim.keymap.set("n", "<leader>ff", require("telescope").extensions.menufacture.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fw", require("telescope").extensions.menufacture.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fo", require("telescope").extensions.menufacture.oldfiles, { desc = "Find oldfiles" })
  end,
}
