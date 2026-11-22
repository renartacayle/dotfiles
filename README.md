# ⚙️ Dotfiles & Developer Environment

Repository konfigurasi lingkungan pengembangan modular, idempoten, dan modern berbasis **GNU Stow**, **Neovim (Lua + lazy.nvim)**, **Tmux (TPM + TrueColor)**, **Zsh + Starship**, dan skrip installer otomatis.

---

## 📂 Struktur Direktori Modular

Repository ini menggunakan paradigma *package-based* GNU Stow, di mana setiap modul terisolasi dan dapat di-*stow* secara independen:

```text
dotfiles/
├── nvim/                      # Modul Neovim
│   └── .config/nvim/
│       ├── init.lua           # Entrypoint utama
│       └── lua/config/
│           ├── options.lua    # Setting editor & indentasi
│           ├── keymaps.lua    # Pintasan keyboard ergonomis
│           └── lazy.lua       # Bootstrap & setup lazy.nvim
├── tmux/                      # Modul Multiplexer Tmux
│   └── .config/tmux/
│       └── tmux.conf          # Prefix C-a, truecolor, & vim-keys
├── zsh/                       # Modul Shell Zsh
│   ├── .zshrc                 # Konfigurasi shell & history
│   └── .config/zsh/
│       ├── aliases.zsh        # Git, navigation, & CLI alias
│       └── env.zsh            # PATH & Environment variables
├── starship/                  # Modul Prompt Terminal
│   └── .config/starship.toml  # Minimalist & blazingly fast prompt
├── scripts/                   # Automasi & Bootstrap
│   ├── install.sh             # Skrip instalasi lintas-distro idempoten
│   ├── backup.sh              # Skrip pencadangan aman (zero data loss)
│   └── stow.sh                # Wrapper manajemen symlink GNU Stow
└── .gitignore                 # Filter file rahasia, history, & temporary
```

---

## 🚀 Panduan Instalasi Cepat

### 1. Kloning Repository
```bash
git clone https://github.com/<username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Jalankan Bootstrap Otomatis
Skrip `install.sh` akan mendeteksi distro Linux secara otomatis, memasang paket pendukung, mencadangkan file lama ke `~/.dotfiles_backup/`, dan menghubungkan seluruh dotfiles via GNU Stow:

```bash
chmod +x scripts/*.sh
./scripts/install.sh
```

> **Mode Non-Interaktif:** Untuk setup server atau container tanpa prompt interaktif, gunakan:
> ```bash
> ./scripts/install.sh -y
> ```

---

## 🛡️ Mekanisme Cadangan Aman (`backup.sh`)

Sebelum tautan symlink dibuat, `scripts/backup.sh` otomatis mendeteksi file konfigurasi yang sudah ada di sistem dan memindahkannya ke direktori timestamp:

```text
~/.dotfiles_backup/backup_YYYYMMDD_HHMMSS/
```

Konfigurasi lama Anda **tidak akan pernah ditimpa atau dihapus secara permanen**.

---

## 🧰 Manajemen Modul dengan GNU Stow (`stow.sh`)

Gunakan wrapper `scripts/stow.sh` untuk mengelola modul secara parsial atau menyeluruh:

| Perintah | Deskripsi |
| :--- | :--- |
| `./scripts/stow.sh all` | Menghubungkan seluruh modul core (`nvim`, `tmux`, `zsh`, `starship`) |
| `./scripts/stow.sh nvim` | Hanya menghubungkan konfigurasi Neovim |
| `./scripts/stow.sh tmux` | Hanya menghubungkan konfigurasi Tmux |
| `./scripts/stow.sh -R all` | **Restow / Re-link** seluruh paket jika ada file baru |
| `./scripts/stow.sh -D nvim` | **Hapus symlink** modul Neovim dari `$HOME` |

---

## ⌨️ Rangkuman Pintasan Kunci Utama

### Neovim
* `<Space>` — **Leader Key**
* `<leader>w` — Simpan file (`:w`)
* `<leader>q` — Keluar editor (`:q`)
* `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` — Pindah fokus window/split
* `J` / `K` (Visual mode) — Geser blok baris ke atas / ke bawah
* `<C-d>`, `<C-u>` — Scroll setengah halaman dengan kursor tetap di tengah layar

### Tmux
* `Ctrl-a` — **Prefix Key** (menggantikan default `Ctrl-b`)
* `Prefix + |` — Split window secara horizontal
* `Prefix + -` — Split window secara vertikal
* `Prefix + h / j / k / l` — Pindah antar-pane aktif
* `Prefix + r` — Reload konfigurasi tmux seketika
* `Prefix + I` — Install plugin via TPM

---

## 💡 Ekstensi Lanjutan (Next Step)
Untuk menambahkan modul GUI / Window Manager (seperti **Hyprland**, **Waybar**, atau **Kitty**), buat folder baru dengan struktur mirroring `$HOME`:
```bash
mkdir -p hypr/.config/hypr
touch hypr/.config/hypr/hyprland.conf
./scripts/stow.sh hypr
```
