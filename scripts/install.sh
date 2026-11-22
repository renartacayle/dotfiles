#!/usr/bin/env bash
# ==============================================================================
# Script: install.sh
# Deskripsi: Bootstrap installer otomatis & idempoten untuk setup dotfiles
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "${SCRIPT_DIR}")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

AUTO_YES=false

parse_args() {
    for arg in "$@"; do
        case "${arg}" in
            -y|--yes)
                AUTO_YES=true
                ;;
            --help|-h)
                echo "Usage: $0 [-y|--yes]"
                exit 0
                ;;
        esac
    done
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        DISTRO="${ID:-unknown}"
        DISTRO_LIKE="${ID_LIKE:-unknown}"
    else
        DISTRO="unknown"
        DISTRO_LIKE="unknown"
    fi
    log_info "Distro terdeteksi: ${BOLD}${DISTRO}${NC} (Base: ${DISTRO_LIKE})"
}

install_system_packages() {
    log_info "Memeriksa dan menginstal paket sistem yang dibutuhkan..."
    local sudo_cmd=""
    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            sudo_cmd="sudo"
        else
            log_error "Perintah 'sudo' tidak ditemukan dan skrip tidak dijalankan sebagai root!"
            exit 1
        fi
    fi

    case "${DISTRO}" in
        arch|manjaro|endeavouros)
            log_info "Menggunakan pacman untuk instalasi paket..."
            ${sudo_cmd} pacman -Sy --needed --noconfirm \
                git curl zsh tmux stow neovim ripgrep fd fzf base-devel zoxide
            ;;
        ubuntu|debian|pop|linuxmint)
            log_info "Menggunakan apt untuk instalasi paket..."
            ${sudo_cmd} apt update
            ${sudo_cmd} apt install -y \
                git curl zsh tmux stow ripgrep fd-find fzf build-essential
            # Cek versi neovim di apt, jika di bawah 0.9 pasang appimage atau tarball
            install_modern_neovim_debian
            ;;
        fedora)
            log_info "Menggunakan dnf untuk instalasi paket..."
            ${sudo_cmd} dnf install -y \
                git curl zsh tmux stow neovim ripgrep fd-find fzf @development-tools zoxide
            ;;
        opensuse*|suse)
            log_info "Menggunakan zypper untuk instalasi paket..."
            ${sudo_cmd} zypper install -y -t pattern devel_basis
            ${sudo_cmd} zypper install -y git curl zsh tmux stow neovim ripgrep fd fzf
            ;;
        *)
            log_warn "Distro [${DISTRO}] belum dipetakan otomatis secara penuh."
            log_warn "Pastikan paket berikut terpasang manual: git, curl, zsh, tmux, stow, neovim (>=0.9), ripgrep, fzf."
            ;;
    esac
}

install_modern_neovim_debian() {
    if command -v nvim >/dev/null 2>&1; then
        local version
        version=$(nvim --version | head -n 1 | awk '{print $2}' | tr -d 'v')
        log_info "Neovim versi ${version} sudah terpasang."
        return 0
    fi

    log_info "Mengunduh Neovim release resmi (AppImage/Binary)..."
    mkdir -p "${HOME}/.local/bin"
    curl -Lo "${HOME}/.local/bin/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage || true
    if [ -f "${HOME}/.local/bin/nvim" ]; then
        chmod u+x "${HOME}/.local/bin/nvim"
        log_success "Neovim latest berhasil diunduh ke ~/.local/bin/nvim"
    else
        log_warn "Gagal mengunduh Neovim AppImage otomatis. Pasang Neovim secara manual jika dibutuhkan."
    fi
}

install_starship() {
    if ! command -v starship >/dev/null 2>&1; then
        log_info "Menginstal Starship cross-shell prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "${HOME}/.local/bin"
        log_success "Starship berhasil diinstal ke ~/.local/bin/starship"
    else
        log_info "Starship sudah terpasang."
    fi
}

install_tpm() {
    local tpm_dir="${HOME}/.tmux/plugins/tpm"
    if [ ! -d "${tpm_dir}" ]; then
        log_info "Mengkloning Tmux Plugin Manager (TPM)..."
        git clone --depth 1 https://github.com/tmux-plugins/tpm "${tpm_dir}"
        log_success "TPM berhasil dipasang ke ${tpm_dir}"
    else
        log_info "TPM sudah ada di ${tpm_dir}."
    fi
}

setup_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh || true)"
    if [ -n "${zsh_path}" ] && [ "${SHELL:-}" != "${zsh_path}" ]; then
        if [ "${AUTO_YES}" = true ]; then
            log_info "Mengubah default shell ke ${zsh_path}..."
            chsh -s "${zsh_path}" || log_warn "Gagal menjalankan chsh otomatis, silakan ubah manual."
        else
            read -rp "Ingin mengubah shell default ke Zsh (${zsh_path})? [y/N]: " choice
            if [[ "${choice}" =~ ^[Yy]$ ]]; then
                chsh -s "${zsh_path}"
                log_success "Default shell berhasil diubah ke Zsh."
            fi
        fi
    fi
}

main() {
    parse_args "$@"
    echo -e "${BOLD}${BLUE}====================================================${NC}"
    echo -e "${BOLD}${GREEN}   Dotfiles & Developer Setup Bootstrap Installer   ${NC}"
    echo -e "${BOLD}${BLUE}====================================================${NC}"

    detect_distro
    install_system_packages
    install_starship
    install_tpm

    # Pemasangan Font & Icon Assets
    if [ -f "${SCRIPT_DIR}/install_fonts.sh" ]; then
        bash "${SCRIPT_DIR}/install_fonts.sh" || log_warn "Instalasi font dilewati atau gagal secara non-fatal."
    fi

    # 1. Jalankan Backup Aman
    log_info "Langkah 1/2: Menjalankan cadangan konfigurasi lama..."
    bash "${SCRIPT_DIR}/backup.sh"

    # 2. Jalankan GNU Stow
    log_info "Langkah 2/2: Menautkan konfigurasi via GNU Stow..."
    bash "${SCRIPT_DIR}/stow.sh" all

    # 3. Setup Shell
    setup_default_shell

    echo ""
    echo -e "${BOLD}${GREEN}====================================================${NC}"
    echo -e "${BOLD}${GREEN}   Instalasi Selesai! Selamat Datang di Setup Baru! ${NC}"
    echo -e "${BOLD}${GREEN}====================================================${NC}"
    log_info "Buka terminal baru atau ketik: 'zsh' untuk mulai menikmati lingkungan baru."
}

main "$@"
