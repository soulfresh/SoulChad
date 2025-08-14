
-- Code Companion
return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Use Fidget.nvim to show progress for requests
    -- "j-hui/fidget.nvim",
    -- inline spinner
    -- This was causing nvim to freeze after the second chat message.
    -- TODO Implement this into my status line:
    -- https://github.com/NvChad/ui/blob/dc4950f5bd4117e2da108b681506c908b93d4a62/doc/nvui.txt#L305
    "franco-ruggeri/codecompanion-spinner.nvim",
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
  opts = {
    extensions = {
      spinner = {}
    },
    strategies = {
      chat = {
        adapter = "gemini",
        -- See:
        -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/githubmodels.lua
        -- https://github.com/baseddxyz/BASEDDvim/blob/main/lua%2Fplugins%2Fai.lua
        model = "gemini-2.5-pro",
        keymaps = {
          clear = {
            modes = {
              n = "<leader>cl"
            }
          }
        }
      },
      inline = {
        adapter = "copilot",
      },
    },
    -- TODO Get the copilot token from 1Password:
    -- https://codecompanion.olimorris.dev/getting-started.html#configuring-an-adapter
    adapters = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd:op read op://Personal/Google Gemini API Key/credential --no-newline",
          },
        })
      end,
    --   openai = function()
    --     return require("codecompanion.adapters").extend("openai", {
    --       env = {
    --         api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
    --       },
    --     })
    --   end,
    },
  },
  -- init = function()
  --   -- Integrate with Fidget spinner
  --   require("configs.codecompanion-fidget"):init()
  -- end,
}
