# trustedpath
export TRUSTEDPATH="$HOME/src/trustedpath"
export OPSDIR="$HOME/src/ops"
export PATH="$PATH:$TRUSTEDPATH/ddi:$HOME/bin"
alias tp='cd "$TRUSTEDPATH"'
alias ops='cd "$OPSDIR"'
alias arc='duoconnect -arc -relay phab.duosec.org arc'

# ddi-autocomplete
autoload -U bashcompinit
bashcompinit
eval "$( ddi-argcomplete-register )"
alias ddi='nocorrect ddi'

# ddi helpers
DDI_FLAVORS=( devmaindb cloudsso admin main audit )
function cdtp() {
    local oldpwd=$( realpath $( pwd ) )
    if [[ "${oldpwd}" != $( realpath $TRUSTEDPATH ) ]]; then
        echo ${oldpwd}
        builtin cd $TRUSTEDPATH
    fi
    return 1
}

function ddi-start-all() {
    : <<-DOC
	ddi-start all flavor arguments (\$DDI_FLAVORS[@]), in order
	( ${DDI_FLAVORS[@]} )
	DOC
    local flavors=( ${@:-${DDI_FLAVORS[@]}} )
    local flavor
    for flavor in ${flavors[@]}; do
        ( cdtp > /dev/null
            ddi start "${flavor}" 2>&1 \
            | prefix "${flavor}" )
    done
}

function ddi-refresh-all() {
    : <<-DOC
	ddi-refresh-f all flavors arguments (\$DDI_FLAVORS[@], in order
	( ${DDI_FLAVORS[@]} )
	DOC
    local flavors=( ${1:-${DDI_FLAVORS[@]}} )
    local flavor
    for flavor in ${flavors[@]}; do
        ( cdtp > /dev/null
            ddi refresh -f "${flavor}" 2>&1 \
            | prefix "${flavor}" ) \
        || { echo "Failed on $flavor."
            return 1
        }
    done
}
