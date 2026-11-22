#!/usr/bin/env bash
# ==============================================================================
# Script: run_test.sh
# Deskripsi: Menjalankan automated test harness menggunakan Docker atau Podman
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "${SCRIPT_DIR}")"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[TEST INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[TEST PASSED]${NC} $*"; }
log_error() { echo -e "${RED}[TEST FAILED]${NC} $*"; }

CONTAINER_CMD=""
if command -v docker >/dev/null 2>&1; then
    CONTAINER_CMD="docker"
elif command -v podman >/dev/null 2>&1; then
    CONTAINER_CMD="podman"
else
    log_error "Docker atau Podman tidak ditemukan! Pasang salah satunya untuk menjalankan test harness lokal."
    exit 1
fi

log_info "Menggunakan container engine: ${CONTAINER_CMD}"
log_info "Membangun container test image dari Dockerfile..."

cd "${DOTFILES_DIR}"

if ${CONTAINER_CMD} build -t dotfiles-test -f tests/Dockerfile .; then
    log_success "Build & Verification test selesai dengan sukses 100%!"
    log_info "Untuk masuk dan menguji interaktif di dalam container: '${CONTAINER_CMD} run -it --rm dotfiles-test'"
else
    log_error "Verifikasi instalasi gagal di dalam clean container!"
    exit 1
fi
