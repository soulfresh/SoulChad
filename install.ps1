# SoulChad Windows installer.
# Counterpart to install.zsh. Assumes PowerShell (Windows PowerShell 5.1 or
# PowerShell 7+) and an already-installed scoop. Run from the repo root:
#   .\install.ps1

$ErrorActionPreference = 'Stop'

$DOTFILES  = $PSScriptRoot
$CONFIG    = Join-Path $DOTFILES 'nvim'
$NVIM_HOME = Join-Path $env:LOCALAPPDATA 'nvim'
# NvChad's data/state live under %LOCALAPPDATA%\nvim-data on Windows.
$NVIM_DATA = Join-Path $env:LOCALAPPDATA 'nvim-data'

Write-Host "Using the following paths:"
Write-Host "  NVIM_HOME: $NVIM_HOME"
Write-Host "  DOTFILES:  $DOTFILES"
Write-Host "  CONFIG:    $CONFIG"
Write-Host ""

$script:hadError = $false

function Write-Warn([string]$msg) {
    Write-Host $msg -ForegroundColor Red
    $script:hadError = $true
}

function Write-Info([string]$msg) {
    Write-Host $msg -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "scoop is required but not on PATH." -ForegroundColor Red
    Write-Host "Install it first with:"
    Write-Host "  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    Write-Host "  Invoke-RestMethod get.scoop.sh | Invoke-Expression"
    exit 1
}

$fullInstall = $false
$response = Read-Host "Install/Upgrade required commandline dependencies? [y/N]"
if ($response -match '^[Yy]') { $fullInstall = $true }

# ---------------------------------------------------------------------------
# Scoop packages
# ---------------------------------------------------------------------------

if ($fullInstall) {
    Write-Host ""
    Write-Host "Adding scoop buckets (harmless if already added)"
    # `scoop bucket add` prints to stderr and exits non-zero when the bucket
    # already exists. We don't want that to halt the installer, so we let
    # `$LASTEXITCODE` stay non-zero and carry on.
    scoop bucket add main
    scoop bucket add extras
    scoop bucket add nerd-fonts

    $scoopfile = Join-Path $DOTFILES 'Scoopfile'
    if (Test-Path $scoopfile) {
        Write-Host ""
        Write-Host "Installing packages from Scoopfile"
        foreach ($raw in Get-Content $scoopfile) {
            $line = $raw.Trim()
            if ($line -eq '') { continue }
            if ($line.StartsWith('#')) { continue }
            Write-Host "  scoop install $line"
            scoop install $line
            if ($LASTEXITCODE -ne 0) {
                Write-Warn "  failed: scoop install $line (exit $LASTEXITCODE)"
            }
        }
    } else {
        Write-Warn "Scoopfile not found at $scoopfile"
    }

    # Prompt rustup to install the stable toolchain. Skip if rustup isn't on
    # PATH yet (scoop shims land in ~\scoop\shims which should already be in
    # PATH; if not, the user needs to restart their shell).
    if (Get-Command rustup -ErrorAction SilentlyContinue) {
        Write-Host ""
        Write-Host "Setting Rust stable toolchain as default"
        rustup default stable
        if ($LASTEXITCODE -ne 0) {
            Write-Warn "rustup default stable failed"
        }
    } else {
        Write-Warn "rustup not on PATH after scoop install; restart your shell and re-run"
    }
}

# ---------------------------------------------------------------------------
# Link nvim config
# ---------------------------------------------------------------------------

function Link-Directory {
    param(
        [Parameter(Mandatory = $true)] [string] $Source,
        [Parameter(Mandatory = $true)] [string] $Target
    )

    if (-not (Test-Path $Source)) {
        Write-Warn "Source directory does not exist: $Source"
        return
    }

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'Junction' -or $item.LinkType -eq 'SymbolicLink') {
            Write-Host "  removing existing link at $Target"
            # Delete the reparse point without following it.
            [System.IO.Directory]::Delete($Target, $false)
        } else {
            $backup = "$Target.backup"
            Write-Host "  backing up $Target -> $backup"
            if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
            Move-Item -Path $Target -Destination $backup -Force
        }
    } else {
        $parent = Split-Path $Target -Parent
        if (-not (Test-Path $parent)) {
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
        }
    }

    Write-Info "Linking $Source -> $Target"
    New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
}

