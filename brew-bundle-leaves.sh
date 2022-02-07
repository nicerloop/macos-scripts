#!/usr/bin/env bash

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

LEAVES=$(brew leaves | sort)
BREWFILE="${1:-Brewfile}"
if [ -f "$BREWFILE" ]; then
    FORMULA=$(grep '^brew ' "$BREWFILE" | cut -d ',' -f 1 | cut -d '"' -f 2 | sort)
    # grep -v -f <(echo "$LEAVES") <(echo "$FORMULA")
    comm <(echo "$LEAVES") <(echo "$FORMULA")
else
    echo "$BREWFILE" not found
    exit 1
fi
