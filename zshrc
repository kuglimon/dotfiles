# completion
autoload -U compinit
compinit

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

  if [[ -n $current_branch ]]; then
    printf '%s' "%{$fg_bold[blue]%}git:("

    if [[ $(git diff --stat 2> /dev/null) != '' ]]; then
      printf '%s' "%{$fg[red]%}"
    else
      printf '%s' "%{$fg[green]%}"
    fi

    printf '%s' "$current_branch%{$reset_color%}) "
  fi
}

setopt prompt_subst

# prints an arrow ➜, red if the last command failed green if ok
PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )'

# current dir from $HOME
PROMPT+='%{$fg_bold[cyan]%}%1d%{$reset_color%}'

# current git branch if we're in a repository
PROMPT+=' $(git_prompt_info)'

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# TODO: Check if I need all of these
# I don't even know what some of these do... I copied these years ago from
# Thoughtbot dot files. But a few of these are in use:
#
#   autocd
#     This enables you to just type a path and cd on it. So let's say you're in
#     a directory with subdirectories 'dev/log' rather than typing 'cd dev/log'
#     you can just type 'dev/log'
#
#   cdablevars
#     Zsh has named directories but they require to type tilde before the
#     directory name, in Finnish keyboard layout this is annoying as fuck. So
#     cdablevars makes it so that it'll first check if the text you gave is a
#     directory, then it'll check if it's a named directory and expand that with
#     the tilde in place. It might do other stuff as well but this is the main
#     feature we're looking for.
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v

# CTRL-X CTRL-E edits current command in editor.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^p' edit-command-line

# Search command history based on the command typed.
# So for example say you've typed the following:
#
#  $ git co
#
# Pressing up would search the history for commands
# starting with 'git co'
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# This replaces: rbenv, nodenv, pyenv. Pyenv especially has been a constant
# fucking source of pain.
eval "$(mise activate zsh)"

# Named directories for directories I use all the time.
# These are SO much better than just having some crappy ass
# cd alias. You can just type the name and they're tab
# completable when cdablevars is enabled.
hash -d dotfiles=~/development/personal/dotfiles
hash -d layouts=~/development/personal/layouts

hash -d development=~/development
hash -d personal=~/development/personal
hash -d work=~/development/work
hash -d clients=~/development/work/clients
hash -d internal=~/development/work/internal

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
