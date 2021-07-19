# util
function realpath() { python -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$0"; }

function askme() {
    : <<-DOC
	prompt for confirmation before running a command, usage:
		askme "rebase on remote?" && git pull --rebae
	DOC
    local answer
    echo -n "${@} [y/N]: "
    read answer
    if [[ "${answer:l}" != y* ]]; then
        return 1
    fi
}

function help() {
    local arg
    for arg; do
        if typeset -f $arg 2>&1 > /dev/null; then
            typeset -f $arg | pcregrep --color -M '\<\<DOC(\n.*)+DOC|$'
        else
            declare -p $arg
        fi
    done
}

function prefix() {
    : <<-DOC
	prefix lines of stdin with "$@:\t"
	DOC
    local prefix="$@"
    local tab=$'\t'
    sed "s/^/${prefix}:${tab}/"
}

function start-my-day() {
    : <<-DOC
	start my day login routine asking confirmation:
	1. duo-ssh-add
	2. ddi-start-all \$DDI_FLAVORS
	3. cd \$TRUSTEDPATH
	4. capture current branch
	5. if not master, checkout master
	6. rebase against remote master
	7. ddi-pull
	8. ddi-refresh-all
	DOC
    local branch
    local remote
    local oldpwd=$( cdtp )
    duo-ssh-add
    if ! docker ps -q 2> /dev/null; then
        open --background -a Docker
        echo -n "Starting docker: "
        while ! docker ps -q 2> /dev/null; do
            echo -n "..."
            sleep 3
        done
        echo " Done."
    fi
    ddi-start-all 2>&1 > /dev/null
    branch=$( git branch | awk '{ print $NF }' )
    if [[ "${branch}" != "master" ]]; then
        echo "Not on master branch, exit now." >&2
        ddi status
        return 1
    fi
    remote=$( git remote )
    askme "rebase against ${remote}?" && git pull --rebase $remote master
    ddi pull | prefix "ddi-pull"
    askme "ddi-refresh-all?" && ddi-refresh-all
    ddi status
    if [[ -n "${oldpwd}" ]]; then
        builtin cd "${oldpwd}"
    fi
}

# utility
alias ls="ls -FG"
alias ll="ls -FGl"
alias lrt="ls -FGlrt"
alias grep="grep --color"
alias grepr="grep --color -rns"
alias greprc="grep --color -rns -C 5"
alias zshrc="nano ~/.zshrc && source ~/.zshrc"
alias history="builtin history 1 | less +G"
