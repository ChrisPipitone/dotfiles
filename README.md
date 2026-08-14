# dotfiles

Personal dotfiles for macOS, Arch Linux (via [omarchy](https://github.com/basecamp/omarchy)) and WSL2/Ubuntu. Uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks.

Toolchains are managed by [mise](https://mise.jdx.dev) (node, and anything else version-pinned per project) and [uv](https://docs.astral.sh/uv/) (Python).

## Structure

```
dotfiles/
├── common/                    # Mac + Linux
│   ├── .config/nvim/          # Neovim config (lazy.nvim)
│   ├── .config/tmux/          # tmux config + theme script
│   ├── .config/themes/        # Bundled theme color palettes (used on Mac)
│   └── .zshrc                 # Zsh (Powerlevel10k + zinit)
├── mac/                       # macOS-only overrides
├── linux/                     # Arch/omarchy-only configs
│   └── .config/hypr/          # Hyprland keybindings + monitor layout
├── install.sh
└── README.md
```

Stow mirrors `$HOME` layout — `common/.config/nvim/` symlinks to `~/.config/nvim/`.

## Requirements

| Tool | Mac | Arch |
|------|-----|------|
| GNU Stow | `brew install stow` | `sudo pacman -S stow` |
| Neovim 0.11+ | `brew install neovim` | `sudo pacman -S neovim` |
| tmux 3.1+ | `brew install tmux` | `sudo pacman -S tmux` |
| A [Nerd Font](https://www.nerdfonts.com/) | required for tmux powerline glyphs and nvim icons |

## Installation

```bash
git clone <your-repo-url> ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

`install.sh` will:
1. Stow `common/` to `$HOME`
2. Stow `mac/` (macOS) or `linux/` (Arch) if the directory exists
3. Clone [TPM](https://github.com/tmux-plugins/tpm) if not already installed
4. Write `~/.config/theme.name` with `matte-black` on Mac (first install only)

If Stow errors on existing paths, back them up first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/tmux ~/.config/tmux.bak
```

## First-time setup

**Neovim:**
1. Open `nvim` — Lazy.nvim installs itself and all plugins automatically
2. Run `:Lazy sync` to confirm everything is up to date
3. LSP servers install via Mason automatically on first file open

**tmux:**
1. Open `tmux`
2. Press `prefix + I` (capital I) to install TPM plugins
3. Press `prefix + T` to generate and apply the theme

## Theme system

Both nvim and tmux read the same theme source and apply matching colors automatically.

### Linux (omarchy)

Omarchy manages the active theme. Change it with:

```bash
omarchy-theme-set kanagawa   # or nord, matte-black, gruvbox, etc.
```

This updates `~/.config/omarchy/current/theme.name`. Nvim picks it up on next open. To sync tmux without restarting:

```
prefix + T
```

### Mac

The active theme is stored in `~/.config/theme.name`. Change it with:

```bash
echo "matte-black" > ~/.config/theme.name
```

Then restart nvim and press `prefix + T` in tmux. Supported values are any theme name in `~/.config/themes/` (bundled) or the full omarchy theme list if omarchy is installed.

**Bundled themes** (work without omarchy):

| Name | Style |
|------|-------|
| `matte-black` | Near-black, amber accent — default on Mac |
| `kanagawa` | Dark ink, wave blue accent |

### How it works

`common/.config/tmux/apply-theme.sh` reads the active theme's `colors.toml` (from omarchy or `~/.config/themes/`) and generates `~/.config/tmux/current-theme.conf` with matching tmux color settings. This file is sourced by tmux on every session start.

`common/.config/nvim/lua/chris/plugins/colorscheme.lua` reads the same theme source at nvim startup and loads the corresponding colorscheme plugin.

All 14 omarchy themes are supported in nvim. Tmux works with any theme that has a `colors.toml`.

## Hyprland (Arch/omarchy only)

`linux/.config/hypr/` tracks customizations on top of omarchy's defaults:

- **`bindings.conf`** — vim-style focus/move (hjkl), closes a window with `SUPER+Q`
- **`monitors.conf`** — dual monitor layout (edit to match your setup)

These are sourced automatically by omarchy's `hyprland.conf`.

## Swapping themes mid-session

| Action | Command |
|--------|---------|
| Change omarchy theme (Linux) | `omarchy-theme-set <name>` |
| Change theme (Mac) | `echo "<name>" > ~/.config/theme.name` |
| Reload tmux theme | `prefix + T` |
| Reload tmux config | `prefix + r` |
| Reload nvim theme | restart nvim (or `:source $MYVIMRC` + `:Lazy load <plugin>`) |

## WSL2

`install.sh` handles the packages, but two things are outside its reach.

**1. Keep `$PATH` off the Windows filesystem.** By default WSL appends all of Windows' `PATH`, so every `command -v` and tab-completion stats across 9p, and `npm`/`npx` resolve to the Windows binaries — which then write `node_modules/.bin/` shims containing Windows paths that cannot execute under Linux. Add to `/etc/wsl.conf`:

```ini
[interop]
appendWindowsPath = false
```

Then `wsl --shutdown` from PowerShell. `common/.zsh/envs` re-adds only the two directories actually needed — the VS Code `bin` dir (for `code .`) and `C:\Program Files\Neovim\bin` (for `win32yank.exe`, the nvim clipboard provider). Both are found by glob, so no username is hardcoded.

To revert: delete those two lines and `wsl --shutdown` again.

**2. Always land in a Remote-WSL window.** Remote context is a property of the *window*, fixed at launch — there is no "always use WSL" setting. Three launch paths need covering:

| Path | Fix |
|---|---|
| Taskbar / Start cold start | Retarget the shortcut: `Code.exe --remote wsl+Ubuntu /home/<you>/projects` |
| Window restore | `"window.restoreWindows": "all"` |
| Switching projects | `Ctrl+R` (Open Recent) preserves the remote authority; or use `p` |

`p` is a WSL-only zsh function (`common/.zsh/functions`) — fzf over git repo roots under `~/projects`, then `code .` from inside WSL, which guarantees a remote window. Override the search root with `$PROJECTS_DIR`.

Right-click → "Open with Code" from Windows Explorer always produces a *local* window and no setting overrides it. Use `p` or `Ctrl+R`.

## Neovim inside VSCode

`lua/chris/lazy.lua` branches on `vim.g.vscode`. Terminal nvim loads the full spec; [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) loads `lua/chris/vscode.lua` instead — motions and text objects only, since VSCode owns LSP, completion, diagnostics, formatting and debugging. That file lives outside `lua/chris/plugins/` so the normal directory import can never pick it up.

VSCode-side, `remote.extensionKind` forces the extension to run in WSL (it declares `["ui","workspace"]` and would otherwise resolve to the Windows host, using a Windows nvim and a different config).

## Notes

- **tmux config** lives at `~/.config/tmux/tmux.conf` (XDG). tmux 3.1+ finds it automatically.
- **`~/.config/tmux/current-theme.conf`** is generated at runtime and gitignored — don't edit it manually.
- **Treesitter parsers:** nvim ships bundled parsers to `~/.local/share/nvim/site/parser/`. These take priority over nvim-treesitter-managed ones and can fall out of sync. If you see treesitter query errors on a language, delete the stale parser: `rm ~/.local/share/nvim/site/parser/<lang>.so` and let nvim-treesitter manage it via `:TSUpdate <lang>`.
- **SSH sessions:** clipboard sync (`unnamedplus`) is automatically disabled over SSH.
