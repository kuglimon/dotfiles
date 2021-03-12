# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# Set GOPATH
export GOPATH=$HOME/development/golang

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash)"
fi

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# load binaries in GOPATH
export PATH="$HOME/development/golang/bin:$PATH"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
