# Sync Git Mirror

[`sync-git-mirror.sh`](sync-git-mirror.sh) syncs a git repository to a mirror or fork repository, including all branches and tags. Keep your git mirrors and forks up to date.

```console
$ sync-git-mirror.sh
Sync Git Mirror - Keep your git mirrors and forks up to date.
https://github.com/ElfSundae/sync-git-mirror

Usage: sync-git-mirror.sh source mirror [<options>]

`source` can be a remote URL or a local path of working copy
`mirror` should be a remote URL

Options:
        --path=           Path to clone
        --mirror-name=    Git remote name of mirror, default is "mirror"
        -h|--help         Show this usage

Examples:
    sync-git-mirror.sh https://github.com/foo/bar git@github.com:username/bar.git
    sync-git-mirror.sh /path/to/working/copy git@github.com:username/name.git
    sync-git-mirror.sh https://github.com/foo/bar.git git@github.com:username/bar.git \
        --path=/data/mirrors/bar
```
