local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- Set startup directory when VIM loads
autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local cwd = vim.fn.getcwd()
    if cwd == "/" then
      local root = vim.g.soulvim_root_dir
      if root ~= '' then vim.api.nvim_set_current_dir(root) end
    end
  end
})

-- Check open file timestamps when exiting terminal mode.
autocmd("TermLeave", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command('checktime')
  end
})

-- Try to update lsp progress in status line on update events
-- https://www.reddit.com/r/neovim/comments/orxfs5/how_often_status_line_get_recalculated_which/
-- autocmd("LspProgressUpdate", {
--   -- group = "User",
--   pattern = "*",
--   command = "redrawstatus",
-- })
