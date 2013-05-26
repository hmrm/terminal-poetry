function rabbit_hole() {
    if [ $SHLVL = 1 ]
    then
        if [ -z $SSH_CONNECTION ]
        then
            return 0
        fi
    fi
    return 1
}

#from mortalscumbag.zsh-theme
function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
    echo $(current_branch || echo "(no branch)")
}

#POEM_1="`python getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"
#POEM_2="`python getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"
#POEM_3="`python getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"

#from af-magic
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'
eval my_cyan='$FG[032]'
eval my_lavender='$FG[105]'
eval my_blue='$FG[075]'

PROMPT='$my_gray$(printf "%$(($COLUMNS / 2))s" | tr " " -)%{$reset_color%}
%{$fg[blue]%}%n$my_gray at %{$fg[blue]%}%m%{$reset_color%}$my_gray in %{$fg[blue]%}%~$(my_git_prompt)
>'

ZSH_THEME_GIT_PROMPT_PREFIX=" $my_gray‹ %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="$my_orange↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $my_gray›%{$reset_color%}"
