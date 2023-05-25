- TabBuffline:
  - I this is doing a :cd when switching buffers
  - Limit number of buffers in buffer list
    - get data about a buffer
      https://vi.stackexchange.com/questions/25746/vimscript-how-to-check-if-a-buffer-is-modified
    - If we need buffer last edit time regardless of whether the buffer is saved:
      https://stackoverflow.com/questions/40587626/vim-get-time-of-latest-modification-of-buffer
    - If we need the modified time of a file on disk:
      h: getttime
- Projects alternative: https://github.com/natecraddock/workspaces.nvim
- Focus: https://github.com/Pocco81/true-zen.nvim
- exit a terminal buffer with `<leader>-x`. Current command is <C-d>
- key command to close a tab in the same manner as pressing the tab close button

Terminal cursor?

au VimLeave * set guicursor=a:ver100
