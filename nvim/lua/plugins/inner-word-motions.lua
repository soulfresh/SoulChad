-- Inner Word Motions (camelCase, snake_case, kebap-case)
-- https://github.com/chrisgrieser/nvim-spider
return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "<Space>l",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Move forward within word (camelCase, snake_case, kebap-case)",
    },
    {
      "<Space>h",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Move backward within word (camelCase, snake_case, kebap-case)",
    },
  },
}
