# ~/.zshrc — efficient portable config

# Machine-specific config goes in ~/.zshrc.local

# Stop here for non-interactive shells.

[[ $- != *i* ]] && return

############################################################

# Powerlevel10k instant prompt — must stay near the top

############################################################
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

############################################################

# XDG directories

############################################################
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_DATA_DIR="$XDG_DATA_HOME/zsh"
export ZSH_STATE_DIR="$XDG_STATE_HOME/zsh"

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
[[ -d "$ZSH_DATA_DIR" ]] || mkdir -p "$ZSH_DATA_DIR"
[[ -d "$ZSH_STATE_DIR" ]] || mkdir -p "$ZSH_STATE_DIR"

############################################################

# PATH

############################################################
typeset -U path PATH

path=(
"$HOME/bin"
"$HOME/.local/bin"
"$HOME/.cargo/bin"
"$HOME/.atuin/bin"
$path
)

export EDITOR="${EDITOR:-nano}"
export VISUAL="${VISUAL:-$EDITOR}"

############################################################

# Fast helpers

############################################################
_has() {
(( $+commands[$1] ))
}

_source_if_exists() {
[[ -r "$1" ]] && source "$1"
}

# Cache shell integrations that normally require eval "$(tool init zsh)".

_cached_init() {
local name="$1"
shift

local cmd="$1"
local bin="${commands[$cmd]}"
local cache="$ZSH_CACHE_DIR/init-${name}.zsh"

[[ -n "$bin" ]] || return

if [[ ! -s "$cache" || "$bin" -nt "$cache" ]]; then
"$@" >| "$cache" 2>/dev/null || {
rm -f "$cache"
return
}
fi

source "$cache"
}

############################################################

# History

############################################################
HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=20000
SAVEHIST=20000

setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt extended_history

setopt auto_cd
setopt interactive_comments
setopt no_beep

############################################################

# Completion

############################################################
autoload -Uz compinit

_zcompdump="$ZSH_CACHE_DIR/zcompdump-${ZSH_VERSION}"

# Fast path: skip security re-checks when cache exists.

# If completions become stale, run:

# rm -f ~/.cache/zsh/zcompdump-*

if [[ -s "$_zcompdump" ]]; then
compinit -C -d "$_zcompdump"
else
compinit -i -d "$_zcompdump"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/completions"

############################################################

# Keymap

############################################################
bindkey -e

############################################################

# External tools

############################################################
_has zoxide && _cached_init zoxide zoxide init zsh
_has direnv && _cached_init direnv direnv hook zsh

# Atuin handles Ctrl+R if installed.

_has atuin && _cached_init atuin atuin init zsh

############################################################

# General aliases

############################################################
#
if _has eza; then
alias ls='eza --group-directories-first --icons'
alias ll='eza -lah --group-directories-first --icons'
alias la='eza -la --group-directories-first --icons'
else
alias ll='ls -lah'
alias la='ls -la'
fi

if _has bat; then
alias cat='bat'
elif _has batcat; then
alias cat='batcat'
fi
alias icat='kitten icat'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias t='tmux'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias cls='clear'
alias update='sudo dnf upgrade --refresh'

alias zpdf='zathura >/dev/null 2>&1 &!'

############################################################
#
# git aliases
#
############################################################

alias gts='git status --short --branch'
alias gtl='git log --oneline --graph --decorate --all'
alias gtc='git commit -m'
############################################################

# Neovim / LazyVim

############################################################
unalias lazyvim lvim 2>/dev/null

lazyvim() {
if _has nvim; then
NVIM_APPNAME=lazyvim nvim "$@"
else
print -u2 "lazyvim: nvim non trovato nel PATH"
return 127
fi
}

lvim() {
lazyvim "$@"
}

############################################################

# C / C++

############################################################

# GCC default: debug build
alias ccdbg='gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -g3 -Og'

# GCC default: sanitizer build
alias ccsan='gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -g3 -O0 -fsanitize=address,undefined -fno-omit-frame-pointer'

# Clang second opinion
alias ccclang='clang -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -g3 -Og'

# Clang sanitizer second opinion
alias csanclang='clang -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -g3 -O0 -fsanitize=address,undefined -fno-omit-frame-pointer'

# Formatting
alias cf='clang-format -i'

############################################################

# Python

############################################################
alias ruffc='ruff check .'
alias pyfix='ruff check . --fix'
alias rufff='ruff format .'

unalias pytest 2>/dev/null

pytest() {
if [[ -x .venv/bin/python ]]; then
.venv/bin/python -m pytest "$@"
else
python3 -m pytest "$@"
fi
}

############################################################

# LaTeX

############################################################
alias mk='latexmk -lualatex -interaction=nonstopmode -file-line-error'
alias mks='latexmk -lualatex -interaction=nonstopmode -file-line-error -synctex=1'
alias mkc='latexmk -C'
############################################################

# FZF

############################################################
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:---height 40% --layout=reverse --border}"

if _has fzf; then

# Ctrl+R fallback only if Atuin is not installed.

if ! _has atuin; then
__fzf_history__() {
local selected
selected=$(fc -rl 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//' | fzf --tac --query "$LBUFFER")
[[ -n "$selected" ]] && LBUFFER="$selected"
zle redisplay
}

```
zle -N __fzf_history__
bindkey '^R' __fzf_history__
```

fi

__fzf_files__() {
local selected

```
if _has fd; then
  selected=$(fd --type f --hidden --follow --exclude .git 2>/dev/null | fzf)
elif _has fdfind; then
  selected=$(fdfind --type f --hidden --follow --exclude .git 2>/dev/null | fzf)
else
  selected=$(find . -type f -not -path '*/.git/*' 2>/dev/null | fzf)
fi

[[ -n "$selected" ]] && LBUFFER+="$selected"
zle redisplay
```

}

zle -N __fzf_files__
bindkey '^T' __fzf_files__
fi

############################################################

# Theme — Powerlevel10k

############################################################
P10K_DIR="$ZSH_DATA_DIR/powerlevel10k"

_source_if_exists "$P10K_DIR/powerlevel10k.zsh-theme"
_source_if_exists "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run: p10k configure

_source_if_exists "$HOME/.p10k.zsh"
_source_if_exists "$XDG_CONFIG_HOME/p10k/p10k.zsh"

############################################################

# Toolchains

############################################################

# Generic local env, if present.

_source_if_exists "$HOME/.local/bin/env"

# nvm — lazy loaded.

# It is intentionally not sourced at startup because nvm is often slow.

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[[ -s "$NVM_DIR/nvm.sh" ]] || export NVM_DIR="$XDG_CONFIG_HOME/nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
_load_nvm() {
unset -f nvm node npm npx
_source_if_exists "$NVM_DIR/nvm.sh"
_source_if_exists "$NVM_DIR/bash_completion"
}

nvm() {
_load_nvm
nvm "$@"
}

node() {
_load_nvm
command node "$@"
}

npm() {
_load_nvm
command npm "$@"
}

npx() {
_load_nvm
command npx "$@"
}
fi

# GHCup, if installed.

_source_if_exists "$HOME/.ghcup/env"

############################################################

# Machine-local overrides

############################################################
_source_if_exists "$HOME/.zshrc.local"

############################################################

# Plugins — keep at the very end

############################################################
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

_source_if_exists "$ZSH_DATA_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting should be loaded last.

_source_if_exists "$ZSH_DATA_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export PATH="$HOME/.config/emacs/bin:$PATH"
