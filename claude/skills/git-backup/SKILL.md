---
name: git-backup
description: Git safety-net via backup branch, not tags. ALWAYS invoke before any destructive/history-rewriting git operation (reset --hard, rebase, filter-branch, orphan/squash, force-push, branch delete) to snapshot current HEAD first. Never use a tag for this — branches are easier to list, prune, and push/delete than tags.
---

# Git Backup

## Overview

SOP for snapshotting the current state of a branch before a destructive or history-rewriting git
operation. You MUST invoke this before `reset --hard`, `rebase`, `filter-branch`, an orphan/squash
history reset, `push --force`, or deleting a branch that isn't fully merged — MUST NOT skip
straight to the destructive command on the assumption reflog is enough.

**Always use a branch for the backup, never a tag.** A tag is easy to leave behind unnoticed and
awkward to clean up in bulk; a branch shows up in `git branch`, sorts naturally, and is a single
`git branch -D` to remove when no longer needed.

## Parameters

- **label** (required): Short slug describing why the backup exists (e.g. `pre-reset`, `pre-rebase`, `pre-squash`)
- **date** (optional): Defaults to today's date (`YYYY-MM-DD`) if not given

## Steps

### 1. Create the Backup Branch

**Constraints:**
- You MUST create the branch from current `HEAD` before running the destructive command
- You MUST NOT use `git tag` for this purpose
- You MUST name it `backup/<label>-<date>`

```bash
git branch backup/<label>-<date> HEAD
```

### 2. Confirm the Backup

**Constraints:**
- You SHOULD print the branch and the commit it points to, so the backup is visible in the transcript before anything destructive runs

```bash
git log --oneline -1 backup/<label>-<date>
```

### 3. Run the Destructive Operation

Proceed with the original destructive command only after step 1 and 2 succeed.

### 4. Tell the User How to Recover

**Constraints:**
- You MUST state the recovery command in the same response, even if unprompted — the user should not have to ask

```bash
# Restore the branch you were on to the backed-up state
git reset --hard backup/<label>-<date>

# Or just look at the old state without touching the current branch
git checkout backup/<label>-<date>
```

### 5. Clean Up Old Backups (periodic, not automatic)

**Constraints:**
- You MUST NOT delete a backup branch yourself unless the user explicitly asks — only they know when it's safe to drop
- You MAY list existing backups for the user to review

```bash
git branch --list 'backup/*'
git branch -D backup/<label>-<date>   # only on explicit user request
```

## Common Workflows

```bash
# Before squashing all history into one commit
git branch backup/pre-reset-2026-08-12 HEAD
git checkout --orphan base
git add -A && git commit -m "chore(repo): reset history to base state"
git branch -f main base
git checkout main && git branch -d base

# Before a force-push
git branch backup/pre-force-push-2026-08-12 HEAD
git push --force origin main

# Before an interactive-adjacent rebase (non-interactive only — see CLAUDE.md git-safety rules)
git branch backup/pre-rebase-2026-08-12 HEAD
git rebase origin/main
```
