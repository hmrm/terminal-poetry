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

funciton no_color_my_git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return
    
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""
    NOCOLORSTATUS=""

    # is branch ahead?
    if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything staged?
    if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unstaged?
    if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything untracked?
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unmerged?
    if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    if [[ -n $STATUS ]]; then
        STATUS=" $STATUS"
    fi

    if [[ -n $NOCOLORSTATUS ]]; then
        NOCOLORSTATUS=" $NOCOLORSTATUS"
    fi

    echo " | $(my_current_branch)$NOCOLORSTATUS |"
}

function my_git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return
    
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""
    NOCOLORSTATUS=""

    # is branch ahead?
    if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything staged?
    if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unstaged?
    if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything untracked?
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unmerged?
    if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
        STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    if [[ -n $STATUS ]]; then
        STATUS=" $STATUS"
        NOCOLORSTATUS=" $NOCOLORSTATUS"
    fi

    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
    echo $(current_branch || echo "(no branch)")
}

POEM_1="`python ~/.oh-my-zsh/custom/getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"
POEM_2="`python ~/.oh-my-zsh/custom/getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"
POEM_3="`python ~/.oh-my-zsh/custom/getpoem.py $HISTCMD $HOST 1 $(git_prompt_short_sha)`"

#from af-magic
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'
eval my_cyan='$FG[032]'
eval my_lavender='$FG[105]'
eval my_blue='$FG[075]'

function no_color_prompt() {
    echo ${(%):-%n at %m in %~$(no_color_my_git_prompt)}
}

PROMPT='$my_gray$(printf "%$(($COLUMNS / 2))s" | tr " " -)%{$reset_color%}$(printf "%$(($COLUMNS - $(($COLUMNS / 2)) - ${#POEM_1} - 1))s")$POEM_1
%{$fg[blue]%}%n$my_gray at %{$fg[blue]%}%m%{$reset_color%}$my_gray in %{$fg[blue]%}%~$(my_git_prompt)%{$reset_color%}$(printf "%$(($COLUMNS - ${#$(no_color_prompt)} - ${#POEM_2} - 1))s")$POEM_2
>'
RPROMPT="%{$reset_color%}$POEM_3"

ZSH_THEME_GIT_PROMPT_PREFIX=" $my_gray‹ %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="$my_orange↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $my_gray›%{$reset_color%}"
