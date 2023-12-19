### Dotfile Inspiration
- https://github.com/BrunoKrugel/dotfiles

### Bugs
- Copilot-cmp removes my non-copilot results from the menu sometimes

### General
- Vim Tips plugin: https://github.com/michaelb/vim-tips
  Use this inside of the startup plugin

### Editing
- DOCS surround plugin
    - surround some text with arbitrary characters
    - change the char surrounding some text
- DOCS Focus: https://github.com/Pocco81/true-zen.nvim
- DOCS Move files in nvim-tree will update imports
- Buffer outline plugin: https://github.com/simrat39/symbols-outline.nvim
- Hide virtual_text
- Workspace wide diagnostics: 
  https://github.com/neomake/neomake
  or https://github.com/dmmulroy/tsc.nvim
- Treesitter context: stop the function name from being clipped when scrolling
  https://github.com/nvim-treesitter/nvim-treesitter-context
- Turn off coloring plugin in git buffers

### Testing
- Neotest https://github.com/nvim-neotest/neotest-jest
  No debugging with Jest yet but might be worth playing with

### Buffers/Tabs
- Winbar (from nvchad community): https://github.com/utilyre/barbecue.nvim
- Buffer history: https://github.com/ton/vim-bufsurf
- Close all buffers except current
- TabBuffline:
  - Reorder tabs
  - Limit number of buffers in buffer list
    - get data about a buffer
      https://vi.stackexchange.com/questions/25746/vimscript-how-to-check-if-a-buffer-is-modified
    - If we need buffer last edit time regardless of whether the buffer is saved:
      https://stackoverflow.com/questions/40587626/vim-get-time-of-latest-modification-of-buffer
    - If we need the modified time of a file on disk:
      h: getftime

### Snippets/Copilot/Completion coordination
- Use <C-Enter> to select a cmp item unless we have selected something other
  than the first item in the list.
    - Using <Enter> to select an item from the completion menu causes unexpected
      results when trying to start a new line of code. Is there a better
      keybinding so wrapping code doesn't select a completion if that's not what we
      wanted to do? Currently I have to <C-Enter> to start a new line of code
- Turn off Tab insertion of snippets (but not completion) because it interferes
  with copilot suggestions.
  - Type `xit` and wait for but a copilot suggestion and the snippet completion
  - Make sure the snippet completion is highlighted in the cmp dialog if it is
    not the first entry
  - press Tab
  - We want the copilot suggestion to be completed. The snippet should only be
    inserted if we hit Enter
  - Make sure that after inserting a snippet, that Tab completion continues to
    function (copilot should be disabled during the tab completion phase)
- Sometimes pressing Tab (maybe the first Tab press) after a multiline copilot suggestion
  if the CMP menu isn't shown, the suggestion is not inserted as expected.
- Copilot suggestions are shown in the CMP window inconsistently (mostly not)

### Git
- Better file revision history:
    https://www.reddit.com/r/neovim/comments/w1q8eh/efficiently_review_past_commits_of_specific_file/
    https://github.com/Civitasv/runvim/blob/master/keymaps.md

### Rust
- Manage crates
  https://github.com/Saecki/crates.nvim

### Terminal
- Terminal insert icon
  I've tried all the things. This will have to wait until this issue is resolved:
  https://github.com/neovim/neovim/issues/3681
- "& " in terminal mode clears the terminal and changes vim mode. ZSH config
  issue?
- How to exit a terminal buffer and any processes it is running?

### Projects
- Projects alternative: https://github.com/natecraddock/workspaces.nvim
- alpha:
  - remove projects button for now
  - tip of the day in footer
  - nvchad cheatsheet button
  - center vertically

