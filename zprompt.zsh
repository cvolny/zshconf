# Prompt config
# Enable substitution in the prompt.
setopt prompt_subst
# Enable color in the prompt
autoload -U colors
colors
# Config for prompt. PS1 synonym.
function git_prompt_status()
{
    : <<-DOC
	colorized (PROMPT_COLOR_GIT_{CLEAN,DIRTY,STAGE} branch name.
	Note: uses git-diff-index tf new files aren't reported, git-add them
	DOC
    local branch=$( git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}' )
    local color="${PROMPT_COLOR_GIT_CLEAN}"
    if [[ -n "${branch}" ]]; then
        if ! git diff-index --cached --quiet HEAD -- 2> /dev/null; then
            color="$PROMPT_COLOR_GIT_STAGE"
        elif ! git diff-index --quiet HEAD -- 2> /dev/null; then
            color="$PROMPT_COLOR_GIT_DIRTY"
        fi
        echo " - (%{$color%}${branch}%{$reset_color%})"
    fi
}
PROMPT_REDRAW=T
PROMPT_COLOR_DIR="$fg[cyan]"
PROMPT_COLOR_RET="$fg[yellow]"
PROMPT_COLOR_GIT_CLEAN="$fg[white]"
PROMPT_COLOR_GIT_DIRTY="$fg[red]"
PROMPT_COLOR_GIT_STAGE="$fg[green]"
PROMPT='%{$PROMPT_COLOR_DIR%}%2/%{$reset_color%}$( git_prompt_status )%(?.. %{$PROMPT_COLOR_RET%}[%?]%{$reset_color%}) %# '
RPROMPT='# !%h $( date +%H:%m:%S )'
TMOUT=5
TRAPALRM() {
    if [[ -n "${PROMPT_REDRAW}" ]]; then
        zle reset-prompt
    fi
}
