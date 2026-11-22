# ⚡ Modern Modular Dotfiles & Developer Environment

[![CI](https://github.com/renartacayle/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/renartacayle/dotfiles/actions/workflows/ci.yml)
![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black)
![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-blue?logo=gnu-bash&logoColor=white)
![Editor: Neovim](https://img.shields.io/badge/Editor-Neovim%200.10+-57A143?logo=neovim&logoColor=white)
![WM: Hyprland](https://img.shields.io/badge/WM-Hyprland-00C7D7?logo=wayland&logoColor=white)
![Theme: Catppuccin Mocha](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

A production-grade, idempotent, and declarative workstation configuration powered by **GNU Stow**, a modern **Neovim IDE suite (Lua + lazy.nvim + Mason LSP + Treesitter)**, **Tmux (TrueColor + Vim navigation)**, **Zsh + Starship**, **Hyprland Wayland Compositor (Waybar + Kitty + Alacritty + Rofi)**, and an **Automated Docker Test Harness & CI**.

---

## 🎯 What is this for? (Why use this dotfiles?)

Setting up a fresh Linux machine, switching distros, or configuring a remote development box usually takes hours of repetitive work: manually installing packages, tweaking shell aliases, configuring LSP servers, hunting down font dependencies, and copying configuration files back and forth. 

This repository solves that once and for all:

1. **🚀 Zero-Friction Bootstrap (One Command Setup)**:
   Takes you from a freshly installed Linux OS to a fully configured, production-ready developer workstation in minutes with `./scripts/install.sh`. Automatically detects your package manager (`pacman`, `apt`, `dnf`, `zypper`), downloads dependencies, installs fonts, and sets up symlinks.
2. **🧠 Neovim Turned into a High-Performance IDE**:
   No bloated distributions. A clean, modular Lua configuration with `lazy.nvim` that starts in milliseconds, featuring full LSP auto-installation via Mason (Python, Go, Rust, TypeScript, C/C++, Lua, Bash), Treesitter AST highlighting, Telescope fuzzy finding, and intelligent auto-completion.
3. **📦 Declarative & Modular (GNU Stow)**:
   Configurations are not dumped into `$HOME`. Every component (`nvim`, `tmux`, `zsh`, `hypr`, etc.) is an isolated package. You can link all packages on a desktop or cherry-pick only `nvim` + `tmux` + `zsh` for a headless server.
4. **🎨 Cohesive Visual Harmony (Catppuccin Mocha)**:
   A single, beautifully tuned color palette shared across every application: Neovim, Tmux, Kitty, Alacritty, Waybar, Rofi, Cava visualizer, and Hyprlock.
5. **🛡️ Zero Data-Loss Guarantee**:
   Before linking any file, `scripts/backup.sh` automatically detects existing system configurations and moves them safely into a timestamped directory (`~/.dotfiles_backup/`). Your existing files will never be destroyed or silently overwritten.
6. **🧪 Battle-Tested with Container CI**:
   Includes a clean Dockerfile test harness and GitHub Actions CI that runs on every commit, verifying syntax with ShellCheck and testing fresh container installations end-to-end.

---

## 📂 Modular Architecture & Directory Tree

```text
dotfiles/
├── .github/workflows/
│   └── ci.yml                 # CI pipeline: ShellCheck linter & Docker clean install verification
├── tests/
│   ├── Dockerfile             # Clean Ubuntu 24.04 test environment
│   ├── run_test.sh            # Containerized test runner (Docker / Podman)
│   └── test_symlinks_dryrun.sh# Zero-dependency XDG symlink & file integrity test
├── scripts/
│   ├── install.sh             # Idempotent cross-distro bootstrap installer
│   ├── install_fonts.sh       # Automated JetBrainsMono Nerd Font & Papirus Icons installer
│   ├── backup.sh              # Safe backup engine (zero overwrite / zero data-loss)
│   └── stow.sh                # Declarative GNU Stow symlink manager
├── git/                       # Git Module
│   └── .gitconfig             # Delta syntax-highlighted pager, safe aliases, auto-rebase
├── bin/                       # Custom CLI Utilities (Automatically mapped to $PATH)
│   └── .local/bin/
│       ├── sysinfo            # Instant CPU/RAM/Disk/IP status dashboard card
│       ├── screenshot         # Wayland screenshot tool (grim + slurp) with auto-clipboard
│       └── git-cleanup        # Local repository dangling & merged branch cleaner
├── nvim/                      # Neovim IDE Suite
│   └── .config/nvim/
│       ├── init.lua           # Core entrypoint & leader key definition
│       └── lua/
│           ├── config/        # Options, keymaps, lazy.nvim bootstrap
│           └── plugins/
│               ├── lsp.lua          # Mason, Mason-LSPConfig, Neovim LSPConfig
│               ├── completion.lua   # nvim-cmp, LuaSnip, friendly-snippets
│               ├── treesitter.lua   # AST syntax highlighting & incremental selection
│               ├── telescope.lua    # Fuzzy finder (files, live grep, buffers, diagnostics)
│               ├── ui.lua           # Lualine, Gitsigns, Oil.nvim, Autopairs
│               └── colorscheme.lua  # Catppuccin Mocha theme & Which-key
├── tmux/                      # Terminal Multiplexer
│   └── .config/tmux/
│       └── tmux.conf          # Prefix C-a, 24-bit TrueColor, vim-keys, & TPM
├── zsh/                       # Shell Environment
│   ├── .zshrc                 # Cross-session history sharing, compinit, & zoxide
│   └── .config/zsh/
│       ├── aliases.zsh        # Modern CLI shortcuts (eza, git, navigation)
│       └── env.zsh            # PATH & Environment variables
├── starship/                  # Cross-Shell Prompt
│   └── .config/starship.toml  # Minimalist & blazingly fast runtime/git status prompt
├── kitty/                     # GPU Terminal Emulator
│   └── .config/kitty/
│       └── kitty.conf         # JetBrainsMono Nerd Font & Catppuccin styling
├── alacritty/                 # Minimalist Terminal Emulator
│   └── .config/alacritty/
│       └── alacritty.toml     # Modern TOML config & Catppuccin Mocha palette
├── hypr/                      # Wayland Compositor (Window Manager)
│   └── .config/hypr/
│       └── hyprland.conf      # Smooth bezier animations, vim navigation & dual gaps
├── waybar/                    # Status Bar
│   └── .config/waybar/
│       ├── config.jsonc       # Modules: workspaces, clock, audio, battery, tray
│       └── style.css          # Catppuccin glassmorphism theme
├── rofi/                      # Application Launcher
│   └── .config/rofi/
│       └── config.rasi        # Modern modal app & window switcher
├── cava/                      # Audio Visualizer
│   └── .config/cava/
│       └── config             # 60 FPS Catppuccin gradient equalizer
├── hyprlock/                  # Wayland Screen Locker
│   └── .config/hypr/
│       └── hyprlock.conf      # Minimalist clock & animated password input
├── desktop/                   # FreeDesktop Application Entries
│   └── .local/share/applications/
│       └── zenfocus.desktop   # Pomodoro & Deep Work application launcher
└── .gitignore                 # Exclusion for secrets, local tokens, & cache files
```

---

## 🚀 Quick Start & Installation

### 1. Clone the Repository
```bash
git clone https://github.com/renartacayle/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Bootstrap Installer
The idempotent `install.sh` script automatically detects your distribution, installs required system packages, fetches the JetBrainsMono Nerd Font, safely backs up existing files, and links configurations via GNU Stow:

```bash
chmod +x scripts/*.sh
./scripts/install.sh
```

> **Unattended / Headless Server Mode:**
> For CI containers, Docker, or server setups without interactive prompts:
> ```bash
> ./scripts/install.sh -y
> ```

---

## 🧰 Package Management via GNU Stow (`stow.sh`)

Manage individual modules or the entire desktop environment using the provided `scripts/stow.sh` wrapper:

| Command | Action |
| :--- | :--- |
| `./scripts/stow.sh all` | Symlinks all core terminal packages (`nvim`, `tmux`, `zsh`, `starship`, `git`, `bin`) |
| `./scripts/stow.sh desktop` | Symlinks all packages including GUI/Desktop (`hypr`, `waybar`, `kitty`, `alacritty`, `rofi`, `cava`, `hyprlock`) |
| `./scripts/stow.sh nvim` | Links only the Neovim package |
| `./scripts/stow.sh tmux` | Links only the Tmux package |
| `./scripts/stow.sh -R all` | **Restows / Re-links** all packages (useful after pulling updates) |
| `./scripts/stow.sh -D nvim` | **Unlinks (deletes symlinks)** for the Neovim package from `$HOME` |

---

## ⌨️ Core Keybindings Cheat Sheet

### Neovim IDE
* `<Space>` — **Leader Key**
* `<leader>ff` — Fuzzy find files (*Telescope*)
* `<leader>fg` — Search text in project (*Live Grep*)
* `<leader>e` / `-` — Open buffer-based file manager (*Oil.nvim*)
* `gd` / `gr` — Jump to definition / list references (LSP)
* `K` — Show hover type documentation (LSP)
* `<leader>ca` — Code Action (LSP)
* `<leader>cf` — Format buffer asynchronously (LSP)
* `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` — Navigate between split windows
* `J` / `K` (Visual mode) — Shift selected lines up or down

### Tmux Multiplexer
* `Ctrl-a` — **Prefix Key** (ergonomic replacement for `Ctrl-b`)
* `Prefix + |` — Split window horizontally (in current directory)
* `Prefix + -` — Split window vertically (in current directory)
* `Prefix + h / j / k / l` — Navigate active panes (Vim keys)
* `Prefix + r` — Reload Tmux configuration instantly
* `Prefix + I` — Fetch and install plugins via TPM

### Hyprland Wayland WM
* `SUPER + Return` — Launch Kitty terminal
* `SUPER + Space` — Open application launcher (Rofi)
* `SUPER + Q` — Close active window
* `SUPER + F` — Toggle fullscreen
* `SUPER + V` — Toggle floating window
* `SUPER + H / J / K / L` — Move window focus (Vim keys)
* `SUPER + SHIFT + L` — Lock screen (*Hyprlock*)
* `SUPER + 1..6` — Switch to workspace 1–6

---

## 🧪 Testing & Verification

Run the zero-dependency dry-run symlink test locally:
```bash
./tests/test_symlinks_dryrun.sh
```

Or test a completely clean install inside an isolated container:
```bash
./tests/run_test.sh
```

---

## 📄 License
This repository is open-sourced under the [MIT License](LICENSE).