# Clear nvim data cache on full installs only — otherwise Lazy has to re-clone
# every plugin on the next headless run (several minutes on a cold cache).
if ($fullInstall -and (Test-Path $NVIM_DATA)) {
    $item = Get-Item $NVIM_DATA -Force
    if ($item.LinkType -eq 'Junction' -or $item.LinkType -eq 'SymbolicLink') {
        Write-Host "skipping removal of link $NVIM_DATA"
    } else {
        Write-Host "removing $NVIM_DATA"
        Remove-Item $NVIM_DATA -Recurse -Force
    }
}

Write-Host ""
Write-Host "Linking nvim config"
Link-Directory -Source $CONFIG -Target $NVIM_HOME

# ---------------------------------------------------------------------------
# Copy auxiliary configs
# ---------------------------------------------------------------------------

# Neovide on Windows reads %APPDATA%\neovide\config.toml.
$neovideDir = Join-Path $env:APPDATA 'neovide'
New-Item -ItemType Directory -Force -Path $neovideDir | Out-Null
Copy-Item `
    -Path (Join-Path $DOTFILES 'config\neovide\config.toml') `
    -Destination (Join-Path $neovideDir 'config.toml') `
    -Force
Write-Host "Copied Neovide config to $neovideDir"

# Claude Code settings.
$claudeDir = Join-Path $env:USERPROFILE '.claude'
New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
Copy-Item `
    -Path (Join-Path $DOTFILES 'config\claude\settings.json') `
    -Destination (Join-Path $claudeDir 'settings.json') `
    -Force
Write-Host "Copied Claude settings to $claudeDir"

# AutoHotkey startup shortcuts. Point at the .ahk files in the repo so edits
# take effect on next login without re-running the installer.
$ahkExe = $null
$scoopAhk = Join-Path $env:USERPROFILE 'scoop\apps\autohotkey\current\v2\AutoHotkey64.exe'
if (Test-Path $scoopAhk) {
    $ahkExe = $scoopAhk
} else {
    $cmd = Get-Command AutoHotkey64.exe -ErrorAction SilentlyContinue
    if ($cmd) { $ahkExe = $cmd.Source }
}

