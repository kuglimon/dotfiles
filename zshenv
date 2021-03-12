# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# Set GOPATH
export GOPATH=$HOME/development/golang

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# load personal helpers
export PATH="$HOME/.bin:$PATH"

# load binaries in GOPATH
export PATH="$HOME/development/golang/bin:$PATH"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
