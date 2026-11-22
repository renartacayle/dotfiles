#!/usr/bin/env bash
# ==============================================================================
# Script: install_fonts.sh
# Deskripsi: Mengunduh dan memasang JetBrainsMono Nerd Font & Papirus Icons
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[FONT INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[FONT SUCCESS]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[FONT WARN]${NC} $*"; }
log_error() { echo -e "${RED}[FONT ERROR]${NC} $*"; }

FONT_DIR="${HOME}/.local/share/fonts/JetBrainsMonoNerd"
NERD_FONT_VERSION="v3.2.1"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/JetBrainsMono.tar.xz"

install_nerd_font() {
    log_info "Memeriksa JetBrainsMono Nerd Font..."
    if fc-list : family | grep -qi "JetBrainsMono Nerd Font" 2>/dev/null; then
        log_success "JetBrainsMono Nerd Font sudah terpasang di sistem."
        return 0
    fi

    log_info "Mengunduh JetBrainsMono Nerd Font (${NERD_FONT_VERSION})..."
    mkdir -p "${FONT_DIR}"
    local tmp_tar
    tmp_tar="$(mktemp --suffix=.tar.xz)"

    if curl -sSL --fail "${FONT_URL}" -o "${tmp_tar}"; then
        log_info "Mengekstrak font ke ${FONT_DIR}..."
        tar -xf "${tmp_tar}" -C "${FONT_DIR}"
        rm -f "${tmp_tar}"

        if command -v fc-cache >/dev/null 2>&1; then
            log_info "Memperbarui cache font sistem (fc-cache)..."
            fc-cache -fv "${HOME}/.local/share/fonts" >/dev/null 2>&1 || true
        fi
        log_success "JetBrainsMono Nerd Font berhasil dipasang!"
    else
        log_warn "Gagal mengunduh font otomatis. Pastikan ada koneksi internet."
        rm -f "${tmp_tar}"
    fi
}

install_papirus_icons() {
    log_info "Memeriksa ikon tema Papirus..."
    local icons_dir="${HOME}/.local/share/icons/Papirus"

    if [ -d "${icons_dir}" ] || [ -d "/usr/share/icons/Papirus" ]; then
        log_success "Tema ikon Papirus sudah terpasang."
        return 0
    fi

    log_info "Menginstal Papirus Icon Theme via git clone/installer..."
    mkdir -p "${HOME}/.local/share/icons"
    if curl -sSL https://git.io/papirus-icon-theme-install | env DESTDIR="${HOME}/.local/share/icons" sh 2>/dev/null; then
        log_success "Papirus Icon Theme berhasil dipasang ke ~/.local/share/icons/Papirus"
    else
        log_warn "Gagal mengunduh tema Papirus otomatis. Pasang via package manager (cth: sudo apt install papirus-icon-theme)."
    fi
}

main() {
    install_nerd_font
    install_papirus_icons
    log_success "Proses instalasi font & aset grafis tuntas!"
}

main "$@"