if (-not $ahkExe) {
    Write-Warn "AutoHotkey v2 executable not found; skipping startup shortcuts (install extras/autohotkey via scoop first)"
} else {
    $startup = [Environment]::GetFolderPath('Startup')
    $wsh = New-Object -ComObject WScript.Shell

    $ahkScripts = @(
        @{ Script = 'win\autohotkey\CapsLock.ahk';         Link = 'SoulChad-CapsLock.lnk';         Desc = 'SoulChad CapsLock toggle (Ctrl+LShift+RShift)' }
        @{ Script = 'win\autohotkey\CapsLockToEscape.ahk'; Link = 'SoulChad-CapsLockToEscape.lnk'; Desc = 'SoulChad CapsLock -> Escape remap' }
    )

    foreach ($entry in $ahkScripts) {
        $ahkScript = Join-Path $DOTFILES $entry.Script
        if (-not (Test-Path $ahkScript)) {
            Write-Warn "AutoHotkey script not found at $ahkScript; skipping"
            continue
        }
        $shortcut = Join-Path $startup $entry.Link
        $lnk = $wsh.CreateShortcut($shortcut)
        $lnk.TargetPath = $ahkExe
        $lnk.Arguments = "`"$ahkScript`""
        $lnk.WorkingDirectory = Split-Path $ahkScript -Parent
        $lnk.Description = $entry.Desc
        $lnk.Save()
        Write-Host "Created AutoHotkey startup shortcut at $shortcut"
    }
}

# Git configs. Try a symlink first (so edits in the repo take effect
# immediately); fall back to a copy if the OS refuses — on Windows, creating
# file symlinks requires Developer Mode or running elevated.
$gitSources = @('.gitconfig', '.gitignore')
foreach ($name in $gitSources) {
    $src = Join-Path $DOTFILES "git\$name"
    $dst = Join-Path $env:USERPROFILE $name
    if (-not (Test-Path $src)) {
        Write-Warn "Git config not found at $src; skipping"
        continue
    }
    if (Test-Path $dst) {
        $item = Get-Item $dst -Force
        if ($item.LinkType -eq 'SymbolicLink' -or $item.LinkType -eq 'HardLink') {
            Remove-Item $dst -Force
        } else {
            $backup = "$dst.backup"
            if (Test-Path $backup) { Remove-Item $backup -Force }
            Move-Item -Path $dst -Destination $backup -Force
            Write-Host "  backed up existing $dst -> $backup"
        }
    }
    try {
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -ErrorAction Stop | Out-Null
        Write-Host "Linked $src -> $dst"
    } catch {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "Copied $src -> $dst (symlink failed: enable Developer Mode to link instead)"
    }
}

# Codex CLI config. Don't clobber an existing file — the TOML-merge helper
# from install.zsh isn't ported.
$codexDir = Join-Path $env:USERPROFILE '.codex'
New-Item -ItemType Directory -Force -Path $codexDir | Out-Null
$codexTarget = Join-Path $codexDir 'config.toml'
if (Test-Path $codexTarget) {
    Write-Host "Codex config already exists at $codexTarget; leaving in place."
    Write-Host "  Merge $DOTFILES\config\codex\config.toml into it manually if needed."
} else {
    Copy-Item -Path (Join-Path $DOTFILES 'config\codex\config.toml') -Destination $codexTarget
    Write-Host "Copied Codex config to $codexTarget"
}

Write-Host ""
Write-Host "NOTE: config/claude/notify.sh and config/codex/notify.sh are bash scripts"
Write-Host "      tied to macOS (terminal-notifier/osascript). They are NOT installed"
Write-Host "      on Windows; Claude/Codex notifications will not fire until you port"
Write-Host "      them to PowerShell/BurntToast or similar."
Write-Host ""

# ---------------------------------------------------------------------------
# PowerShell profile: activate mise on every session
# ---------------------------------------------------------------------------

$miseLine = 'mise activate pwsh | Out-String | Invoke-Expression'
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
    Write-Host "Created PowerShell profile at $PROFILE"
}
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if (-not $profileContent) { $profileContent = '' }
if ($profileContent -notmatch [regex]::Escape($miseLine)) {
    Add-Content -Path $PROFILE -Value "`n# Added by SoulChad install.ps1`n$miseLine"
    Write-Host "Added mise activation to $PROFILE"
} else {
    Write-Host "mise activation already present in $PROFILE"
}

# ---------------------------------------------------------------------------
# Install nvim plugins + Mason tooling (full install only — these each take
# minutes on a cold cache and aren't needed when just re-linking configs)
# ---------------------------------------------------------------------------

if ($fullInstall) {
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
        Write-Warn "nvim not on PATH; skipping plugin + Mason install"
    } else {
        Write-Host ""
        Write-Host "Installing/restoring nvim plugins to lock file versions"
        nvim --headless "+Lazy! restore" +qa
        if ($LASTEXITCODE -ne 0) { Write-Warn "nvim Lazy restore failed" }

        Write-Host ""
        Write-Host "Installing Mason tools (clangd, rust-analyzer, etc.)"
        nvim --headless "+MasonInstallAll" +qa
        if ($LASTEXITCODE -ne 0) { Write-Warn "MasonInstallAll reported errors (non-fatal if only JS-based tools failed)" }

        Write-Host ""
        Write-Host "Running nvim health check"
        $healthFile = Join-Path $env:TEMP 'nvim-healthcheck.txt'
        nvim --headless "+checkhealth" "+w! $healthFile" +qa
        if (Test-Path $healthFile) {
            Get-Content $healthFile
            Remove-Item $healthFile -Force
        }
    }
}

# ---------------------------------------------------------------------------
# Keyboard repeat speed (counterpart to macOS `defaults write NSGlobalDomain
# KeyRepeat`). KeyboardDelay: 0-3 (0 = ~250ms, fastest). KeyboardSpeed: 0-31
# (31 = ~30 chars/sec, fastest). Bump speed toward 31 if 28 feels sluggish.
# ---------------------------------------------------------------------------

Write-Host ""
$kbPath = 'HKCU:\Control Panel\Keyboard'
Set-ItemProperty -Path $kbPath -Name 'KeyboardDelay' -Value '0'
Set-ItemProperty -Path $kbPath -Name 'KeyboardSpeed' -Value '28'

# Broadcast to the running session so the change takes effect immediately.
# SPI_SETKEYBOARDDELAY = 0x0017, SPI_SETKEYBOARDSPEED = 0x000B.
$sig = @'
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
'@
$spi = Add-Type -MemberDefinition $sig -Name 'KbSpi' -Namespace 'SoulChad' -PassThru
[void]$spi::SystemParametersInfo(0x0017, 0,  0, 0)
[void]$spi::SystemParametersInfo(0x000B, 28, 0, 0)
Write-Host "Set keyboard repeat: delay=0 (fastest), speed=28 (bump to 31 if slow)"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

Write-Host ""
if ($script:hadError) {
    Write-Host "Install finished with warnings. Review the log above." -ForegroundColor Red
    exit 1
} else {
    Write-Info "Install successful!"
    Write-Host "Restart PowerShell (or run '. `$PROFILE') to pick up mise activation."
}
