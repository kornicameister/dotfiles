---
name: conventional-commits
description: Commit message convention. Use when creating commits, writing commit messages, or preparing changes for version control.
---

Always use FULL Conventional Commits (with scope).

Format: `<type>(<scope>): <description>`

Types: feat, fix, refactor, chore, docs, style, perf, test, ci, build

- Type is REQUIRED
- Scope is REQUIRED (full conventional commits)
- Description is REQUIRED, lowercase, no period at end
- Breaking changes: use `!` after type/scope or `BREAKING CHANGE:` footer
