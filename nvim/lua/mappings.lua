require("nvchad.mappings")

local is_mac = vim.fn.has("macunix") == 1

-- Wrapper around vim.keymap.set that lets the lhs be either a string or a
-- `{ mac = "...", win = "..." }` table. Each platform value can itself be a
-- single key string or a list of keys (all bound to the same rhs). Omit or
-- set a side to `false`/`nil` to skip binding on that platform.
local function map(mode, lhs, rhs, opts)
  if type(lhs) == "table" then
    lhs = is_mac and lhs.mac or lhs.win
    if not lhs then
      return
    end
  end
  if type(lhs) == "table" then
    for _, key in ipairs(lhs) do
      vim.keymap.set(mode, key, rhs, opts)
    end
  else
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- NvChad keys to disable
vim.keymap.del("n", "<C-n>")
vim.keymap.del("n", "<leader>x")
vim.keymap.del("n", "<leader>h")
vim.keymap.del("n", "<leader>v")
vim.keymap.del("n", "<leader>b")
-- vim.keymap.del("n", "<leader>i")

---------------------
-- GENERAL: Insert --
---------------------
-- clipboard
-- Can't use Ctrl + v on Windows because that would overwrite visual block mode
-- so we'll have to use Ctrl + Shift + v
map("i", { mac = "<D-v>", win = "<C-S-v>" }, "<c-r>*", { desc = "Paste" })
map("t", { mac = "<D-v>", win = { "<C-v>", "<C-S-v>" } }, '<C-\\><C-N>"*pi', { desc = "Paste (in terminal)" })
-- close floating windows
map("i", "<D-k>", "<C-o>:fclose<CR>", { desc = "general Close the current floating window" })
-- movement
map("i", "<M-h>", "<S-Left>", { desc = "Move cursor left one word" })
map("i", "<M-l>", "<S-Right>", { desc = "Move cursor right one word" })
---------------------
-- GENERAL: Normal --
---------------------
-- Commands
map("n", ";", ":", { desc = "CMD enter command mode", nowait = true })

-- Cursor movement
-- NvChad maps gj/gk to j/k to work around navigating through wrapped lines
-- but since I don't use line wrapping, I'm turning that off here.
-- See core/mappings.lua for the original functionality.
map("n", "j", "j", { desc = "general Line down" })
map("n", "k", "k", { desc = "general Line up" })
map("n", "H", "^", { desc = "general go to first non-blank character in line" })
map("n", "L", "g_", { desc = "general go to the last non-blank character in line" })
map("n", "<D-h>", "zH", { desc = "general scroll window to left edge" })
map("n", "<D-l>", "zL", { desc = "general scroll window to right edge" })
map("n", "<D-L>", "5zL", { desc = "general scroll window to right edge" })
map("n", "<D-k>", "<C-y>", { desc = "general scroll window to right edge" })
map("n", "<D-K>", "5<C-y>", { desc = "general scroll window to right edge" })
map("n", "<D-j>", "<C-e>", { desc = "general scroll window to left edge" })
map("n", "E", "ge", { desc = "general move to the end of the previous word" })

-- Highlighting
map("n", "<leader>si", "<cmd> Inspect<CR>", { desc = "general Show the highlight group name under the cursor." })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Zoom in/out
vim.g.neovide_scale_factor = 1.0
function ChangeScaleFactor(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

map("n", { mac = "<D-=>", win = "<C-=>" }, function()
  ChangeScaleFactor(1.25)
  -- Simulate pressing Enter to force a redraw
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
end, { desc = "general Zoom In (Neovide)" })
map("n", { mac = "<D-->", win = "<C-->"}, function()
  ChangeScaleFactor(1 / 1.25)
  -- Simulate pressing Enter to force a redraw
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
end, { desc = "general Zoom Out (Neovide)" })

-- Buffers
map("n", "Q", ":close<CR>", { desc = "general Close window" })
map("n", "W", ":wa<CR>", { desc = "general Save all" })
map("n", "<leader>xb", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "general Close current buffer" })
map("n", "<leader>xo", function()
  local tb = require("nvchad.tabufline")
  tb.closeBufs_at_direction("right")
  tb.closeBufs_at_direction("left")
end, { desc = "general Close other buffers" })

-- Splits
-- split and then move cursor back to the original window and position
map("n", "ss", function()
  local view = vim.fn.winsaveview()
  vim.cmd("split")
  vim.fn.winrestview(view)
  vim.cmd("wincmd p")
  vim.fn.winrestview(view)
end, { desc = "general Horizontal split" })

map("n", "vv", ":vsplit<CR>", { desc = "general Vertical split" })

-- Tabs
map("n", "<leader>xt", function()
  require("nvchad.tabufline").closeAllBufs(true)
end, { desc = "general Close current tab" })
map("n", { mac = "<D-]>", win = "<C-S-]>" }, ":tabnext<CR>", { desc = "general Next tab" })
map("n", { mac = "<D-[>", win = "<C-S-[>" }, ":tabprevious<CR>", { desc = "general Previous tab" })

