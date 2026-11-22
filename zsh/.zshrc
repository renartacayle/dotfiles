# ==============================================================================
# Zsh Main Configuration
# ==============================================================================

# History configuration
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Catat timestamp di history
setopt HIST_EXPIRE_DUPS_FIRST    # Hapus duplikat terlama dulu
setopt HIST_IGNORE_DUPS          # Jangan catat perintah duplikat berurutan
setopt HIST_IGNORE_SPACE         # Jangan catat jika diawali spasi
setopt HIST_VERIFY               # Verifikasi sebelum eksekusi dari history expansion
setopt SHARE_HISTORY             # Bagikan history ke seluruh sesi zsh aktif

# Navigasi & Completion
setopt AUTO_CD                   # Cukup ketik nama folder untuk cd
setopt AUTO_PUSHD                # Push dir otomatis ke dirstack
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

autoload -Uz compinit
compinit

# Load Modular Configurations
[ -f "${HOME}/.config/zsh/env.zsh" ] && source "${HOME}/.config/zsh/env.zsh"
[ -f "${HOME}/.config/zsh/aliases.zsh" ] && source "${HOME}/.config/zsh/aliases.zsh"

# Inisialisasi Zoxide (Smart CD) jika tersedia
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Inisialisasi Starship Prompt jika tersedia
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
