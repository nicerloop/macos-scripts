#!/bin/sh
tap=${1:?missing tap argument}
command -v jq >/dev/null
clear
(
    TAP_INFO=$(brew tap-info "$tap" --json)
    brew style --fix --formula $(echo "$TAP_INFO" | jq -r '.[]|(.formula_names[])')
    brew style --fix --cask $(echo "$TAP_INFO" | jq -r '.[]|(.cask_tokens[])')
    brew audit --strict --formula $(echo "$TAP_INFO" | jq -r '.[]|(.formula_names[])')
    brew audit --strict --cask $(echo "$TAP_INFO" | jq -r '.[]|(.cask_tokens[])')
)
