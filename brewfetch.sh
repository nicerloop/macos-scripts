#!/bin/sh
clear
brew developer off &&
    LC_ALL=en_US.UTF8 git -C "$(brew --repository)" checkout stable &&
    brew update &&
    brew outdated --greedy &&
    (brew outdated --formula | xargs -n 1 brew fetch --formula) &&
    (brew outdated --cask --greedy | xargs -n 1 brew fetch --cask)
