-- Copilot
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = "<Tab>",
          -- accept_word = false,
          -- accept_line = false,
          -- next = "<C-]>",
          -- prev = "<C-[>",
          dismiss = "<S-Tab>",
        },
      },
    }
  end,
}
