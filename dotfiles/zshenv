# use vim as the visual editor
source "$HOME/.zsh/functions/is_os"

export VISUAL=nvim
export EDITOR=$VISUAL

# Set GOPATH
export GOPATH=$HOME/development/golang

if if_osx; then
  export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
fi

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.local/bin:$PATH"

# load binaries in GOPATH
export PATH="$HOME/development/golang/bin:$PATH"

# Use bat for man if available
if type "bat" > /dev/null; then
  # 2023.16.10 I had to add this, otherwise manpages would show shell color
  # codes within the documentation.
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
