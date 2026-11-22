# ==============================================================================
# Dockerfile: Clean Ubuntu Environment Test Harness for Dotfiles
# ==============================================================================

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install minimal bootstrap prerequisites
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    ca-certificates \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Konfigurasi locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Buat non-root user untuk simulasi user nyata dengan hak akses sudo
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser/dotfiles

# Salin source repo dotfiles ke dalam container
COPY --chown=testuser:testuser . .

# Eksekusi bootstrap installer non-interaktif
RUN chmod +x scripts/*.sh && ./scripts/install.sh -y

# Verification step (Memastikan seluruh symlink inti terbentuk sempurna)
RUN test -L /home/testuser/.zshrc && \
    test -L /home/testuser/.config/nvim && \
    test -L /home/testuser/.config/tmux && \
    test -L /home/testuser/.config/starship.toml && \
    echo "VERIFICATION PASSED: All core dotfiles symlinks are properly established!"

CMD ["/bin/zsh"]
