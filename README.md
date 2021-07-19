# zshconf

zshell configuration for my work mac. Some of this won't work on a non-Duo managed mac.

Prerequisites:
1. `brew install zsh-syntax-highlighting`
2. `brew install fzf`
3. `brew install nano`
4. `brew install iterm2`
5. install nvm (see distro instructions or https://github.com/nvm-sh/nvm)
6. yubikey tooling (`brew install yubico-yubikey-manager`? should come from Duo's chef profile)

Suggested Usage:
1. `cd $HOME; git clone git@github.com:cvolny/zshconf.git .zshconf`
2. `cp $HOME/.zshrc $HOME/.zshrc.bak`
3. `echo 'source "$HOME/.zshconf/zshrc"' > $HOME/.zshrc`
4. edit your copy of $HOME/.zshconf/zshrc to enable/disable parts
5. Bonus: fork this repo and maintain your own configs. If you have something cool to share, submit a PR!

