# SoulVim
NeoVim customizations on top of NvChad

## Setup

TODO List out the NvChad prereqs here

For the easiest setup clone this repo and then run `./install.sh`. This command will:

- Optionally install homebrew and development software (see Brewfile for a list
  of software)
- setup Pretzo for command prompt customizations
- install nerd fonts via `GetNerdFonts` (aka `getnf`)
- clone NvChad alongside this repo
- symlink NvChad into your `.config/nvim` folder, backing up your existing nvim configs.

Once installed, copy `nvchad/chadrc.lua.example` to `nvchad/chadrc.lua` so you
can further customize your setup:

`cp nvchad/chadrc.lua.example nvchad/chadrc.lua`

All custom vim configuration is stored in the `nvchad` folder and will be symlinked into NvChad.

> Good to know: Nvim settings are stored separately from your Vim settings and
> will not conflict.

Run `nvim` to start NvChad or open Neovide if you're using that.

### Uninstall

Run `./uninstall` to remove the NvChad symlinks and restore any previous nvim setup you had. It will not
remove the NvChad repo clone that was checked out along side this repo. You can do that if you want.

## NerdFonts
This gives us fonts with ligatures and icons that work with vim. Without this you will see a
lot of broken icons in vim.

https://github.com/ronniedroid/getnf

For me this was installed into ~/.local/bin which wasn't showing up in my bash.
So I added that folder as a PATH in my .zshrc file.

Once installed run `getnf` and install the `FiraCode` font which is what
we have set as the default in `config/chadrc.lua`. You can also set this in
iTerm under Preferences -> Profile -> Text.

## Keymaps

Definitions:
- `<leader>` = the "," character
- `<D->` = the Command key
- `<M->` = the Alt key on Mac (depending on how your terminal app is setup)
- `<C->` = the Ctrl key

Keymap help:
- `<leader>tk` Search for a keymap
- `<leader>` Shows keymaps help after 1 second

## Plugins

