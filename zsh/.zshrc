# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="railey"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# nvm (Lazy Loaded)
export NVM_DIR="$HOME/.nvm"

# 1. Define the load function
load_nvm() {
  # Remove the placeholder functions
  unset -f nvm node npm npx yarn pnpm
  
  # Load NVM using your exact Homebrew paths
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

# 2. Map Node commands to trigger the load function first
nvm() { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm() { load_nvm; npm "$@"; }
npx() { load_nvm; npx "$@"; }
yarn() { load_nvm; yarn "$@"; }
pnpm() { load_nvm; pnpm "$@"; }


# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Aliases
alias cpdir="pwd | pbcopy"
