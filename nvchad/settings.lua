-- Neovide config
-- Allow passing the command key as the Meta key
vim.g.neovide_input_use_logo = true
-- Pass the Alt key as the Meta key
vim.g.neovide_input_macos_alt_is_meta = false
-- Use an outline for the cursor when the window does not have focus
vim.g.neovide_cursor_unfocused_outline_width = 0.125
vim.g.neovide_fullscreen = true
vim.g.neovide_confirm_quit = true
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_trail_size = 0.5

-- Vim settings
vim.opt.wrap = false
vim.opt.textwidth = 80
vim.opt.winwidth = 80
vim.opt.winminwidth = 10
vim.opt.winheight = 10
vim.opt.winminheight = 10
-- keep x lines visible above and below cursor at all times
vim.opt.scrolloff = 10
-- keep x columns visible left and right of the cursor at all times
vim.opt.sidescrolloff = 10

-- Override NvChad settings
vim.g.mapleader = ","
-- put cursor wrapping back to the vim defaults
vim.opt.whichwrap = "b,s"

-- Turn off swap files
vim.opt.swapfile = false

-- Set the cursor style with a slow blink
vim.opt.guicursor = "n-v-c-sm:block-blinkwait900-blinkoff500-blinkon500-Cursor,i-ci-ve:ver25,r-cr-o:hor20"

-- Set the default shell to bash because it loads faster than my zsh shell.
-- This improves the speed of fugitive and other plugins that need to spawn a
-- shell. For actual nvim terminal windows, we set zsh as the shell when opening
-- the terminal.
vim.opt.shell = "/bin/bash"

-- Snippets path relative to $MYVIMRC. You can use ~/ prefixed paths.
-- See https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#loaders
vim.g.luasnippets_path = "~/.config/nvim/lua/custom/snippets"
-- vscode format i.e json files
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets"

-- Custom filetypes
vim.filetype.add({
	extension = {
		-- Treat .pch files as C++ header files
		pch = "cpp",
    mdx = "mdx",
	},
})

vim.filetype.add({
  pattern = {
    -- Treat .env.* files as shell files
    ['.env'] = "sh",
    -- [".*%.env%..*"] = function(path, bufnr)
    [".env.*"] = function(path, bufnr)
      local contents = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      return require("vim.filetype.detect").sh(path, contents)
    end,
  },
})

