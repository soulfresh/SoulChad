return {
  -- NvChad Shortcuts
  "NvChad/nvcommunity",
  { import = "nvcommunity.editor.telescope-undo" },
  -- { import = "nvcommunity.lsp.codeactionmenu" },
  -- { import = "nvcommunity.lsp.prettyhover" },
  -- { import = "nvcommunity.motion.hop" },

  -- Use `jk` as the escape key
  { "max397574/better-escape.nvim", enabled = false },

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
