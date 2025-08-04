
return {
  "stevearc/conform.nvim",
  -- This is what NvChad gives us by default but it conflicts with what I've
  -- added to configs.conform. However, keeping this here temporarily in case
  -- my changes to configs.conform don't work.
  -- init = function()
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     pattern = "*",
  --     callback = function(args)
  --       require("conform").format { bufnr = args.buf }
  --     end,
  --   })
  -- end,
  event = "BufWritePre",
  config = function()
    -- Disable formatting for a buffer `FormatDisable` or globally `FormatDisable!`
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting globally
        vim.g.disable_autoformat = true
      else
        vim.b.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    -- Re-enable formatting for all buffers.
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        -- Take a look at "uncrustify" to see if it gets param formatting any better
        cpp = { "clang-format" },
        ruby = { "rubocop" },
        swift = { "swift" },
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback", lsp_fallback = true }
      end,
    }
  end,
}
