---@type MappingsTable
local M = {}

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- NEOVIDE
vim.g.neovide_scale_factor = 1.0
function ChangeScaleFactor(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

M.disabled = {
	n = {
		-- replace NvChad's buffer close with something harder to hit
		["<leader>x"] = {},
	},
	i = {
		["<C-e>"] = {},
	},
}

M.general = {
	i = {
		-- movement
		-- ["<C-O>"] = {
		-- 	function()
		-- 		t("<Up>")
		-- 	end,
		-- 	"Move cursor up one line",
		-- },
		-- ["<C-o>"] = {
		-- 	function()
		-- 		t("<Down>")
		-- 	end,
		-- 	"Move cursor down one line",
		-- },
		["<M-h>"] = {
			"<S-Left>",
			"Move cursor left one word",
		},
		["<M-l>"] = {
			"<S-Right>",
			"Move cursor right one word",
		},

		-- clipboard
		["<D-v>"] = { "<c-r>*", "Paste" },

		-- Tabs
		["<D-]>"] = { "<cmd> tabnext<CR>", "Next tab", opts = {silent = true} },
		["<D-[>"] = { "<cmd> tabprevious<CR>", "Previous tab", opts = {silent = true} },
	},
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },

		["<leader>si"] = {
			"<cmd> Inspect<CR>",
			"Show Highlight: show the highlight group name under the cursor.",
		},

    -- Zoom
    ["<D-+>"] = {
			function()
				ChangeScaleFactor(1.25)
			end,
			"Zoom In (Neovide)",
		},
		["<D-->"] = {
			function()
				ChangeScaleFactor(1 / 1.25)
			end,
			"Zoom Out (Neovide)",
		},

		-- Cursor movement
		-- NvChad maps gj/gk to j/k to work around navigating through wrapped lines
		-- but since I don't use line wrapping, I'm turning that off here.
		-- See core/mappings.lua for the original functionality.
		["j"] = { "j", "Line down" },
		["k"] = { "k", "Line up" },
		["H"] = { "^", "go to first non-blank character in line" },
		["L"] = { "g_", "go to the last non-blank character in line" },
		["<D-h>"] = { "zH", "scroll window to left edge" },
		["<D-l>"] = { "zL", "scroll window to right edge" },
		["<D-L>"] = { "5zL", "scroll window to right edge" },
		["<D-k>"] = { "<C-y>", "scroll window to right edge" },
		["<D-K>"] = { "5<C-y>", "scroll window to right edge" },
		["<D-j>"] = { "<C-e>", "scroll window to left edge" },
		["E"] = { "ge", "move to the end of the previous word" },

		-- buffers
		["Q"] = { ":close<CR>", "close window" },
		["W"] = { ":wa<CR>", "save all" },
		["<leader>xb"] = {
			function()
				require("nvchad.tabufline").close_buffer()
			end,
			"Close current buffer",
		},
		["<leader>xo"] = {
			function()
				require("nvchad.tabufline").closeOtherBufs()
			end,
			"Close other buffers",
		},

		-- splits
		["ss"] = { ":split<CR><C-w>k", "horizontal split" },
		["vv"] = { ":vsplit<CR><C-w>h", "vertical split" },

		-- tabs
		-- ["<leader>ts"] = { ":tab split", "open current buffer in new tab" },
		["<D-]>"] = { ":tabnext<CR>", "Next tab" },
		["<D-[>"] = { ":tabprevious<CR>", "Previous tab" },
		["<leader>xt"] = {
			function()
				require("nvchad.tabufline").closeAllBufs("closeTab")
			end,
			"Close current tab",
		},

		-- window sizing/movement
		["<Left>"] = { ":vertical resize -1<CR>", "resize window left" },
		["<S-Left>"] = { ":vertical resize -10<CR>", "resize window left" },
		["<D-Left>"] = { ":winc H<CR>", "move window left" },
		["<Right>"] = { ":vertical resize +1<CR>", "resize window right" },
		["<S-Right>"] = { ":vertical resize +10<CR>", "resize window right" },
		["<D-Right>"] = { ":winc L<CR>", "move window left" },
		["<Up>"] = { ":resize -1<CR>", "resize window up" },
		["<S-Up>"] = { ":resize -10<CR>", "resize window up" },
		["<D-Up>"] = { ":winc K<CR>", "move window left" },
		["<Down>"] = { ":resize +1<CR>", "resize window down" },
		["<S-Down>"] = { ":resize +10<CR>", "resize window down" },
		["<D-Down>"] = { ":winc J<CR>", "move window left" },

		-- comments
		-- ["<C-Space>"] = { "<leader>/", "comment line"},

		-- highlighting
		["//"] = { "<cmd> noh <CR>", "no highlight" },

		-- text manipulation
		["<leader>sj"] = { ":TSJToggle<CR>", "Split or Join long lines" },
		["="] = { "V=", "Auto indent current line." },

		-- themes
		["<leader>tt"] = {
			function()
				require("base46").toggle_theme()
			end,
			"toggle light/dark theme",
		},

		["gx"] = { ":execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>", "open URL under cursor" },
	},
	v = {
		["H"] = { "^", "go to first non-blank character in line" },
		["L"] = { "g_", "go to the last non-blank character in line" },
	},
}

M.telescope = {
	n = {
		["<leader>fb"] = {
			"<cmd> Telescope buffers only_cwd=true sort_lastused=true sort_mru=true ignore_current_buffer=true<CR>",
			"Find buffers",
		},
	},
}

