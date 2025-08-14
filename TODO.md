### Dotfile Inspiration
- https://github.com/BrunoKrugel/dotfiles

### Easy to map keys:
See:
- Use `:h {key}` to see default for this key
- https://skippi.medium.com/ideas-for-non-leader-vim-mappings-fd32a2769c87#07an
- `:h map-which-keys`
- https://vim.fandom.com/wiki/Unused_keys

- g* (check existing *)
- [{}]* (check existing *)
- Space* (seems like a synonyme for `l`)
- Backspace* (BS seems like a synonyme for `b`)
- \*
- |* (default is jump to column number but I would usually use `:go {num}` to
  jump to a character number in an unprettified text)
- m! m( m) m= m{ m} m; m: m, m. m/ m? m<CR> m<Space> m<BS> 
  (https://skippi.medium.com/ideas-for-non-leader-vim-mappings-fd32a2769c87#07ad)
- '! '@ '# '$ '% '<Tab> '<Space>
- dc ds dy d! d= d< d> yc yd yo ys y! y= =p =P cd cs co cp
- TODO Research uppercase letters

### ZSH Environment
- Currently the install script will install Prezto alongside this repo and then
  symlink things up. However, Prezto suggests forking that repo to make changes.
  Should we just add that code to this repo? Or make it a submodule rather than
  installing it outside this repo and expecting it to be there?
- We should combine the Yadr ZSH configs and my customizations since we don't
  need that distinction any more and it just complicates the configurations.

### Bugs

### General
- Remap some <leader> keys so I'm using leader less often:
  Unused single vim keys: https://vim.fandom.com/wiki/Unused_keys
- Vim Tips plugin: https://github.com/michaelb/vim-tips
  Use this inside of the startup plugin
- LSP error underline color should better match theme

### ZSH
- Yarn run autocomplete: https://github.com/g-plane/zsh-yarn-autocompletions

### Editing
- DOCS surround plugin
    - surround some text with arbitrary characters
    - change the char surrounding some text
- DOCS Focus: https://github.com/Pocco81/true-zen.nvim
- DOCS Move files in nvim-tree will update imports
- Pretty hover:
  - code action menu (deprecated) 
    https://github.com/weilbith/nvim-code-action-menu?tab=readme-ov-file
  - pretty hover (couldn't get it working)
    https://github.com/Fildo7525/pretty_hover
  - lsp saga - includes a bunch of lsp functionality
    https://nvimdev.github.io/lspsaga/hover/
    how to nvim/typescript: https://dev.to/craftzdog/my-neovim-setup-for-react-typescript-tailwind-css-etc-58fb
- File name styling in Telescope: https://github.com/nvim-telescope/telescope.nvim/issues/2014
- Buffer outline plugin: https://github.com/simrat39/symbols-outline.nvim
- Workspace wide diagnostics: 
  https://github.com/neomake/neomake
  or https://github.com/dmmulroy/tsc.nvim
- Treesitter context: stop the function name from being clipped when scrolling
  https://github.com/nvim-treesitter/nvim-treesitter-context
- Turn off coloring plugin in git buffers. For example, we don't want to
    highlight hex codes in the git status window or Flog window because those are
    usually not colors but git object names

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
- Copilot chat window: https://github.com/CopilotC-Nvim/CopilotChat.nvim
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

