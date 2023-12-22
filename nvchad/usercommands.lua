-- Taboo aliases
vim.api.nvim_create_user_command(
  "TabOpen",
  function (options)
    vim.cmd({ cmd = "TabooOpen", args = options.fargs } )
  end,
  { desc = 'Open a new tab with the given name', nargs = 1 }
)
vim.api.nvim_create_user_command(
  "TabRename",
  function (options)
    vim.cmd({ cmd = "TabooRename", args = options.fargs } )
  end,
  { desc = 'Rename the current tab', nargs = 1 }
)

