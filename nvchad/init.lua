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

-- Set startup directory
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
