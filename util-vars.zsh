# use homebrew managed nano
alias nano="/usr/local/bin/nano"

alias git-log='git log --pretty=format:'\''%C(yellow)%h %C(blue)%ch %x09%C(cyan)%an %x09%C(reset)%s %C(green)%d%C(reset)'\'
alias git-rebase='git pull --rebase $( git remote ) $( basename $( git symbolic-ref refs/remotes/$( git remote )/HEAD ) )'

EDITOR=/usr/local/bin/nano
PAGER=less
BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
