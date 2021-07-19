# git-status or ls on cd
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){
    _prev_cdpwd_git=${_cdpwd_git}
    _cdpwd_git=$( git remote -v 2> /dev/null | awk '{ print $2; exit }' )
    if [[ -n "${_cdpwd_git}" && "${_prev_cdpwd_git}" != "${_cdpwd_git}" ]]; then
        git status
    else
        ls
    fi
}
