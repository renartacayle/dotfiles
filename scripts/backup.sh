#!/usr/bin/env bash
# ==============================================================================
# Script: backup.sh
# Deskripsi: Mencadangkan konfigurasi lama sebelum proses linking/stow
# ==============================================================================

set -euo pipefail

BACKUP_ROOT="${HOME}/.dotfiles_backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET_BACKUP="${BACKUP_ROOT}/backup_${TIMESTAMP}"

# Warna log terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Daftar path yang diproteksi
PROTECTED_PATHS=(
    "${HOME}/.zshrc"
    "${HOME}/.bashrc"
    "${HOME}/.tmux.conf"
    "${HOME}/.config/nvim"
    "${HOME}/.config/tmux"
    "${HOME}/.config/zsh"
    "${HOME}/.config/starship.toml"
    "${HOME}/.config/alacritty"
    "${HOME}/.config/kitty"
    "${HOME}/.config/hypr"
    "${HOME}/.config/waybar"
    "${HOME}/.config/rofi"
    "${HOME}/.config/wofi"
)

perform_backup() {
    log_info "Memeriksa file konfigurasi lama untuk dicadangkan..."
    local backed_up_count=0

    mkdir -p "${TARGET_BACKUP}"

    for path in "${PROTECTED_PATHS[@]}"; do
        if [ -e "${path}" ] || [ -L "${path}" ]; then
            # Jangan backup jika path sudah merupakan symlink yang mengarah ke dotfiles ini
            if [ -L "${path}" ]; then
                target=$(readlink -f "${path}" || true)
                if [[ "${target}" == *"dotfiles"* ]]; then
                    log_warn "Melewati symlink dotfiles eksisting: ${path}"
                    continue
                fi
            fi

            rel_path="${path#${HOME}/}"
            dest_dir="${TARGET_BACKUP}/$(dirname "${rel_path}")"
            mkdir -p "${dest_dir}"

            log_info "Memindahkan: ${path} -> ${TARGET_BACKUP}/${rel_path}"
            mv "${path}" "${TARGET_BACKUP}/${rel_path}"
            backed_up_count=$((backed_up_count + 1))
        fi
    done

    if [ "${backed_up_count}" -gt 0 ]; then
        log_success "Berhasil mencadangkan ${backed_up_count} file/direktori ke: ${TARGET_BACKUP}"
    else
        log_info "Tidak ada file lama yang perlu dicadangkan (lingkungan bersih)."
        rm -rf "${TARGET_BACKUP}"
        # Hapus root backup jika kosong
        rmdir "${BACKUP_ROOT}" 2>/dev/null || true
    fi
}

main() {
    perform_backup
}

main "$@"
