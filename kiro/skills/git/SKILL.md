---
name: git-worktree
description: Git branch comparison and diff workflows using worktrees. Use when comparing branches, diffing synth output, or working with multiple branches simultaneously.
---

## Rules

- When comparing branches (e.g. synth output, file diffs), use `git worktree add /tmp/<name> <branch>` instead of stashing/checking out
- Always clean up worktrees after use with `git worktree remove /tmp/<name>`
- This avoids disrupting the current working tree and is safe for concurrent operations
