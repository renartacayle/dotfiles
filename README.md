# ⚙️ Dotfiles & Modern Developer Environment

Repository konfigurasi lingkungan pengembangan modular, idempoten, dan modern berbasis **GNU Stow**, **Neovim (Lua + lazy.nvim + Mason LSP + Treesitter)**, **Tmux (TPM + TrueColor)**, **Zsh + Starship**, **Hyprland Wayland Compositor (Waybar + Kitty + Rofi)**, serta **Automated Docker Test Harness & CI**.

---

## 📂 Struktur Direktori Lengkap

Repository ini dirancang secara modular menggunakan paradigma *package-based* GNU Stow. Setiap modul terisolasi penuh:

```text
dotfiles/
├── .github/workflows/
│   └── ci.yml                 # CI: ShellCheck linter & Docker clean install verification
├── tests/
│   ├── Dockerfile             # Clean Ubuntu 24.04 test environment
│   └── run_test.sh            # Local test runner (Docker / Podman)
├── scripts/
│   ├── install.sh             # Idempotent cross-distro bootstrap installer
│   ├── backup.sh              # Safe backup (zero overwrite/data-loss)
│   └── stow.sh                # Wrapper symlink GNU Stow
├── nvim/                      # Modul Neovim IDE
│   └── .config/nvim/
│       ├── init.lua           # Entrypoint utama
│       └── lua/
│           ├── config/        # Options, keymaps, lazy.nvim bootstrap
│           └── plugins/
│               ├── lsp.lua          # Mason, Mason-LSPConfig, Neovim LSPConfig
│               ├── completion.lua   # nvim-cmp, LuaSnip, friendly-snippets
│               ├── treesitter.lua   # AST syntax highlighting & incremental selection
│               ├── telescope.lua    # Fuzzy finder (files, grep, buffers, diagnostics)
│               ├── ui.lua           # Lualine, Gitsigns, Oil.nvim, Autopairs
│               └── colorscheme.lua  # Catppuccin Mocha theme & Which-key
├── tmux/                      # Modul Multiplexer Terminal
│   └── .config/tmux/
│       └── tmux.conf          # Prefix C-a, 24-bit TrueColor, vim-keys, & TPM
├── zsh/                       # Modul Shell Zsh
│   ├── .zshrc                 # History optimization, compinit, & zoxide
│   └── .config/zsh/
│       ├── aliases.zsh        # Modern CLI shortcuts (eza, git, dotfiles)
│       └── env.zsh            # PATH & Environment variables
├── starship/                  # Modul Cross-shell Prompt
│   └── .config/starship.toml  # Minimalist & blazingly fast status prompt
├── kitty/                     # Modul Terminal Emulator GPU
│   └── .config/kitty/
│       └── kitty.conf         # JetBrainsMono Nerd Font & Catppuccin styling
├── hypr/                      # Modul Wayland Window Manager
│   └── .config/hypr/
│       └── hyprland.conf      # Smooth bezier animations, vim navigation & dual gaps
├── waybar/                    # Modul Top Bar Desktop
│   └── .config/waybar/
│       ├── config.jsonc       # Modules: workspaces, clock, audio, battery, tray
│       └── style.css          # Catppuccin glassmorphism theme
├── rofi/                      # Modul Application Launcher
│   └── .config/rofi/
│       └── config.rasi        # Modern modal app/window switcher
└── .gitignore                 # Filter secrets, swap files, & temporary states
```

---

## 🚀 Panduan Instalasi Cepat

### 1. Kloning Repository
```bash
git clone https://github.com/<username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Jalankan Bootstrap Otomatis
Skrip `install.sh` mendeteksi distro Linux otomatis (Arch, Ubuntu/Debian, Fedora, SUSE), memasang paket pendukung, mencadangkan file lama ke `~/.dotfiles_backup/`, dan menghubungkan konfigurasi via GNU Stow:

```bash
chmod +x scripts/*.sh
./scripts/install.sh
```

> **Mode Non-Interaktif:** Untuk setup server atau container tanpa prompt interaktif:
> ```bash
> ./scripts/install.sh -y
> ```

---

## 🧰 Manajemen Modul dengan GNU Stow (`stow.sh`)

Gunakan wrapper `scripts/stow.sh` untuk mengelola modul secara parsial atau menyeluruh:

| Perintah | Deskripsi |
| :--- | :--- |
| `./scripts/stow.sh all` | Menghubungkan modul core terminal (`nvim`, `tmux`, `zsh`, `starship`) |
| `./scripts/stow.sh desktop` | Menghubungkan seluruh modul termasuk desktop (`hypr`, `waybar`, `kitty`, `rofi`) |
| `./scripts/stow.sh nvim` | Hanya menghubungkan konfigurasi Neovim |
| `./scripts/stow.sh tmux` | Hanya menghubungkan konfigurasi Tmux |
| `./scripts/stow.sh -R all` | **Restow / Re-link** seluruh paket jika ada file baru |
| `./scripts/stow.sh -D nvim` | **Hapus symlink** modul Neovim dari `$HOME` |

---

## 🧪 Validasi Clean Install (Test Harness)

Uji instalasi di container Ubuntu 24.04 bersih sebelum menjalankan di mesin utama:

```bash
chmod +x tests/run_test.sh
./tests/run_test.sh
```

---

## ⌨️ Rangkuman Pintasan Kunci Utama

### Neovim IDE
* `<Space>` — **Leader Key**
* `<leader>ff` — Cari berkas (*Find Files*) via Telescope
* `<leader>fg` — Pencarian teks mendalam (*Live Grep*) via Telescope
* `<leader>e` / `-` — Buka file manager interaktif (*Oil.nvim*)
* `gd` / `gr` — Lompat ke definisi / referensi fungsi (LSP)
* `K` — Tampilkan dokumentasi hover tipe data (LSP)
* `<leader>ca` — Tindakan kode (*Code Action*)
* `<leader>cf` — Format berkas otomatis (*Format Buffer*)
* `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` — Pindah fokus window/split

### Tmux Multiplexer
* `Ctrl-a` — **Prefix Key** (menggantikan default `Ctrl-b`)
* `Prefix + |` — Split window secara horizontal
* `Prefix + -` — Split window secara vertikal
* `Prefix + h / j / k / l` — Pindah antar-pane aktif
* `Prefix + r` — Reload konfigurasi tmux seketika
* `Prefix + I` — Install plugin via TPM

### Hyprland Wayland WM
* `SUPER + Return` — Buka terminal Kitty
* `SUPER + Space` — Buka aplikasi via Rofi
* `SUPER + Q` — Tutup jendela aktif
* `SUPER + F` — Toggle fullscreen
* `SUPER + V` — Toggle floating window
* `SUPER + H / J / K / L` — Pindah fokus jendela bergaya Vim
* `SUPER + 1..6` — Pindah workspace
