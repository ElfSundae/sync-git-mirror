# Sync Git Mirror

This script syncs a git repository to a mirror/fork repository, including all branches and tags. Keep your git mirrors and forks up to date.

```
$ sync-git-mirror.sh
Sync Git Mirror - Keep your git mirrors and forks up to date.

Usage: sync-git-mirror.sh [options] source mirror

`source` can be a git URL or a local path
`mirror` should be a git URL

Options:
        --path=           Path to clone
        --mirror-name=    Git remote name of mirror, default is "mirror"
        -h|--help         Show this usage

Examples:
    sync-git-mirror.sh https://github.com/foo/bar.git git@github.com:username/bar.git
    sync-git-mirror.sh /data/mirrors/bar git@github.com:username/bar.git
    sync-git-mirror.sh https://github.com/foo/bar.git git@github.com:username/bar.git \
        --path=/data/mirrors/bar
```
