#!/usr/bin/env bash
# ==============================================================================
# Script: test_symlinks_dryrun.sh
# Deskripsi: Validasi struktur paket, kelengkapan berkas, dan simulasi symlink XDG
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "${SCRIPT_DIR}")"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[TEST]${NC} $*"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $*"; }
log_fail() { echo -e "${RED}[FAIL]${NC} $*"; }

log_info "Memulai validasi struktur paket dotfiles (Dry-Run Engine)..."

PACKAGES=("nvim" "tmux" "zsh" "starship" "kitty" "alacritty" "hypr" "waybar" "rofi" "cava" "hyprlock")
TOTAL_FILES=0
FAILED=0

for pkg in "${PACKAGES[@]}"; do
    pkg_dir="${DOTFILES_DIR}/${pkg}"
    if [ ! -d "${pkg_dir}" ]; then
        log_fail "Direktori paket [${pkg}] tidak ditemukan!"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Temukan semua file di dalam paket
    files=$(find "${pkg_dir}" -type f)
    for f in ${files}; do
        rel_path="${f#${pkg_dir}/}"
        simulated_target="${HOME}/${rel_path}"

        if [ ! -s "${f}" ]; then
            log_fail "File kosong: ${f}"
            FAILED=$((FAILED + 1))
        else
            log_pass "Package [${pkg}]: ${rel_path} -> ${simulated_target}"
            TOTAL_FILES=$((TOTAL_FILES + 1))
        fi
    done
done

echo ""
if [ "${FAILED}" -eq 0 ]; then
    log_pass "Seluruh ${TOTAL_FILES} berkas konfigurasi valid dan siap di-stow ke \$HOME!"
    exit 0
else
    log_fail "Ditemukan ${FAILED} kesalahan pada struktur dotfiles!"
    exit 1
fi
