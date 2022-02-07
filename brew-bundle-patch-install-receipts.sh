#!/usr/bin/env bash

BREWFILE="${1:-Brewfile}"

find /usr/local/Cellar -name INSTALL_RECEIPT.json | (
    while read -r INSTALL_RECEIPT; do
        FORMULA=$(echo "$INSTALL_RECEIPT" | cut -d '/' -f 5)
        if grep -q -e "^brew \"$FORMULA\"$" \
                    -e "^brew \".*/$FORMULA\"$" \
                    -e "^brew \"$FORMULA\", restart_service: true$" \
                    <"$BREWFILE" ; then
            IN_BREWFILE="true"
        else
            IN_BREWFILE="false"
        fi
        INSTALLED_ON_REQUEST=$(jq '.installed_on_request' <"$INSTALL_RECEIPT")
        INSTALLED_AS_DEPENDENCY=$(jq '.installed_as_dependency' <"$INSTALL_RECEIPT")
        if [ "$IN_BREWFILE" != "$INSTALLED_ON_REQUEST" ]; then
            echo "$FORMULA" installed_on_request="$INSTALLED_ON_REQUEST" installed_as_dependency="$INSTALLED_AS_DEPENDENCY" in_brewfile="$IN_BREWFILE"
            PATCHED_INSTALL_RECEIPT=$(jq --compact-output --argjson IN_BREWFILE "$IN_BREWFILE" '.installed_on_request = $IN_BREWFILE' "$INSTALL_RECEIPT")
            echo "$PATCHED_INSTALL_RECEIPT" >"$INSTALL_RECEIPT"
            INSTALLED_ON_REQUEST="$IN_BREWFILE"
        fi
        if [ "$INSTALLED_ON_REQUEST" = "false" ] && [ "$INSTALLED_AS_DEPENDENCY" = "false" ]
        then
            echo "$FORMULA" installed_on_request="$INSTALLED_ON_REQUEST" installed_as_dependency="$INSTALLED_AS_DEPENDENCY" in_brewfile="$IN_BREWFILE"
            PATCHED_INSTALL_RECEIPT=$(jq --compact-output '.installed_as_dependency = true' "$INSTALL_RECEIPT")
            echo "$PATCHED_INSTALL_RECEIPT" >"$INSTALL_RECEIPT"
            INSTALLED_AS_DEPENDENCY="true"
        fi
    done
)
