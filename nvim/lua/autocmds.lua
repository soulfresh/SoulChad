require("nvchad.autocmds")

-- Set startup directory to ~/Development when nvim is launched without a file.
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.argc() > 0 then
      return
    end
    vim.api.nvim_set_current_dir(vim.fn.expand("~/Development"))
  end,
})

-- Check open file timestamps when exiting terminal mode.
vim.api.nvim_create_autocmd("TermLeave", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command("checktime")
  end,
})

-- Enable cursorline in the active window only.
vim.api.nvim_create_augroup("ActiveWinCursorLine", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = "ActiveWinCursorLine",
  pattern = "*",
  callback = function()
    if not vim.opt_local.cursorline:get() and not vim.opt_local.pvw:get() then
      vim.opt_local.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = "ActiveWinCursorLine",
  pattern = "*",
  callback = function()
    if vim.opt_local.cursorline:get() and not vim.opt_local.pvw:get() then
      vim.opt_local.cursorline = false
    end
  end,
})
