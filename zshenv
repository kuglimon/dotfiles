# use vim as the visual editor
source "$HOME/development/personal/dotfiles/zsh/functions/is_os"

export VISUAL=vim
export EDITOR=$VISUAL

# Set GOPATH
export GOPATH=$HOME/development/golang

if if_osx; then
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
fi

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# load personal helpers
export PATH="$HOME/bin:$PATH"

# load binaries in GOPATH
export PATH="$HOME/development/golang/bin:$PATH"

# Use bat for man if available
if type "bat" > /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
