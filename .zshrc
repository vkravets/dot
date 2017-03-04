export PATH=/usr/local/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

if [[ $1 == eval ]]
then
	"$@"
	set --
fi

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# powerlevel9k stuff
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon load dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode status time)
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6

POWERLEVEL9K_VI_INSERT_MODE_STRING="I"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="N"

POWERLEVEL9K_VCS_GIT_ICON=''
#POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
#POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
#POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
#POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
#POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

#POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
#POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
#POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

# for bundler plugin
BUNDLED_COMMANDS=(rubocop rake)

export PATH=$HOME/bin:/usr/local/bin:$PATH
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR=vim
export GIT_EDITOR=vim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="$HOME/.nvm"
export PATH=$NVM_DIR:$PATH
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

SAVEHIST=10000
HISTSIZE=10000
HISTCONTROL=ignoredups
HISTFILE=~/.zsh_history

bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"


ZPLUG_PROTOCOL=ssh

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

if [[ -z "$IDEA_TERMINAL" ]]
then
	zplug "~/.zsh/powerlevel9k", from:local, as:theme
else
	zplug "themes/risto" from:oh-my-zsh
fi

# Supports oh-my-zsh plugins and the like
zplug "plugins/vi-mode", from:oh-my-zsh 
zplug "plugins/cp",   from:oh-my-zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/github",   from:oh-my-zsh
zplug "plugins/ruby",   from:oh-my-zsh
zplug "plugins/rvm",   from:oh-my-zsh, defer:2
zplug "plugins/gem",   from:oh-my-zsh
zplug "plugins/mvn",   from:oh-my-zsh
zplug "plugins/osx",   from:oh-my-zsh
zplug "plugins/docker",   from:oh-my-zsh
zplug "plugins/docker-compose",   from:oh-my-zsh
zplug "plugins/brew",   from:oh-my-zsh
zplug "plugins/httpie",   from:oh-my-zsh
zplug "lib/history",   from:oh-my-zsh
zplug "glidenote/hub-zsh-completion"
zplug "zsh-users/zsh-completions"
zplug "willghatch/zsh-cdr"
zplug "mgryszko/jvm"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "caarlos0/zsh-git-sync"
zplug "supercrabtree/k"

zplug "marzocchi/zsh-notify"
zplug "lukechilds/zsh-better-npm-completion", defer:3
zplug "felixr/docker-zsh-completion"

export ENHANCD_FILTER=fzf:fzy:peco
zplug "b4b4r07/enhancd", use:init.sh

zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    use:"*darwin*amd64*", \
    rename-to:fzf

zplug "junegunn/fzf", \
    use:"shell/*.zsh", \
    on:"junegunn/fzf-bin"

zplug "junegunn/fzf", \
    as:command, \
    use:bin/fzf-tmux, \
    on:"junegunn/fzf-bin"

if zplug check "junegunn/fzf"; then
  export FZF_COMPLETION_TRIGGER='**'
  fzf-direct-completion() {
    FZF_COMPLETION_TRIGGER='' fzf-completion
  }
  zle -N fzf-direct-completion
  bindkey -a ';'  fzf-direct-completion
  zplug "~/.zsh/fzf", from:local
fi

zplug "vkravets/anyframe", on:"junegunn/fzf-bin"
#zplug "~/.zsh/anyframe", from:local, on:"junegunn/fzf-bin"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load 

if zplug check "vkravets/anyframe"; then
#if zplug check "~/.zsh/anyframe"; then
  bindkey '^T' fzf-file-widget	
  #bindkey '^[c' fzf-cd-widget
  #bindkey '^R' fzf-history-widget

  zstyle ":anyframe:selector:" use fzf
  zstyle ":anyframe:selector:fzf:" command 'fzf --cycle --height=30% --tabstop=4 --color=dark --history-size=10000 --extended'

  bindkey '^\' anyframe-widget-cdr
  bindkey '^R' anyframe-widget-execute-history
  bindkey '^P' anyframe-widget-put-history
  bindkey '^G' anyframe-widget-checkout-git-branch
  bindkey '^F' anyframe-widget-git-add
  bindkey '^K' anyframe-widget-kill
  bindkey '^B' anyframe-widget-insert-git-branch
fi

if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  function zle-keymap-select zle-line-init
  {
      # change cursor shape in iTerm2
      case $KEYMAP in
          vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
          viins|main) print -n -- "\E]50;CursorShape=2\C-G";;  # line cursor
      esac
  
      zle reset-prompt
      zle -R
  }

  function zle-line-finish
  {
      print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
  }

  zle -N zle-line-init
  zle -N zle-line-finish
  zle -N zle-keymap-select
fi
