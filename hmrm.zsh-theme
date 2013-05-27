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

function no_color_my_git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return
    
    INDEX=$(git status --porcelain 2> /dev/null)
    NOCOLORSTATUS=""

    # is branch ahead?
    if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything staged?
    if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unstaged?
    if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything untracked?
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        NOCOLORSTATUS="$NOCOLORSTATUS*"
    fi

    # is anything unmerged?
    if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
        NOCOLORSTATUS="$NOCOLORSTATUS*"
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

function get_poem_line() {
    python ~/.oh-my-zsh/custom/getpoem.py false $HOST $(git_prompt_short_sha)
}

function peek_poem_line() {
    python ~/.oh-my-zsh/custom/getpoem.py true $HOST $(git_prompt_short_sha)
}

#from af-magic
eval my_gray='$FG[237]'
eval my_light_gray='$FG[244]'
eval my_orange='$FG[214]'
eval my_cyan='$FG[032]'
eval my_lavender='$FG[105]'
eval my_blue='$FG[075]'

function no_color_prompt() {
    echo ${(%):-%n at %m in %~$(no_color_my_git_prompt)}
}

PROMPT='$my_gray$(printf "%$(($COLUMNS / 2))s" | tr " " -)%{$reset_color%}$(printf "%$(($COLUMNS - $(($COLUMNS / 2)) - ${#$(peek_poem_line)} - 1))s")$my_light_gray$(get_poem_line)
%{$fg[blue]%}%n$my_gray at %{$fg[blue]%}%m%{$reset_color%}$my_gray in %{$fg[blue]%}%~$(my_git_prompt)%{$reset_color%}$(printf "%$(($COLUMNS - ${#$(no_color_prompt)} - ${#$(peek_poem_line)} - 1))s")$my_light_gray$(get_poem_line)
>'
RPROMPT='%{$reset_color%}$my_light_gray${$(get_poem_line)}'

ZSH_THEME_GIT_PROMPT_PREFIX=" $my_gray‹ %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="$my_orange↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $my_gray›%{$reset_color%}"