- [NvChad Plugins](https://nvchad.com/features)
- [Projects](#projects)

### Files, Buffers and Misc

- `;` (n) Enter command mode (no need to press the Shift key!)
- `<D-s>` (n) Save all buffers
- `<C-s>` (n) Save current buffer
- `ss` (n) Horizontal split
- `vv` (n) Vertical split

### Navigation

- `H` (n) Jump to first non-blank character in line
- `0` (n) Jump to first character in line
- `L` (n) Jump to last non-blank character in line
- `J` (n) Jump to bottom of file
- `H` (n) Jump to top of file
- `<D-h>` (n) Scroll left without moving cursor
- `<D-l>` (n) Scroll right without moving cursor
- `<D-k>` (n) Scroll up without moving cursor
- `<D-j>` (n) Scroll down without moving cursor
- `<leader>cc` Jump to the top of the current indent level

### Working with Projects

[ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim)

From the start page, you move to the Projects line and type `<CR>` (or type
`<leader>se` for settings). This will open Telescope with a list of your
previously opened projects. Select a project from the list (`<C-n/p><CR>`) and
then search for a file to open and select it with `<CR>`. Now your current
working directory is the project root.

Projects are added by starting nvim (or calling `:cd path/to/project`) in any
folder with a `.git` folder and then opening a code file. Additional project
folder patterns can be configured in `config/plugins/project.lua`.

> I've had some issues with projects showing up. Sometimes you need to open a
> project folder multiple times before it's detected.

- `<leader>fp` to open the project finder
- [project key maps](https://github.com/ahmedkhalf/project.nvim#telescope-mappings)
  are available inside the project finder window

### Working with the autocomplete

- [Nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
  The generic autocomplete popup that opens as you type. See `h: nvim-cmp` for
  help.
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
  Copilot plugin written in lua for better performance. See GitHub page for
  help.

When in insert mode, you should get an autocomplete menu. Use `<C-space>` in
insert mode to open or close the dialog. When the dialog is open, use `<C-n/p>`
(or `<C-j/k>`) to navigate to the next/previous items. When you have an item
selected, `<CR>` will select it.

Additionally, you may also see Copilot suggestions written as ghost text after
your cursor which you can accept using `<Tab>` (in insert mode). You can scroll
to the next/previous Copilot suggestion using `<C-n/p>`. You can hide the
Copilot suggestions with `<C-space>`. 

If you have both the autocomplete window and copilot visible, the key commands
for the autocomplete take precendence. If you actually want to interact with
Copilot and ignore the autocomplete suggestions, use `<C-space>` once to hide
the autocomplete so you can interact with Copilot. If you want to hide both
the autocomplete and Copilot, type `<C-space>` twice.

If you select an item marked "Snippet" in the autocomplete, it will populate the
snippet code for you and place you in the first edit location for that snippet.
You can now type some text and then type `<Tab>` to move to the next edit
location. Repeat until there are no more edit locations.

> NOTE: I've noticed a couple bugs in our current implementation.
> - If the copilot suggestion is show before the autocomplete, you can't toggle
>   the autocomplete window.
> - If the documentation window is open, you cannot `Tab` complete a copilot
>   suggestion.
> - Copilot suggestions and snippet navigation sometimes conflict. We should
>   disable copilot while we are in a snippet.

#### Cheatsheat

- `<C-space>` toggle the autocomplete menu when in insert mode or hide the
  Copilot suggestions if they are visible.
- `<C-j/k>` cycle through the autocomplete or Copilot suggestions
- `<C-n/p>` cycle through the autocomplete or Copilot suggestions
- `<Tab>` accept the copilot ghost text suggestion

### Working with code

Code errors are displayed in the number gutter and as ghost text. You can jump
between errors using `]d` (next diagnostic) and `[d` (previous diagnostic). This
will show you the error message in a popup. Use `<leader>ca` (code action) to
populate the command line with a list of autofix suggestions. Follow the
instructions to fix the error.

When hovered over any code, you can use `K` to show the type of that code. This
is really useful if you need to debug Typescript errors.

#### Cheatsheat

- `]d` Go to the next error (diagnostic)
- `[d` Go to the previous error (diabnostic)
- `<leader>ca` Autofix an error (code action)
- `K` to show code type info
- `/` search file forwards (`n` and `p` to jump next/previous)
- `?` search file backwards (`n` and `p` to jump next/previous in reverse)
- `<leader>cc` to jump up one scope block level
- `%` to jump to the matching surrounding character (ie. quote, paren, curly, etc.)
- `zz` to center the code under your cursor
- `}` go to the next empty line
- `{` go to the previous empty line

### Working with Git

- [GitSigns](https://github.com/lewis6991/gitsigns.nvim)
  Shows you the removed/added/staged hunks within your open buffers, nvim tree and the status line.
  Try `:Gitsigns <TAB>` to view the available commands or `h: Gitsigns` for
  help.
- [GitDiff](https://github.com/sindrets/diffview.nvim)
  A diff viewer for Git staging and navigationg the Git history.
  Try `:Diffview<TAB>` to view available commands or `h: Diffivew` for help.
- [NeoGit](https://github.com/TimUntersberger/neogit)
  An easy UI for performing Git commands. Visit GitHub for help.

To quickly switch between your branches, use `<leader>gr` (Git bRanch) to show a
list of available branches. Use `Tab` or `<C-n/p>` to select a branch and `<CR>`
to switch to that branch. For more options, type `<Esc>` to enter normal mode
and `g?` to show available commands at the bottom of the screen.

When working in a file, the number column will show you unstaged file changes
with a colored bar. Type `]c` and `[c` to navigate between changes in the file. You
can stage/unstage changes with `<leader>cs` (Commits Stage) and the left column color
will be removed. You can also quickly show a diff of the unstaged lines with
`<leader>cd` (Commits Diff). Or you can toggle an inline view of all unstaged
changes with `<leader>ch` (Commits Highlight).

You can quickly review your current Git changes in a floating window by pressing
`<leader>gt` (Git Telescope). Use `<C-n/p>` to show the diff of the next/previous file. Use
`<C-d/u>` to scroll the preview window up/down. Use `?` to show Telescope key
commands at the bottom of the screen.

For a more complete staging experience, you can use `<leader>gs` (Git Stage) to
open a new tab with a diff view of the current Git state. Use `j/k` to
navigate between files and `<CR>` to show the diff for the selected file. The
Gitsigns commands work in the diff buffers as well so you can jump between
hunks, stage them, etc.

#### Cheatsheat

- `<leader>gt` Git status in Telescope
- `]c` Go to next Git hunk
- `[c` Go to previous Git hunk
- `<leader>cs` Stage hunk under cursor
- `<leader>ch` Show inline git changes
- `<leader>td` Show file diff
- `<leader>gs` Show the project wide git changes
- `<leader>gg` Git GUI
- `<leader>cm` Browse Git commits in Telescope 
- `<leader>gh` View detailed Git history in a tab

### Github Copilot
https://github.com/github/copilot.vim - This works after adding `vim.g.copilot_assume_mapped = true` to `config/init.lua`
https://github.com/zbirenbaum/copilot.lua - Havent tried this but it exists.

### Snippets

Snippet functionality is provided by [luasnip](https://github.com/L3MON4D3/LuaSnip)
with [friendly snippets](https://github.com/rafamadriz/friendly-snippets)
installed as well. Additionally, you can add your own snippets by adding snippet
JSON files in the `snippets` folder. Snippets must be VSCode snippet format and
the files must be named `{filetype}.json` and be valid JSON. If your snippets
aren't loading, it's because there are JSON format issues or your snippet
definitions don't match the VSCode snippet format. To easily create new
snippets, you can use [this online snippet generator](https://snippet-generator.app/)

To use snippets, try typing "aptreactfunc" in a typescript file, select the
snippet in the autocomplete, type a name for your component, type `<TAB>` to
move to the next edit location, repeat...

## Configure

- A good overview of [lua config with Neovim](https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/)
- The official [Neovim configuration with lua guide](https://neovim.io/doc/user/lua-guide.html#lua-guide)


### Neovide

- insert emoji on osx
- cursor jumps when autocomplete dialog is open while typing

### Questions

- Would Neovide be faster with a non-ligagure font?
- Would Neovide be faster with a slower refresh rate?
- Would Neovide be faster without animations?
- Would Neovide be faster without multigrid?
- Would Neovide be faster if autocomplete menues had to be opened manually?
- Would Neovide be faster with Jest plugin (rather than a terminal)?
- Would Neovide be faster without runing tests at all?
- what does the = character in normal mode do?

## Learning NvChad

- Read about the [plugins that come with NvChad](https://github.com/NvChad/NvChad)
- Read the default key mappings provided in `NvChad/lua/core/mappings.lua`
- [Getting started with NeoVim](https://bryankegley.me/posts/nvim-getting-started/)
- Learn how to [customize NvChad](https://nvchad.com/config/Walkthrough)
- Learn how to customize [NeoVim options with lua](https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/)

## Project wide Search and Replace

To perform a project wide search and replace...

- `<leader>fw` to search the project for the text you want to replace
- `<Ctrl-q>` to move the search results to the quickfix window
- type `cdo s/{SEARCH_TEXT}/{REPLACEMENT_TEXT}/g` or (use `/gc` to manually
  approve each change)

See https://github.com/nvim-lua/wishlist/issues/18#issuecomment-812092951

## Useful Key Bindings

### (N)Vim

Some notes to self that helped me a lot

- `zz` vertically center buffer on cursor location

### TODO key mappings for these:
- `:cd {path}` Change the current working directory. Useful for changing the `vim-tree`
root folder. Path is relative to the current working directory or your home directory if not set. See `:h cd`
- `:td {path}` Same as `:cd` but just for the current tab.
