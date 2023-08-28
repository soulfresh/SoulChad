local M = {}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ""
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

M.disable = false

M.override_options = {
  buttons = {
    type = "group",
    val = {
      -- button(",fp", "  Projects  ", ":Telescope projects<CR>"),
      button(",ff", "  Find File  ", ":Telescope find_files<CR>"),
      button(",fo", "  Recent File  ", ":Telescope oldfiles<CR>"),
      button(",fw", "  Find Word  ", ":Telescope live_grep<CR>"),
      button(",bm", "  Bookmarks  ", ":Telescope marks<CR>"),
      button(",th", "  Themes  ", ":Telescope themes<CR>"),
      button(",se", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
    },
    opts = {
        spacing = 1,
    },
  },
  header = {
    type = "text",
    val = {

      "█▀ █▀█ █░█ █░░ █░█ █ █▀▄▀█",
      "▄█ █▄█ █▄█ █▄▄ ▀▄▀ █ █░▀░█",


      -- "▟▛ ██ ▙▟ ▙▄ ▚▞ █ ▛▚▞▜ ",
      --
      --
      -- "█─▄▄▄▄█─▄▄─█▄─██─▄█▄─▄███▄─█─▄█▄─▄█▄─▀█▀─▄█",
      -- "█▄▄▄▄─█─██─██─██─███─██▀██▄▀▄███─███─█▄█─██",
      -- "▀▄▄▄▄▄▀▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▄▄▀▀▀▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▀",
      --
      --
      -- "█▀▀ █▀▀█ █░░█ █░░ ▀█░█▀ ░▀░ █▀▄▀█",
      -- "▀▀█ █░░█ █░░█ █░░ ░█▄█░ ▀█▀ █░▀░█",
      -- "▀▀▀ ▀▀▀▀ ░▀▀▀ ▀▀▀ ░░▀░░ ▀▀▀ ▀░░░▀",
      --
      --
      -- "█▀▀ █▀▀█ █░░█ █░░",
      -- "▀▀█ █░░█ █░░█ █░░",
      -- "▀▀▀ ▀▀▀▀ ░▀▀▀ ▀▀▀",
      -- " █░░█ ▀█▀ █▀▄▀█░ ",
      -- " ██ █  █░░█░█░█░ ",
      -- "  ▀█▀ ███░█░▀░█  ",

    },
    opts = {
        position = "center",
        hl = "Type",
        -- wrap = "overflow";
    },
  },
}

return M
