-- TODO It might be nice to map the built in `tabnew` to our `TabOpen`
-- making the tab name optional
-- https://stackoverflow.com/questions/61100302/is-there-a-way-to-overwrite-vims-default-command
-- Taboo aliases
vim.api.nvim_create_user_command(
  "TabOpen",
  function (options)
    vim.cmd({ cmd = "TabooOpen", args = options.fargs } )
  end,
  { desc = 'Open a new tab with the given name', nargs = 1 }
)
vim.api.nvim_create_user_command(
  "TabNew",
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

-- Git Commands
vim.api.nvim_create_user_command(
  "LocalBranches",
  function()
    vim.cmd({cmd = "Telescope", args = {"git_branches", "show_remote_tracking_branches=false"}})
  end,
  {desc = "Show current locally checked out git branches"}
)

vim.api.nvim_create_user_command(
  "CloseAllFloatingWindows",
    function()
      vim.cmd({cmd = "lua require('utils').close_all_floating_windows()"})
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win); 
        if config.relative ~= "" then
          vim.api.nvim_win_close(win, false); print('Closing window', win) 
        end 
      end
    end,
    {desc = "Close all floating windows"}
)

-- vim.api.nvim_create_user_command(
--   "FlipNavigationHand",
--   function()
--     -- Navigation remappings
--     local navigation_mappings = {
--       h = "g",
--       j = "f",
--       k = "d",
--       l = "s",
--     }
--
--     -- Conflicting key remappings
--     local conflicting_mappings = {
--       g = "h",
--       f = "h",
--       d = "k",
--     }
--
--     -- Apply navigation remappings
--     for original, new in pairs(navigation_mappings) do
--       vim.api.nvim_set_keymap("n", new, original, { noremap = true, silent = true })
--     end
--
--     -- Apply conflicting key remappings
--     for original, new in pairs(conflicting_mappings) do
--       vim.api.nvim_set_keymap("n", new, original, { noremap = true, silent = true })
--     end
--   end,
--   {desc = "Flip navigation keyboard shortcuts to the left hand."}
-- )
