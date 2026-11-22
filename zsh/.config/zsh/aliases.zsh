# ==============================================================================
# Shell Aliases
# ==============================================================================

# Navigasi cepat
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Listing direktori modern (fallback jika eza/lsd belum ada)
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza -la --icons --git"
    alias tree="eza --tree --icons"
else
    alias ls="ls --color=auto"
    alias ll="ls -lah --color=auto"
fi

# Neovim & Editor
alias v="nvim"
alias vim="nvim"

# Git shortcuts
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --decorate --all"

# Dotfiles helper
alias dotfiles="cd \$HOME/dotfiles || cd \$HOME/.gemini/antigravity/scratch/dotfiles"
alias dotstow="bash \$HOME/.gemini/antigravity/scratch/dotfiles/scripts/stow.sh all"
