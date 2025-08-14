-- Jump motions around current visible file.
return {
  "smoka7/hop.nvim",
  cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine" },
  opts = { keys = "etovxqpdygfblzhckisuran" },
  keys = {
    { "<Space>w", "<CMD> HopWord <CR>", mode = "n", desc = "Hop to any word" },
    { "<Space>c", "<CMD> HopNodes <CR>", mode = "n", desc = "Hop around code context (ie. scope/syntax tree)" },
    { "<Space>s", "<CMD> HopLineStart<CR>", mode = "n", desc = "Hop to line start" },
    -- { "<Space>l", "<CMD> HopWordCurrentLine<CR>", mode = "n", desc = "Hop in this line" },
  },
}
