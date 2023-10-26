-- Place your global vim settings in the settings.lua file
-- This ensures they override any settings vim settings set by NvChad
require "custom.settings"

local autocmd = vim.api.nvim_create_autocmd

-- ======== --
-- SNIPPETS --
-- ======== --
-- vscode format i.e json files
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets"
-- snipmate format 
-- vim.g.snipmate_snippets_path = "your snippets path"
-- lua format 
-- vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/lua_snippets"

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

-- Limit tabs in tabbufline to just the currently visible buffers and any
-- unsaved buffers.
-- vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
--   callback = function()
--     local max_buf_count = 4
--     -- If there is anything in vim.t.bufs
--     -- if next(vim.t.bufs) ~= nil then
--     if vim.t.bufs and next(vim.t.bufs) ~= nil then
--       local buf_count = 0
--       local bufs = {}
--       for i,bufnr in ipairs(vim.t.bufs) do
--         if bufnr > -1 then
--           local unsaved = vim.api.nvim_buf_get_option(bufnr, "modified")
--           local file = vim.api.nvim_buf_get_name(bufnr)
--           local lastEdit = vim.fn.getftime(file)
--           table.insert(bufs, {bufnr = bufnr, unsaved = unsaved, lastEdit = lastEdit})
--           buf_count = buf_count + 1
--         end
--       end
--       -- sort the table by whether it is unsaved and then the last edit time
--       table.sort(bufs, function (a, b)
--         if a.unsaved then
--           return true
--         elseif b.unsaved then
--           return false
--         else
--           return a.lastEdit < b.lastEdit
--         end
--       end)
--
--       if (buf_count > max_buf_count) then
--         print("too many buffers:", buf_count, max_buf_count)
--         -- vim.t.bufs = table.unpack(bufs, 1, max_buf_count)
--       else
--         -- TODO Where do we get the unmodified buf list here if we close a
--         -- buffer and we had a previous buffer that was not being shown?
--         -- vim.t.bufs = vim.t.bufs
--       end
--       -- vim.t.bufs = vim.t.bufs
--       -- print( vim.inspect( vim.t.bufs))
--     end
--     -- vim.t.bufs = vim.tbl_filter(function(bufnr)
--     --   return vim.api.nvim_buf_get_option(bufnr, "modified")
--     -- end, vim.t.bufs)
--   end,
-- })
