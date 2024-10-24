#!/bin/sh
clear
brew developer off &&
    LC_ALL=en_US.UTF8 git -C "$(brew --repository)" checkout stable &&
    brew update &&
    brew outdated --greedy &&
    brew upgrade --greedy &&
    brew autoremove &&
    brew cleanup -s &&
    brew bundle &&
    brew bundle cleanup --verbose
launchpad-reset
sleep 3
launchpad-sort
