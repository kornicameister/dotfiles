---
name: git-worktree
model: claude-haiku-4-5-20251001
description: Git branch comparison and diff workflows using worktrees. ALWAYS invoke when comparing branches, diffing synth output, or needing to work with multiple branches simultaneously. Never stash or checkout to compare — use worktrees.
---

# Git Worktrees

## Overview

SOP for branch comparison using git worktrees. You MUST invoke this before comparing branches or working with multiple branches simultaneously — MUST NOT stash or checkout to compare.

## Parameters

- **branch** (required): The branch to compare against or check out in the worktree
- **name** (required): Short identifier for the worktree path (e.g. `compare-main`, `synth-output`)

## Steps

### 1. Create the Worktree

**Constraints:**
- You MUST use `/tmp/<name>` as the worktree path
- You MUST NOT stash or checkout the current working tree to compare branches

```bash
git worktree add /tmp/<name> <branch>
```

### 2. Use the Worktree

**Constraints:**
- You MAY run any read or comparison operation in the worktree path
- You SHOULD use `diff` or file reads on the worktree path instead of switching branches

```bash
# Compare files between current branch and worktree
diff <current-file> /tmp/<name>/<file>

# Diff entire directory
diff -r . /tmp/<name> --exclude=".git"
```

### 3. Clean Up

**Constraints:**
- You MUST remove the worktree after use — MUST NOT leave worktrees behind
- You MUST run cleanup even if an error occurred during the comparison

```bash
git worktree remove /tmp/<name>
```

## Common Workflows

```bash
# Compare CDK synth output between branches
git worktree add /tmp/compare-main main
diff -r cdk.out/ /tmp/compare-main/cdk.out/ --exclude="*.asset.*"
git worktree remove /tmp/compare-main

# Inspect a file on another branch without switching
git worktree add /tmp/feat-branch origin/feat/my-feature
cat /tmp/feat-branch/path/to/file.py
git worktree remove /tmp/feat-branch
```
