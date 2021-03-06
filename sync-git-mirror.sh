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

# Add --force to force update local existing tags
git fetch origin --prune --prune-tags --force

if ! git config remote.$MIRROR_NAME.url > /dev/null; then
    git remote add $MIRROR_NAME $MIRROR
else
    git remote set-url $MIRROR_NAME $MIRROR
fi

# Note: "negative refspecs" was added since Git 2.29.0: https://github.com/git/git/commit/c0192df6306d4d9ad77f6015a053925b13155834
git push $MIRROR_NAME --prune "+refs/remotes/origin/*:refs/heads/*" ^refs/heads/HEAD "+refs/tags/*:refs/tags/*"
