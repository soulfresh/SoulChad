# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SoulChad is a comprehensive dotfiles repository that customizes NeoVim using NvChad framework, along with ZSH shell configurations and development tools. This is a personal development environment setup focused on web development, particularly JavaScript/TypeScript/React workflows.

## Architecture

### Core Components

1. **NeoVim Configuration (`./nvim/`)**
   - Built on top of NvChad 2.5+ framework
   - Main config entry point: `nvim/init.lua`
   - User customizations in `nvim/lua/chadrc.lua`
   - Plugin configurations in `nvim/lua/plugins/`
   - Custom snippets in `nvim/lua/snippets/`
   - Key mappings in `nvim/lua/mappings.lua`

2. **ZSH Configuration (`./zsh/`)**
   - Uses Prezto framework for ZSH enhancements
   - Custom aliases in `zsh/aliases.zsh` and `zsh/zsh-aliases.zsh`
   - Custom prompt configurations

3. **Development Tools Setup**
   - Homebrew package definitions in `Brewfile`
   - Git configurations in `git/.gitconfig`
   - Neovide settings in `config/neovide/config.toml`

### NvChad Integration

This repository works as a configuration overlay for NvChad:
- NvChad itself is installed as a separate plugin/dependency
- This repo provides user customizations that extend NvChad's base functionality
- Plugin management handled through Lazy.nvim (lockfile: `nvim/lazy-lock.json`)

## Common Development Commands

### Installation and Setup
```bash
./install.zsh          # Full installation of dotfiles, NvChad, Prezto, and tools
./uninstall.zsh        # Remove symlinks and restore previous configs
```

### NeoVim/NvChad Management
```bash
nvim                   # Start NeoVim with NvChad
:Lazy                  # Plugin manager interface
:Lazy restore          # Restore plugins to lockfile versions
:MasonInstallAll       # Install all LSP servers/tools
```

### Code Formatting
```bash
stylua --config-path ./nvim/.stylua.toml ./nvim/lua/  # Format Lua code
```

### Dependencies
- Requires NerdFonts (installable via `getnf` command)
- Homebrew for package management
- Git for version control
- Node.js/npm/yarn for web development tools

## File Structure

```
├── nvim/                    # NeoVim configuration
│   ├── init.lua            # Entry point
│   ├── lua/
│   │   ├── chadrc.lua      # Main NvChad user config
│   │   ├── mappings.lua    # Custom keybindings
│   │   ├── options.lua     # Vim options
│   │   ├── plugins/        # Plugin configurations
│   │   └── snippets/       # VSCode-format snippets
│   └── .stylua.toml        # Lua formatting config
├── zsh/                    # ZSH shell configurations
├── git/                    # Git global configurations
├── config/                 # Application configs (Neovide, etc.)
├── Brewfile               # Homebrew dependencies
└── install.zsh           # Installation script
```

## Development Workflow

1. **Editing Configs**: Modify files in the respective directories (nvim/, zsh/, etc.)
2. **Plugin Management**: Use `:Lazy` in NeoVim to manage plugins
3. **Testing Changes**: Restart NeoVim or source configs as needed
4. **Syncing Plugins**: Use `:Lazy restore` to sync to lockfile versions

## Key Features

- **Language Support**: Optimized for JavaScript, TypeScript, React, Rust, Swift, C/C++
- **Git Integration**: GitSigns, Diffview, NeoGit for comprehensive Git workflow
- **Project Management**: Project.nvim for switching between development projects
- **Autocomplete**: nvim-cmp with GitHub Copilot integration
- **File Navigation**: Telescope for fuzzy finding, NvTree for file explorer
- **Code Intelligence**: LSP configurations for multiple languages via Mason

## Important Notes

- This setup assumes macOS environment (Darwin)
- Leader key is configured as comma (`,`)
- Custom snippets follow VSCode snippet format
- Plugin versions are locked via `lazy-lock.json` - use `:Lazy restore` after plugin updates
- The setup includes both terminal (nvim) and GUI (Neovide) support

## Troubleshooting

- If NvChad base46 theme issues occur, manually clone the custom fork as described in README.md
- Lock file conflicts: Use `:Lazy restore` to sync plugin versions
- Missing icons: Install NerdFonts via `getnf`
- ZSH issues: Verify Prezto installation and configuration