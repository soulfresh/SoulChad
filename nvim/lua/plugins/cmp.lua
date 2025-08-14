-- completion menu
return {
  "hrsh7th/nvim-cmp",
  opts = function()
    local cmp = require "cmp"
    local opts = require "nvchad.configs.cmp"

    -- Don't preselect the first item. While it's convenient most of the time,
    -- it causes issues when you're at the end of a line and want to start a
    -- new line. If cmp is open, it will select the first completion instead.
    opts.preselect = cmp.PreselectMode.None
    opts.completion = { completeopt = "menu,menuone,noselect" }

    -- Override NvChad mappings
    opts.mapping["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      -- Don't preselect the first item.
      select = false,
    }
    opts.mapping["<C-Space>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end)

    -- Override NvChad's Tab mappings to remove Tab usage with cmp because:
    -- 1. I use <C-n>/<C-p> to select completions
    -- 2. I generally don't want completions when expanding a snippet
    -- 3. I use <Tab> for Copilot completions
    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      -- Do snippet if one has been selected from the cmp menu. Otherwise
      -- fallback to Copilot.
      local luasnip = require "luasnip"
      -- If something is selected in the cmp menu
      local shouldExpand = cmp.get_active_entry() and luasnip.expand_or_locally_jumpable()
      -- Or we are currently in snippet mode
      -- If in_snippet doesn't work, try get_active_snip
      local shouldJump = luasnip.in_snippet() and luasnip.expand_or_locally_jumpable()
      if shouldExpand or shouldJump then
        require("luasnip").expand_or_jump()
        -- elseif cmp.visible() then
        --   cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" })
    opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
      --   cmp.select_prev_item()
      if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })

    return opts
  end,
}
