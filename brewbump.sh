#!/bin/sh
set -e
tap=${1:?missing tap argument}
command -v jq >/dev/null
clear
(
    HOMEBREW_GITHUB_API_TOKEN=$(echo 'url=https://github.com' | git credential fill | grep password= | cut -d'=' -f 2)
    export HOMEBREW_GITHUB_API_TOKEN
    TAP_INFO=$(brew tap-info "$tap" --json)
    brew bump --full-name --quiet --open-pr $(echo "$TAP_INFO" | jq -r '.[]|(.formula_names[])')
    brew bump --full-name --quiet --open-pr $(echo "$TAP_INFO" | jq -r '.[]|(.cask_tokens[])')
)
