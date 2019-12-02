# Sync Git Mirror

[`sync-git-mirror.sh`](sync-git-mirror.sh) syncs a git repository to a mirror or fork repository, including all branches and tags. Keep your git mirrors and forks up to date.

```
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

If you have many mirrors to sync, you may like to use [`sync-my-git-mirror.sh`](sync-my-git-mirror.sh) which makes life easier.

**:warning: You need to change the `MIRROR` and `REPO_PATH` variables before using `sync-my-git-mirror.sh`:**

```bash
# Mirror repo URL for the repo name
MIRROR="git@github.com:ElfSundae/$REPO_NAME.git"
# The default local path to clone the source repo
REPO_PATH="/data/mirrors/$REPO_NAME"
```

Examples:

```bash
# Sync the current working repo
sync-my-git-mirror.sh .

# Sync a local repo with different name
sync-my-git-mirror.sh ~/path/to/repo RepoName

# Sync a remote repo, clone to the default path
sync-my-git-mirror.sh git://path/to/repo.git

# Sync a remote repo with different name, clone to the default path
sync-my-git-mirror.sh git://path/to/repo.git RepoName
```
