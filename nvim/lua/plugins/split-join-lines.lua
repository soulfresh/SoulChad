-- Split join lines
return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter" },
  -- event = { "BufRead", "BufWinEnter", "BufNewFile" },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  config = function()
    require("treesj").setup {
      -- https://github.com/Wansmer/treesj#settings
      use_default_keymaps = false,
      max_join_length = 1000,
    }
    -- tell treesitter to use the markdown parser for mdx files
    vim.treesitter.language.register("markdown", "mdx")
  end,
}
