#!/bin/bash
set -euo pipefail

MIRROR_NAME=mirror

usage()
{
    script=$(basename "$0")
    cat <<EOT
Sync Git Mirror - Keep your git mirrors and forks up to date.
https://github.com/ElfSundae/sync-git-mirror

Usage: $script source mirror [<options>]

\`source\` can be a remote URL or a local path of working copy
\`mirror\` should be a remote URL

Options:
        --path=           Path to clone
        --mirror-name=    Git remote name of mirror, default is "$MIRROR_NAME"
        -h|--help         Show this usage

Examples:
    $script https://github.com/foo/bar git@github.com:username/bar.git
    $script /path/to/working/copy git@github.com:username/name.git
    $script https://github.com/foo/bar.git git@github.com:username/bar.git \\
        --path=/data/mirrors/bar
EOT
}

while [[ $# > 0 ]]; do
    case $1 in
        --path=*)
            REPO_PATH=`echo $1 | sed -e 's/^[^=]*=//g'`
            REPO_PATH=${REPO_PATH%/}
            shift
            ;;
        --mirror-name=*)
            MIRROR_NAME=`echo $1 | sed -e 's/^[^=]*=//g'`
            shift
            ;;
        -h|--help)
            usage
            exit
            ;;
        *)
            if [[ -z ${SOURCE+x} ]]; then
                SOURCE=$1
            elif [[ -z ${MIRROR+x} ]]; then
                MIRROR=$1
            else
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z ${SOURCE+x} || -z ${MIRROR+x} ]] ; then
    usage
    exit 1
fi

echo "==> Syncing $SOURCE to $MIRROR"

if [[ -d $SOURCE ]]; then
    # source is a local working copy
    REPO_PATH=$SOURCE
else
    # source is a git URL
    REPO_PATH=${REPO_PATH:=$(basename $SOURCE .git)}

    if [[ ! -d $REPO_PATH ]]; then
        git clone $SOURCE $REPO_PATH
    fi
fi

cd "$REPO_PATH"

git fetch origin --prune --prune-tags --force

if ! git config remote.$MIRROR_NAME.url > /dev/null; then
    git remote add $MIRROR_NAME $MIRROR
else
    git remote set-url $MIRROR_NAME $MIRROR
fi

# Checkout all remote branches
# https://gist.github.com/ElfSundae/92a5868f418ec3187dfff90fe6b20387
# https://stackoverflow.com/a/6300386/521946
remote=origin ; for brname in `git branch -r | grep $remote | grep -v /master | grep -v /HEAD | awk '{gsub(/^[^\/]+\//,"",$1); print $1}'`; do git branch --track $brname $remote/$brname || true; done 2>/dev/null

git pull origin

git push $MIRROR_NAME --all --prune
git push $MIRROR_NAME --tags --prune
