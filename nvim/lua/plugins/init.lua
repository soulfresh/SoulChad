return {
  -- NvChad Shortcuts
  "NvChad/nvcommunity",
  { import = "nvcommunity.editor.telescope-undo" },
  -- { import = "nvcommunity.lsp.codeactionmenu" },
  -- { import = "nvcommunity.lsp.prettyhover" },
  -- { import = "nvcommunity.motion.hop" },

  -- Use `jk` as the escape key
  { "max397574/better-escape.nvim", enabled = false },

  -- Code action menu UI using Telescope
  -- https://github.com/aznhe21/actions-preview.nvim?tab=readme-ov-file
  -- {
  --   "nvim-telescope/telescope-ui-select.nvim",
  --   dependencies = { "telescope.nvim" },
  --   -- keys = { "<leader>ca" },
  --   event = { "BufRead", "BufWinEnter", "BufNewFile" },
  --   config = function()
  --     require("telescope").setup {
  --       extensions = {
  --         ["ui-select"] = {
  --           require("telescope.themes").get_dropdown {
  --             -- even more opts
  --           },
  --         },
  --       },
  --     }
  --     -- To get ui-select loaded and working with telescope, you need to call
  --     -- load_extension, somewhere after setup function:
  --     require("telescope").load_extension "ui-select"
  --   end,
  -- },

  -- {
  --   "tpope/vim-rbenv",
  --   ft = "ruby",
  -- },

  -- Adds node path from nvm when changing nvim's directory.
  -- This is throwing an error for me at the moment and I need more time debug
  -- it.
  -- {
  --   "pipoprods/nvm.nvim",
  --   config = true,
  --   event = {
  --     -- "DirChangedPre",
  --     -- "VimLeavePre",
  --     "DirChanged",
  --     -- "VimEnter",
  --   },
  -- },
}
