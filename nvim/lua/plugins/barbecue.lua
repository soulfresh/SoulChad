-- Winbar file location and context
return {
  "utilyre/barbecue.nvim",
  event = "LspAttach",
  dependencies = {
    "soulfresh/base46",
    "SmiteshP/nvim-navic",
  },
  opts = function()
    local colors = require("base46").get_theme_tb "base_30"

    -- local mix = require("base46.colors").mix
    -- local bg = mix(colors.blue, colors.black, 60)
    local bg = colors.blue

    return {
      -- Whether to use navig to show the current cursor code context.
      show_navic = false,
      exclude_filetypes = { "gitcommit", "git" },
      theme = {
        normal = {
          bg = bg,
          fg = colors.one_bg,
        },
        basename = {
          fg = colors.darker_black,
          bg = bg,
          bold = true,
        },
      },
    }
  end,
  -- config = function(_, opts)
  --   dofile(vim.g.base46_cache .. "navic")
  --   require('barbecue').setup(opts)
  -- end,
}
