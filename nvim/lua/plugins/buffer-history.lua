-- Buffer History Jump
-- https://github.com/wilfreddenton/history.nvim/blob/master/README.md
return {
  "wilfreddenton/history.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    require("history").setup {
      keybinds = {
        back = "<Space>o",
        forward = "<Space>i",
        view = "<Space>u",
      },
    }
  end,
}