-- window sizing/movement
map({ "n" }, "<Left>", "<cmd>vertical resize -1<CR>", { desc = "move resize window left" })
map({ "n", "t" }, "<S-Left>", "<cmd>vertical resize -10<CR>", { desc = "move resize window left" })
map({ "n", "t" }, { mac = "<D-Left>", win = "<C-Left>" }, "<cmd>winc H<CR>", { desc = "move move window left" })
map({ "n" }, "<Right>", "<cmd>vertical resize +1<CR>", { desc = "move resize window right" })
map({ "n", "t" }, "<S-Right>", "<cmd>vertical resize +10<CR>", { desc = "move resize window right" })
map({ "n", "t" }, { mac = "<D-Right>", win = "<C-Right>" }, "<cmd>winc L<CR>", { desc = "move move window right" })
map({ "n" }, "<Up>", "<cmd>resize -1<CR>", { desc = "move resize window up" })
map({ "n", "t" }, "<S-Up>", "<cmd>resize -10<CR>", { desc = "move resize window up" })
map({ "n", "t" }, { mac = "<D-Up>", win = "<C-Up>" }, "<cmd>winc K<CR>", { desc = "move move window up" })
map({ "n" }, "<Down>", "<cmd>resize +1<CR>", { desc = "move resize window down" })
map({ "n", "t" }, "<S-Down>", "<cmd>resize +10<CR>", { desc = "move resize window down" })
map({ "n", "t" }, { mac = "<D-Down>", win = "<C-Down>" }, "<cmd>winc J<CR>", { desc = "move move window down" })

-- word wrapping
map("n", "Space-r", ":set wrap!<CR>", { desc = "general Toggle word wrapping" })

-- Text manipulation
map("n", "<leader>sj", ":TSJToggle<CR>", { desc = "general Split or Join long lines" })
map("n", "=", "V=", { desc = "general Auto indent current line." })

-- themes
map("n", "<leader>tt", function()
  require("base46").toggle_theme()
end, { desc = "toggle light/dark theme" })

-- Telescope
-- override NvChad's default buffer finder to ignore the current buffer
vim.keymap.set(
  "n",
  "<leader>fb",
  "<cmd> Telescope buffers only_cwd=true sort_lastused=true sort_mru=true ignore_current_buffer=true<CR>",
  { desc = "Find buffers" }
)

---------------------
-- GENERAL: Visual --
---------------------
map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comment" }
)
map("v", "H", "^", { desc = "go to first non-blank character in line" })
map("v", "L", "g_", { desc = "go to the last non-blank character in line" })

----------------------
-- TERMINAL: Insert --
----------------------

-- disable sending Shift + space because it clears the current line in ZSH
-- https://github.com/neovim/neovim/issues/24093
map("t", "<S-Space>", "<Space>", { desc = "Disable Shift + Space in terminals" })
map("t", "<S-Enter>", "<Enter>", { desc = "Disable Shift + Enter in terminals" })
-- navigation in/out of terminal mode
map("t", "<S-Esc>", "<C-\\><C-N>", { desc = "exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "leave terminal left" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "leave terminal right" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "leave terminal down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "leave terminal up" })
map("t", "<D-]>", "<C-\\><C-N>gt", { desc = "Next tab" })
map("t", "<D-[>", "<C-\\><C-N>gT", { desc = "Previous tab" })
-- window sizing/movement
-- map("t", "<S-Left>", "<CMD>vertical resize -10<CR>", { desc = "resize window left" })
-- map("t", "<D-Left>", "<CMD>winc H<CR>", { desc = "move window left" })
-- map("t", "<S-Right>", "<CMD>vertical resize +10<CR>", { desc = "resize window right" })
-- map("t", "<D-Right>", "<CMD>winc L<CR>", { desc = "move window left" })
-- map("t", "<S-Up>", "<CMD>resize -10<CR>", { desc = "resize window up" })
-- map("t", "<D-Up>", "<CMD>winc K<CR>", { desc = "move window left" })
-- map("t", "<S-Down>", "<CMD>resize +10<CR>", { desc = "resize window down" })
-- map("t", "<D-Down>", "<CMD>winc J<CR>", { desc = "move window left" })
-- Clipboard
-- map("t", "<D-v>", '<C-\\><C-N>"*pi', { desc = "Paste" })
-- Clear terminal
map(
  "t",
  "<M-l>",
  function()
    vim.cmd("set scrollback=1")
    vim.cmd("sleep 100m")
    vim.cmd("set scrollback=10000")
  end,
  -- ":set scrollback=1 \\| sleep 100m \\| set scrollback=10000<cr>",
  { desc = "Clear terminal output" }
)

----------------------
-- TERMINAL: Normal --
----------------------
map("n", "<Space>ti", function()
  require("nvchad.term").new({ pos = "float" })
end, { desc = "toggle floating term" })
map("n", "<Space>th", function()
  require("nvchad.term").new({ pos = "sp" })
end)
map("n", "<Space>tv", function()
  require("nvchad.term").new({ pos = "vsp" })
end)

map(
  "n",
  "<leader>cl",
  -- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer
  function()
    if vim.bo.buftype == "terminal" then
      vim.api.nvim_feedkeys("z\r", "n", false)
      -- TODO Try to get the current scrollback so we can reset to that
      local scrollback = vim.bo.scrollback
      vim.bo.scrollback = 1
      if vim.b.terminal_job_id then
        vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x0c")
      end
      vim.cmd("sleep 100m")
      vim.bo.scrollback = scrollback
    end
  end,
  { desc = "Clear terminal output" }
)

-----------------------
-- TERMINAL: Command --
-----------------------
map("c", "<D-v>", "<c-r>*", { desc = "Paste" })
