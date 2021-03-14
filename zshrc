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

    if [[ $(git diff --stat) != '' ]]; then
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
PROMPT+='%{$fg_bold[cyan]%}%~%{$reset_color%}'

# current git branch if we're in a repository
PROMPT+=' $(git_prompt_info)'

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word

# Search command history based on the command typed.
# So for example say you've typed the following:
#
#  $ git co
#
# Pressing up would search the history for commands
# starting with 'git co'
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

