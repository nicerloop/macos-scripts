#!/bin/sh

# curl "https://apps.apple.com/app/broadcasts/id$1" |
#     tr -d '\n' |
#     sed -e's:.*<script type="fastboot/shoebox" id="shoebox-media-api-cache-apps">::' -e's:</script>.*::' |
#     jq '
#         to_entries |
#         .[0].value |
#         fromjson |
#         .d[0].attributes.platformAttributes |
#         to_entries[] |
#         { platform: .key , version : .value.versionHistory[0].versionDisplay }
#     '

MAS_ID="$1"
MAS_HTML=$(
    curl "https://apps.apple.com/app/broadcasts/id$MAS_ID"
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
MAS_VERSIONS=$(
    printf '%s' "$MAS_JSON" |
        jq '
        .d[0].attributes.platformAttributes |
        to_entries[] |
        { platform: .key , version : .value.versionHistory[0].versionDisplay }
    '
)
# MAS_VERSIONS=$(
# )
printf '%s' "$MAS_VERSIONS"
