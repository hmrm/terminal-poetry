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

PROMPT1_L='$FG[237]------------------------------------------------------------%{$reset_color%}' #from af-magic.zsh-theme
PROMPT2_L='%{$fg_bold[green]%}%n@%m%{$reset_color%}$(my_git_prompt)'
PROMPT3_L='>'

PROMPT='$FG[237]$(printf "%$(($COLUMNS / 2))s" | tr " " -)%{$reset_color%}
%{$fg_bold[green]%}%n@%m%{$reset_color%}$(my_git_prompt)
>'

#from mortalscumbag.zsh-theme
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg[white]‹ %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $fg_bold[white]›%{$reset_color%}"
