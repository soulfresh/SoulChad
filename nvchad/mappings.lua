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

M.general = {
  i = {
    ["<C-O>"] = {
      function()
        t('<Up>')
      end,
      "Move cursor up one line"
    },
    ["<C-o>"] = {
      function()
        t('<Down>')
      end,
      "Move cursor down one line"
    },
    ["<D-v>"] = { '"+p', "Paste" }
  },
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["<leader>si"] = {
      function()
        vim.cmd([[
          echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
        ]])
      end,
      "Show Highlight: show the highlight group name under the cursor."
    },

    -- Zoom
    ["+"] = {
      function()
        ChangeScaleFactor(1.25)
      end,
      "Zoom + (Neovide)",
    },
    ["-"] = {
      function()
        ChangeScaleFactor(1/1.25)
      end,
      "Zoom - (Neovide)",
      { silent = false }
    },

    -- Cursor movement
    -- NvChad maps gj/gk to j/k to work around navigating through wrapped lines
    -- but since I don't use line wrapping, I'm turning that off here.
    -- See core/mappings.lua for the original functionality.
    ["j"] = { "j", "Line down"},
    ["k"] = { "k", "Line up"},
    ["H"] = { "^", "go to first non-blank character in line"},
    ["L"] = { "g_", "go to the last non-blank character in line"},
    ["<D-h>"] = {"zH", "scroll window to left edge"},
    ["<D-l>"] = {"zL", "scroll window to right edge"},
    ["<D-k>"] = {"<C-y>", "scroll window to right edge"},
    ["<D-j>"] = {"<C-e>", "scroll window to left edge"},

    -- buffers
    ["Q"] = { ":close<CR>", "close window" },
    ["<D-q>"] = { ":qa<CR>", "quit Neovim" },
    ["W"] = { ":wa<CR>", "save all" },

    -- splits
    ["ss"] = { ":split<CR><C-w>k", "horizontal split"},
    ["vv"] = { ":vsplit<CR><C-w>h", "vertical split"},

    -- tabs
    ["<leader>ts"] = { ":tab split", "open current buffer in new tab"},
    ["<D-]>"] = { ":tabnext<CR>", "Next tab" },
    ["<D-[>"] = { ":tabprevious<CR>", "Previous tab" },

    -- window sizing/movement
    ["<Left>"] = { ":vertical resize -1<CR>", "resize window left"},
    ["<S-Left>"] = { ":vertical resize -10<CR>", "resize window left"},
    ["<D-Left>"] = { ":winc H<CR>", "move window left"},
    ["<Right>"] = { ":vertical resize +1<CR>", "resize window right"},
    ["<S-Right>"] = { ":vertical resize +10<CR>", "resize window right"},
    ["<D-Right>"] = { ":winc L<CR>", "move window left"},
    ["<Up>"] = { ":resize -1<CR>", "resize window up"},
    ["<S-Up>"] = { ":resize -10<CR>", "resize window up"},
    ["<D-Up>"] = { ":winc K<CR>", "move window left"},
    ["<Down>"] = { ":resize +1<CR>", "resize window down"},
    ["<S-Down>"] = { ":resize +10<CR>", "resize window down"},
    ["<D-Down>"] = { ":winc J<CR>", "move window left"},

    -- comments
    ["<C-Space>"] = { "<leader>/", "comment line"},

    -- highlighting
    ["//"] = { "<cmd> noh <CR>", "no highlight" },

    -- themes
    ["<leader>tt"] = { function()
      require("base46").toggle_theme()
    end, "toggle light/dark theme"},
  },
  v = {
    ["H"] = { "^", "go to first non-blank character in line"},
    ["L"] = { "g_", "go to the last non-blank character in line"},
  },
  t = {
    ["<D-v>"] = { '"+p', "Paste" }
  },
}

M.lspconfig = {
  n = {
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev({ float = { border = "rounded" }})
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next({ float = { border = "rounded" }})
      end,
      "Goto next",
    },
  },
}

M.vimtree = {
  n = {
    -- TODO Remove C-n?
    ["<C-\\>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
  }
}

M.nvterm = {
  n = {
    ["<leader>i"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "toggle floating term",
    },

    ["<leader>cl"] = {
      -- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer
      function()
        if vim.bo.buftype == "terminal" then
          vim.api.nvim_feedkeys('z\r', 'n', false)
          -- TODO Try to get the current scrollback so we can reset to that
          -- local scrollback = vim.b.scrollback
          vim.opt.scrollback = 1
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-l>', true, false, true), 't', true)
          vim.cmd('sleep 100m')
          vim.opt.scrollback = 10000
        end
      end,
      "Clear terminal output"
    }
  },

  t = {
    -- navigation in/out of terminal mode
    ["<Esc><Esc>"] = { "<C-\\><C-N>", "exit terminal mode"},
    ["<C-h>"] = { "<C-\\><C-N><C-w>h", "leave terminal left" },
    ["<C-l>"] = { "<C-\\><C-N><C-w>l", "leave terminal right" },
    ["<C-j>"] = { "<C-\\><C-N><C-w>j", "leave terminal down" },
    ["<C-k>"] = { "<C-\\><C-N><C-w>k", "leave terminal up" },

    ["<M-l>"] = {
      function()
        vim.cmd('set scrollback=1')
        vim.cmd('sleep 100m')
        vim.cmd('set scrollback=10000')
      end,
      -- ":set scrollback=1 \\| sleep 100m \\| set scrollback=10000<cr>",
      "Clear terminal output"
    }
  }
}

M.fugitive = {
  n = {
    ['<leader>gs'] = { "<cmd> G <cr>", "Toggle the Git status view"},
  }
}

M.undo = {
  n = {
    ["<leader>fu"] = { "<cmd> Telescope undo <cr>", "Find Undo: show undo history" },
  }
}

return M
