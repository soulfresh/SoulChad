-- Code action menu UI using Telescope
-- https://github.com/aznhe21/actions-preview.nvim?tab=readme-ov-file
return {
  "nvim-telescope/telescope-ui-select.nvim",
  dependencies = { "telescope.nvim" },
  -- keys = { "<leader>ca" },
  event = { "BufRead", "BufWinEnter", "BufNewFile" },
  config = function()
    require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          },
        },
      },
    }
    -- To get ui-select loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require("telescope").load_extension "ui-select"
  end,
}