M.lspconfig = {
	n = {
		["[d"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end,
			"Goto prev",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next",
		},
	},
}

M.vimtree = {
	n = {
		-- TODO Remove C-n?
		["<C-\\>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
	},
}

M.nvterm = {
	n = {
		["<leader>i"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"toggle floating term",
		},

		["<leader>cl"] = {
			-- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer
			function()
				if vim.bo.buftype == "terminal" then
					vim.api.nvim_feedkeys("z\r", "n", false)
					-- TODO Try to get the current scrollback so we can reset to that
					-- local scrollback = vim.b.scrollback
					vim.opt.scrollback = 1
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "t", true)
					vim.cmd("sleep 100m")
					vim.opt.scrollback = 10000
				end
			end,
			"Clear terminal output",
		},
	},
	t = {
    -- disable sending Shift + space because it clears the current line in ZSH
    -- https://github.com/neovim/neovim/issues/24093
    ["<S-Space>"] = {"<Space>", "Disable Shift + Space in terminals"},
    ["<S-Enter>"] = {"<Enter>", "Disable Shift + Enter in terminals"},

		-- navigation in/out of terminal mode
		["<Esc><Esc>"] = { "<C-\\><C-N>", "exit terminal mode" },
		["<C-h>"] = { "<C-\\><C-N><C-w>h", "leave terminal left" },
		["<C-l>"] = { "<C-\\><C-N><C-w>l", "leave terminal right" },
		["<C-j>"] = { "<C-\\><C-N><C-w>j", "leave terminal down" },
		["<C-k>"] = { "<C-\\><C-N><C-w>k", "leave terminal up" },
		["<D-]>"] = { "<C-\\><C-N>gt", "Next tab" },
		["<D-[>"] = { "<C-\\><C-N>gT", "Previous tab" },

		-- window sizing/movement
		["<S-Left>"] = { ":vertical resize -10<CR>", "resize window left" },
		["<D-Left>"] = { ":winc H<CR>", "move window left" },
		["<S-Right>"] = { ":vertical resize +10<CR>", "resize window right" },
		["<D-Right>"] = { ":winc L<CR>", "move window left" },
		["<S-Up>"] = { ":resize -10<CR>", "resize window up" },
		["<D-Up>"] = { ":winc K<CR>", "move window left" },
		["<S-Down>"] = { ":resize +10<CR>", "resize window down" },
		["<D-Down>"] = { ":winc J<CR>", "move window left" },

		-- Clipboard
		["<D-v>"] = { '<C-\\><C-N>"*pi', "Paste" },

		-- Clear terminal
		["<M-l>"] = {
			function()
				vim.cmd("set scrollback=1")
				vim.cmd("sleep 100m")
				vim.cmd("set scrollback=10000")
			end,
			-- ":set scrollback=1 \\| sleep 100m \\| set scrollback=10000<cr>",
			"Clear terminal output",
		},
	},
  -- Command mode
  c = {
		["<D-v>"] = { "<c-r>*", "Paste" },
  }
}

M.fugitive = {
	n = {
		["<leader>gs"] = { "<cmd> G <cr>", "Toggle the Git status view" },
	},
}

M.undo = {
	n = {
		["<leader>u"] = { "<cmd> Telescope undo <cr>", "Find Undo: show undo history" },
	},
}

M.easyalign = {
	n = {
		["<leader>ta"] = { "<Plug>(EasyAlign)", "Align/tabularize" },
	},
	v = {
		["<leader>ta"] = { "<Plug>(EasyAlign)", "Align/tabularize" },
	},
}

M.jester = {
  n = {
    ["<leader>ts"] = {
      function() 
        require('jester').run()
      end,
      "Test Start: Run the test under the cursor"
    }
  }
}

-- https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
M.dap = {
  n = {
    -- TODO Terminate an active debug session
    -- TODO Restart the active debug session
    -- Provide multiple keybindings for terminals that don't support Meta and Command.
    -- Continue
    ["<F5>"] = { function() require('dap').continue() end, "Debug Continue" },
    ["<D-\\>"] = { function() require('dap').continue() end, "Debug Continue" },
    -- Close UI
    ["<leader>xd"] = { function() require('dapui').close() end, "Debug Close UI" },
    ["<D-|>"] = { function() require('dapui').close() end, "Debug Close UI" },
    -- Step Over
    ["<D-'>"] = { function() require('dap').step_over() end, "Debug Step Over" },
    ["<F10>"] = { function() require('dap').step_over() end, "Debug Step Over" },
    -- Step Into
    ["<D-;>"] = { function() require('dap').step_into() end, "Debug Step Into" },
    ["<F11>"] = { function() require('dap').step_into() end, "Debug Step Into" },
    -- Step Out
    ["<D-:>"] = { function() require('dap').step_out() end, "Debug Step Out" },
    ["<F12>"] = { function() require('dap').step_out() end, "Debug Step Out" },
    -- Toggle Breakpoint
    ["<D-b>"] = { function() require('dap').toggle_breakpoint() end, "Debug Toggle Breakpoint" },
    -- Set Conditional Breakpoint
    ["<D-B>"] = { 
      function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      "Debug Toggle Conditional Breakpoint"
    },
    -- Disable Breakpoints
    ["<D-F8>"] = { function() require('dap') end, "Enable/Disable All Breapoints" },
  }
}

return M
