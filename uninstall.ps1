# SoulChad Windows uninstaller.
# Reverses everything install.ps1 set up:
#   - scoop packages from Scoopfile
#   - scoop buckets added by the installer (extras, nerd-fonts)
#   - nvim config junction (restores .backup if present)
#   - nvim data/state caches
#   - neovide, Claude, Codex config files copied in
#   - mise activation line from $PROFILE
#   - rustup/cargo/mise user-state directories
#
# Assumes anything matching the above came from SoulChad. Does not try to
# detect pre-existing installs.

$ErrorActionPreference = 'Stop'

$DOTFILES  = $PSScriptRoot
$NVIM_HOME = Join-Path $env:LOCALAPPDATA 'nvim'
$NVIM_DATA = Join-Path $env:LOCALAPPDATA 'nvim-data'

Write-Host "SoulChad uninstaller"
Write-Host ""
Write-Host "This will remove:"
Write-Host "  - all scoop packages listed in Scoopfile (llvm, cmake, ninja, rustup, mise, nodejs-lts, ...)"
Write-Host "  - scoop buckets: extras, nerd-fonts"
Write-Host "  - $NVIM_HOME (junction) and $NVIM_DATA"
Write-Host "  - Neovide config at %APPDATA%\neovide\config.toml"
Write-Host "  - Claude settings at %USERPROFILE%\.claude\settings.json"
Write-Host "  - Codex config at %USERPROFILE%\.codex\config.toml"
Write-Host "  - mise activation line from $PROFILE"
Write-Host "  - %USERPROFILE%\.rustup, %USERPROFILE%\.cargo, %LOCALAPPDATA%\mise"
Write-Host ""

$response = Read-Host "Proceed? [y/N]"
if (-not ($response -match '^[Yy]')) {
    Write-Host "Aborted."
    exit 0
}

$script:hadError = $false

function Write-Warn([string]$msg) {
    Write-Host $msg -ForegroundColor Red
    $script:hadError = $true
}

function Remove-IfPresent([string]$path, [string]$label) {
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force
        Write-Host "Removed $label ($path)"
    }
}

# ---------------------------------------------------------------------------
# Scoop packages + buckets
# ---------------------------------------------------------------------------

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    $scoopfile = Join-Path $DOTFILES 'Scoopfile'
    if (Test-Path $scoopfile) {
        $packages = @()
        foreach ($raw in Get-Content $scoopfile) {
            $line = $raw.Trim()
            if ($line -eq '' -or $line.StartsWith('#')) { continue }
            # `scoop uninstall` doesn't accept a bucket prefix.
            if ($line.Contains('/')) { $line = $line.Split('/')[-1] }
            $packages += $line
        }
        # Uninstall in reverse order so anything that depends on core tools
        # (rustup toolchains etc.) gets cleaned up first.
        [array]::Reverse($packages)

        Write-Host ""
        Write-Host "Uninstalling scoop packages"
        foreach ($pkg in $packages) {
            Write-Host "  scoop uninstall $pkg"
            scoop uninstall $pkg
            # Ignore non-zero exit codes — the package may already be absent
            # or held by something else; keep going.
        }
    } else {
        Write-Warn "Scoopfile not found at $scoopfile; skipping package uninstall"
    }

    Write-Host ""
    Write-Host "Removing scoop buckets added by SoulChad"
    # `main` is the default bucket — leave it. Fine if these fail (bucket may
    # be in use by other apps outside SoulChad, or already removed).
    scoop bucket rm extras
    scoop bucket rm nerd-fonts
} else {
    Write-Warn "scoop not on PATH; skipping package and bucket removal"
}

# ---------------------------------------------------------------------------
# nvim config junction + data
# ---------------------------------------------------------------------------

if (Test-Path $NVIM_HOME) {
    $item = Get-Item $NVIM_HOME -Force
    if ($item.LinkType -eq 'Junction' -or $item.LinkType -eq 'SymbolicLink') {
        [System.IO.Directory]::Delete($NVIM_HOME, $false)
        Write-Host "Removed junction $NVIM_HOME"
    } else {
        Write-Warn "$NVIM_HOME exists but is not a junction; leaving untouched. Remove manually if needed."
    }
}

$backup = "$NVIM_HOME.backup"
if (Test-Path $backup) {
    Move-Item $backup $NVIM_HOME
    Write-Host "Restored previous nvim config from $backup"
}

Remove-IfPresent $NVIM_DATA 'nvim data cache'

# ---------------------------------------------------------------------------
# Neovide, Claude, Codex configs
# ---------------------------------------------------------------------------

$neovideConfig = Join-Path $env:APPDATA 'neovide\config.toml'
Remove-IfPresent $neovideConfig 'Neovide config'

$neovideDir = Join-Path $env:APPDATA 'neovide'
if ((Test-Path $neovideDir) -and (-not (Get-ChildItem $neovideDir -Force))) {
    Remove-Item $neovideDir -Force
    Write-Host "Removed empty $neovideDir"
}

# Leave the .claude and .codex folders themselves alone — they may contain
# session/history state unrelated to SoulChad. Only drop the files we wrote.
Remove-IfPresent (Join-Path $env:USERPROFILE '.claude\settings.json')  'Claude settings'
Remove-IfPresent (Join-Path $env:USERPROFILE '.codex\config.toml')     'Codex config'

# ---------------------------------------------------------------------------
# PowerShell profile: remove mise activation block
# ---------------------------------------------------------------------------

if (Test-Path $PROFILE) {
    $miseLine = 'mise activate pwsh | Out-String | Invoke-Expression'
    $content  = Get-Content $PROFILE -Raw
    if ($content) {
        $pattern = '(\r?\n)?# Added by SoulChad install\.ps1\r?\n' + [regex]::Escape($miseLine) + '\r?\n?'
        $newContent = [regex]::Replace($content, $pattern, '')
        if ($newContent -ne $content) {
            if ($newContent.Trim() -eq '') {
                Remove-Item $PROFILE -Force
                Write-Host "Removed now-empty $PROFILE"
            } else {
                Set-Content -Path $PROFILE -Value $newContent -NoNewline
                Write-Host "Removed mise activation from $PROFILE"
            }
        }
    }
}

# ---------------------------------------------------------------------------
# rustup / cargo / mise state
# ---------------------------------------------------------------------------

Remove-IfPresent (Join-Path $env:USERPROFILE '.rustup')       'rustup toolchains'
Remove-IfPresent (Join-Path $env:USERPROFILE '.cargo')        'cargo home'
Remove-IfPresent (Join-Path $env:LOCALAPPDATA 'mise')         'mise data'
Remove-IfPresent (Join-Path $env:USERPROFILE '.config\mise')  'mise config'

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

Write-Host ""
if ($script:hadError) {
    Write-Host "Uninstall finished with warnings. Review the log above." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Uninstall complete." -ForegroundColor Green
    Write-Host "Restart PowerShell to drop any lingering env/PATH entries."
}
