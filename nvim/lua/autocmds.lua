require "nvchad.autocmds"

-- Set startup directory when VIM loads
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local cwd = vim.fn.getcwd()
    if cwd == "/" or cwd == "/Users/marcwren" then
      local root = "~/Development/"
      if root ~= "" then
        vim.api.nvim_set_current_dir(root)
      end
    end
  end,
})

-- Check open file timestamps when exiting terminal mode.
vim.api.nvim_create_autocmd("TermLeave", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command "checktime"
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
