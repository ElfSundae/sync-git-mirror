#!/bin/bash
set -euo pipefail

if [[ $# < 1 ]]; then
    echo "Usage: $(basename "$0") source [<repo-name>]"
    exit 1
fi

fullpath()
{
    pushd "$1" > /dev/null
    fullpath=$(pwd -P)
    popd > /dev/null
    echo "$fullpath"
}

if [[ -d "$1" ]]; then
    SOURCE="$(fullpath "$1")"
else
    SOURCE="$1"
fi
REPO_NAME=${2:-$(basename $SOURCE .git)}

# Mirror repo URL for the repo name
MIRROR="git@github.com:ElfSundae/$REPO_NAME.git"
# The default local path to clone the source repo
REPO_PATH="/data/mirrors/$REPO_NAME"

sync-git-mirror.sh "$SOURCE" "$MIRROR" --path="$REPO_PATH"
