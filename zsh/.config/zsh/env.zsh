# ==============================================================================
# Environment Variables
# ==============================================================================

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Path exports
export PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"

# FZF default command menggunakan ripgrep jika ada
if command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi
