export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export COMPOSE_HTTP_TIMEOUT=300
export PATH="/usr/local/opt/curl/bin:$PATH"

source ~/dotfiles/git-completion.bash
source ~/dotfiles/hub.bash_completion.sh
source ~/dotfiles/bash_aliases

if [ -f ~/dotfiles/.sage_aliases ]; then
  . ~/dotfiles/.sage_aliases
fi

if [ -f ~/.sage_profile ]; then
  . ~/.sage_profile
fi

function github {
  branch="$(git rev-parse --abbrev-ref HEAD)"
    url="$(git config --get remote.origin.url)"
    url=${url/git@github.com:/http://github.com/}
  url=${url/.git/}

  if [[ $1 =~ "compare" ]]; then action="compare"
    elif [[ $1 =~ "pr" ]]; then action="pull"
  else action="tree"; fi

    if [[ $2 != "" ]]; then base="$2..."
    else base=""; fi

      url="${url}/${action}/${base}${branch}"

        echo "Opening ${url} $(\open ${url})"
}

#------------------------------------------------------
# CUSTOM COMMAND PROMPT
#------------------------------------------------------

# COLOUR VARIABLES ------------------------------------
FG_YELLOW='\[\033[0;33m\]'
NO_COLOUR='\[\033[0m\]'

IRed='\[\033[0;91m\]'
IGreen='\[\033[0;92m\]'
IBlue='\[\033[0;94m\]'
ICyan='\[\033[0;96m\]'
IWhite='\[\033[0;97m\]'

PS1_TIME='\[\033[1;97m\033[1;97m\]'
PS1_PATH='\[\033[0;38;5;12m\]'
PS1_MARKER='\[\033[0;34m\]'

function check_user {
  # if user is not root
  if [[ $EUID -ne 0 ]]; then
    PS1_TIME="$NO_COLOUR\033[38;5;250m\] \$(date +%H:%M) "
    PS1_PATH="\[\033[0;38;5;222m\]"
    PS1_MARKER="$FG_YELLOW\$$NO_COLOUR "
  else
    PS1_TIME="\[\033[48;5;160m\033[38;5;255m\] \$(date +%H:%M) \[\033[48;5;88m\033[38;5;17m\] \$(id -nu) "
    PS1_PATH="\[\033[0;38;5;165m\]"
    PS1_MARKER="$FG_YELLOW#$NO_COLOUR "
  fi
}

# Set the title of gnome terminal
function title {
  echo -ne "\033]0;$*\007"
}

# Return the name of the root directory for the current repo
function repo_root {
  d=`pwd`
  while [ "$d" != "" ]; do
    [ -d "$d"/.git ] && echo ${d##*/}
    d=${d%/*}
  done
}

# Check branch status
function get_branch_status {
  if [[ $(git status | tail -n1) == "nothing to commit, working tree clean" ]]; then
    echo -e "$IGreen\[\e[1m\] - \[\e[0m\]"
  elif [[ $(git status | tail -n1) == "nothing to commit, working directory clean" ]]; then
    echo -e "$IGreen\[\e[1m\] - \[\e[0m\]"
  elif [[ $(git status | tail -n1) == "nothing to commit (working tree clean)" ]]; then
    echo -e "$IGreen\[\e[1m\] - \[\e[0m\]"
  elif [[ $(git status | tail -n1) == "nothing to commit (working directory clean)" ]]; then
    echo -e "$IGreen\[\e[1m\] - \[\e[0m\]"
  else
    echo -e "$IRed\[\e[1m\] - \[\e[0m\]"
  fi
}

# Set the prompt according to which repo the current dir is in - if any
function set_prompt {
  # Set the default prompt
  PS1="$PS1_PATH\w$PS1_MARKER"

  # ADD GIT LABELS
  # If git status errors then we are not in a git repo
  # or we do not have git installed so leave prompt as default
  if [[ -z $(git status 2> /dev/null) ]]; then
    return
  fi

  # set repo name to the root dir name
  repo_name=$(repo_root)

  # find the origin file name of remote repo
  remote_repo_file=$(git remote -v | grep origin | tail -1 | cut -f2 -d":" | cut -f1 -d" ")

  # If there is a remote origin use file name to get repo name
  if [[ -n $remote_repo_file ]]; then
    repo_name=$IBlue$(basename $remote_repo_file) | cut -f1 -d"."
  fi

  # set the title of the terminal to the current repo name
  term_title=(${repo_name//_/ })
  echo -ne "\033]0;${term_title[@]^}\007"

  branch_status=$(get_branch_status)$IBlue

  current_branch=$IWhite$(git branch --no-color | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")

  current_path=$IBlue${PWD##*Development/}

  date_time=$(date +$ICyan%H$IWhite:$ICyan%M$IWhite:$ICyan%S$IWhite)

  # Prompt
  PS1="$current_branch$branch_status$current_path\n$date_time "
}

# Chief function to call all / any custom functions
function prompt_command {
	check_user
  set_prompt
}

# Initialisation commands
PROMPT_COMMAND=prompt_command
