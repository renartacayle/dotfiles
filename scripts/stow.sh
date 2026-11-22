#!/usr/bin/env bash
# ==============================================================================
# Script: stow.sh
# Deskripsi: Orchestrator GNU Stow modular untuk menghubungkan config ke $HOME
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "${SCRIPT_DIR}")"
TARGET_DIR="${HOME}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Daftar default package yang akan distow jika argumen "all" atau kosong
AVAILABLE_PACKAGES=("nvim" "tmux" "zsh" "starship" "git" "bin")
OPTIONAL_PACKAGES=("hypr" "waybar" "alacritty" "kitty" "rofi")

check_stow_installed() {
    if ! command -v stow >/dev/null 2>&1; then
        log_error "GNU Stow tidak ditemukan di sistem!"
        log_info "Silakan install terlebih dahulu (misal: 'sudo pacman -S stow' atau 'sudo apt install stow')."
        exit 1
    fi
}

stow_package() {
    local pkg="$1"
    local flags="${2:-}"

    if [ ! -d "${DOTFILES_DIR}/${pkg}" ]; then
        log_warn "Direktori package '${pkg}' tidak ditemukan di ${DOTFILES_DIR}. Dilewati."
        return 0
    fi

    log_info "Menjalankan GNU Stow untuk: [${pkg}] ..."
    # Pastikan target parent directories yang umum sudah ada
    mkdir -p "${TARGET_DIR}/.config" "${TARGET_DIR}/.local/bin"

    # shellcheck disable=SC2086
    if stow --dir="${DOTFILES_DIR}" --target="${TARGET_DIR}" ${flags} "${pkg}"; then
        log_success "Package [${pkg}] berhasil ditautkan ke ${TARGET_DIR}."
    else
        log_error "Gagal menautkan package [${pkg}]. Cek konflik file."
        return 1
    fi
}

unstow_package() {
    local pkg="$1"
    log_warn "Menghapus tautan GNU Stow untuk: [${pkg}] ..."
    stow --dir="${DOTFILES_DIR}" --target="${TARGET_DIR}" -D "${pkg}" || true
}

restow_package() {
    local pkg="$1"
    log_info "Restowing [${pkg}] ..."
    stow --dir="${DOTFILES_DIR}" --target="${TARGET_DIR}" -R "${pkg}"
}

usage() {
    echo "Penggunaan: $0 [perintah] [package...]"
    echo ""
    echo "Perintah:"
    echo "  all                 Stow semua core packages default (${AVAILABLE_PACKAGES[*]})"
    echo "  desktop             Stow semua package termasuk WM/Desktop (${OPTIONAL_PACKAGES[*]})"
    echo "  <nama-pkg>          Stow package spesifik (contoh: $0 nvim)"
    echo "  --restow / -R       Re-link package yang sudah ada"
    echo "  --delete / -D       Hapus symlink package"
    echo "  --help              Tampilkan panduan ini"
}

main() {
    check_stow_installed
    cd "${DOTFILES_DIR}"

    local action="stow"
    local target_list=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --restow|-R)
                action="restow"
                shift
                ;;
            --delete|-D)
                action="delete"
                shift
                ;;
            all|"")
                target_list=("${AVAILABLE_PACKAGES[@]}")
                shift || true
                ;;
            desktop)
                target_list=("${AVAILABLE_PACKAGES[@]}" "${OPTIONAL_PACKAGES[@]}")
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                target_list+=("$1")
                shift
                ;;
        esac
    done

    if [ ${#target_list[@]} -eq 0 ]; then
        target_list=("${AVAILABLE_PACKAGES[@]}")
    fi

    for pkg in "${target_list[@]}"; do
        case "${action}" in
            delete)
                unstow_package "${pkg}"
                ;;
            restow)
                restow_package "${pkg}"
                ;;
            *)
                stow_package "${pkg}"
                ;;
        esac
    done

    log_success "Operasi Stow selesai!"
}

main "$@"
