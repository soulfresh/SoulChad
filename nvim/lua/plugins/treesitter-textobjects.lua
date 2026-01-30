return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add jumps to jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]b"] = "@block.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]B"] = "@block.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[b"] = "@block.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[B"] = "@block.outer",
          },
        },
      },
    })

    -- Custom function to jump to parent scope
    local function goto_parent()
      local ts_utils = require("nvim-treesitter.ts_utils")
      local node = ts_utils.get_node_at_cursor()

      if not node then
        return
      end

      -- Find the parent node that represents a scope
      -- (function, class, block, etc.)
      local parent = node:parent()
      while parent do
        local type = parent:type()
        -- Check for common scope-defining nodes in JS/TS
        if
          type:match("function")
          or type:match("class")
          or type:match("method")
          or type:match("arrow_function")
          or type:match("statement_block")
          or type:match("object")
          or type == "program"
        then
          -- Jump to the start of the parent node
          local start_row, start_col = parent:start()
          vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
          return
        end
        parent = parent:parent()
      end
    end

    -- Map 'cc' to jump to parent scope
    vim.keymap.set("n", "cc", goto_parent, { desc = "treesitter Jump to parent scope", silent = true })
  end,
}
