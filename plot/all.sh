#!/bin/bash
set -e

# Get the manifest for the current project
manifest=$(cargo locate-project --message-format plain)
printf '    \033[1;34mManifest\033[0m %s\n' $manifest

# Get available binaries for the current project only
bins=$(
    cargo metadata --format-version 1 |
    jq -r --arg manifest $manifest '
        .packages[]
        | select(.manifest_path == $manifest)
        | .targets[]
        | select(.kind[] | contains("bin"))
        | .name
    '
)

for bin in $bins; do
    printf '     \033[1;34mRunning\033[0m %s\n' $bin
    cargo run --bin $bin
done
