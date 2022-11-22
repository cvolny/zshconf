# util
function realpath() { python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$0"; }

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

function git-files-changed-since() {
    local diffhash="${1?missing since hash argument #1}"

    git diff --name-only ${diffhash} HEAD
}

function git-tests-report-since() {
    local diffhash="${1?missing since hash argument #1}"
    local flavor="${2?missing flavor argument #2}"
    local subcommand

    for tfile in $( git-files-changed-since ${diffhash} | grep '/test_' ); do
        if [[ "${tfile}" == */itest* ]]; then
            subcommand="itest"
        else
            subcommand="utest"
        fi
        printf '`ddi %s %s %s`\n' $subcommand $flavor $tfile

    done
}

# utility
alias ls="ls -FG"
alias ll="ls -FGl"
alias lrt="ls -FGlrt"
alias grep="grep --color=always"
alias grepr="grep --color=always -rns"
alias greprc="grep --color -rns -C 5"
alias zshrc="nano ~/.zshrc && source ~/.zshrc"
alias history="builtin history 1 | less +G"
alias testrp="(cd $HOME/src/sso-junkcode/cvolny/oidc; ./run-demo.sh)"
