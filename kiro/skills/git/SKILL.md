<git>
    - when comparing branches (e.g. synth output, file diffs), use `git worktree add /tmp/<name> <branch>` instead of stashing/checking out
    - always clean up worktrees after use with `git worktree remove /tmp/<name>`
    - this avoids disrupting the current working tree and is safe for concurrent operations
</git>
