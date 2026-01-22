if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# general
export EDITOR="nvim"
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


# aliases and alike
if command -v lacy >/dev/null 2>&1; then
  if command -v fzf >/dev/null 2>&1; then
    FZF='--custom-fuzzy=fzf'
  fi
  eval "$(lacy init zsh --cmd=cd $FZF)"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias la='eza -A --icons'
  alias ll='eza -l'
  alias lla='eza -Al'
  alias lt='eza --tree'
  alias lta'eza -A  --tree'
fi

if command -v podman >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
  alias docker='podman'
  alias docker-compose="podman-compose"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
fi

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f"
fi

if ! command -v python3 >/dev/null 2>&1; then
  alias python='python3'
fi

if command -v zeditor >/dev/null 2>&1; then
  alias zd="zeditor"
  zf() { zeditor "$(fzf)" }
elif command -v zed >/dev/null 2>&1; then
  alias zd="zed"
  zf() { zed "$(fzf)" }
fi

alias scp="scp -O" # THIS SHIT NEVER WORKS

alias nv="nvim"

source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh/.p10k.zsh

