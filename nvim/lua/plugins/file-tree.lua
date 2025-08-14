-- Default configuration can be found in
-- ~/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/nvimtree.lua
return {
  "nvim-tree/nvim-tree.lua",
  init = function()
    vim.keymap.set("n", "<C-\\>", "<cmd> NvimTreeToggle <CR>", { desc = "toggle nvimtree" })
  end,
  opts = {
    -- One possible way to reduce the overhead of nvim-tree if nvim is hanging
    -- actions = {
    --   change_dir = {
    --     enable = false,
    --   },
    -- },

    view = {
      float = {
        enable = true,
        quit_on_focus_loss = true,
        open_win_config = function()
          return {
            relative = "editor",
            -- border = "rounded",
            width = 50,
            height = vim.opt.lines:get(),
            -- account for NvChad tabbufline
            row = 1,
            col = 0,
          }
        end,
      },
      -- Resize the window on each draw based on the longest line.
      -- adaptive_size = false,
      -- If `false`, the height and width of windows other than nvim-tree will be equalized.
      -- preserve_window_proportions = true,
    },
  },
}
