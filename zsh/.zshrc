# Greg Anders (gpanders)'s ZSH configuration <https://github.com/gpanders/dotfiles.git>

# Enable emacs/readline style keybindings
bindkey -e

# Enable completion (this needs to be done before sourcing plugins)
autoload -Uz compinit && compinit

# Install zsh plugins with antibody
if [[ ! -f "${ZDOTDIR:-$HOME}/.zplugins" ]]; then
  echo "Installing zsh plugins. We only need to do this once."
  antibody bundle "
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-completions
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    robbyrussell/oh-my-zsh path:plugins/fzf
    sorin-ionescu/prezto path:modules/gnu-utility
    mafredri/zsh-async
    sindresorhus/pure
  " > ${ZDOTDIR:-$HOME}/.zplugins
fi
source "${ZDOTDIR:-$HOME}/.zplugins"

# zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# History settings
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

# Perform textual history expansion, csh-style, treating the character `!`
# specially.
setopt BANG_HIST

# Don't allow duplicates in history
setopt HIST_IGNORE_DUPS

# Remove command lines from history list when the first character is a space
setopt HIST_IGNORE_SPACE

# Verify an expanded command before executing
setopt HIST_VERIFY

# Treat single word simple commands without redirection as candidates for
# resumption of an existing job
setopt AUTO_RESUME

# Allow comments starting with `#` even in interactive shells
setopt INTERACTIVE_COMMENTS

# List jobs in the long format by default
setopt LONG_LIST_JOBS

# Report the status of background jobs immediately, rather than waiting until
# just before printing a prompt
setopt NOTIFY

# Prevent running all background jobs at a lower priority
setopt NO_BG_NICE

# cd adds directories to dirstack
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

# Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

# This reverses the +/- operators
setopt PUSHD_MINUS

# Append to history file instead of overwriting
setopt APPENDHISTORY

# Allow for extended glob patterns
setopt EXTENDEDGLOB

# Write to multiple descriptors.
setopt MULTIOS

# Disable flow control
unsetopt FLOW_CONTROL

# Don't throw an error if there is no match
unsetopt NOMATCH

# Split words on slashes (useful for paths)
WORDCHARS=${WORDCHARS/\/}

bindkey '^ ' autosuggest-accept
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^Q' push-line-or-edit
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Disable flow control
if (( $+commands[stty] )); then
  stty -ixon
fi

# Enable dircolors
if (( $+commands[dircolors] )); then
  if [[ -f "$HOME/.dircolors" ]]; then
    eval "$(dircolors $HOME/.dircolors)"
  else
    eval "$(dircolors --sh)"
  fi
fi

# Setup nvm
if [[ -s "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  function nvm {
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
      source "$NVM_DIR/nvm.sh"
      nvm use system
      nvm $@
    fi
  }
fi

# Export GPG TTY
export GPG_TTY=$(tty)

# Configure fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Source aliases
if [[ -f "${ZDOTDIR:-$HOME}/.zaliases" ]]; then
  source "${ZDOTDIR:-$HOME}/.zaliases"
fi

# Source custom functions
if [[ -f "${ZDOTDIR:-$HOME}/.zfunctions" ]]; then
  source "${ZDOTDIR:-$HOME}/.zfunctions"
fi

# Remove duplicates in path variables
typeset -gU path fpath cdpath manpath
