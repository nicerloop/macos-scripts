#!/bin/sh

while test $# -gt 0
do

MAS_ID="$1"
shift
MAS_HTML=$(
    curl -sL "https://apps.apple.com/app/id$MAS_ID"
)
MAS_SCRIPT=$(
    printf '%s' "$MAS_HTML" |
        tr -d '\n' |
        sed -e's:.*<script type="fastboot/shoebox" id="shoebox-media-api-cache-apps">::' -e's:</script>.*::'
)
MAS_JSON=$(
    printf '%s' "$MAS_SCRIPT" |
        jq '
        to_entries |
        .[0].value |
        fromjson
    '
)
MAS_NAME=$(
    printf '%s' "$MAS_JSON" |
        jq -r '
        .d[0].attributes.name
    '
)
MAS_VERSIONS=$(
    printf '%s' "$MAS_JSON" |
        jq '
        .d[0].attributes.platformAttributes |
        to_entries[] |
        { platform: .key , version : .value.versionHistory[0].versionDisplay }
    '
)
printf '%s' "$MAS_VERSIONS" |
    jq -r "
    . |
    ( \"$MAS_ID : $MAS_NAME : \" + .platform + \" : \" + .version)
"

done
