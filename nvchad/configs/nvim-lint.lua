local present, lint = pcall(require, "linter")

if not present then
  return
end

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- TODO Can I replace null-ls with nvim-lint?
lint.linters_by_ft = {
  lua = {
    "luacheck",
  },
  -- yaml = {
  --   "yamllint",
  --   "actionlint",
  -- },
  -- codespell = { "codespell" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}
