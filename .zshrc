if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# general
export EDITOR="vim"
export TERM=xterm-256color
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin" # path, .local is pipx

# OMZ
export ZSH="$HOME/.zsh/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.zsh/custom"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(z zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# aliases
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias la='eza -A --icons'
  alias ll='eza -l'
  alias lla='eza -Al'
  alias lt='eza --tree'
  alias lta'eza -A  --tree'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons'
  alias la='exa -a --icons'
  alias ll='exa -l'
  alias lla='exa -al'
  alias lt='exa --tree'
  alias lta='exa -a --tree'
fi

if command -v podman >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
  alias docker='podman'
  alias docker-compose="podman-compose"
fi

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f"
fi

# Debian quirk
if ! command -v python3 >/dev/null 2>&1; then
  alias python='python3'
fi

alias venv="python -m venv venv && source venv/bin/activate && pip install -r requirements.txt"

if command -v zeditor >/dev/null 2>&1; then
  alias zed="zeditor"
fi

if command -v zed >/dev/null 2>&1; then
  alias zd="zed"
  zf() { zd "$(fzf)" }
fi

alias scp="scp -O" # THIS SHIT NEVER WORKS

source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh/.p10k.zsh

