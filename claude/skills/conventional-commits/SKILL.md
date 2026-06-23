---
name: conventional-commits
model: claude-haiku-4-5-20251001
description: Commit message convention. ALWAYS invoke before creating any git commit or writing a commit message. Never format a commit without this skill loaded.
---

# Conventional Commits

## Overview

SOP for formatting git commit messages. You MUST invoke this before writing any commit message — MUST NOT format commits from memory.

## Parameters

- **changes** (required): What changed and why
- **scope** (required): Component affected (e.g. `auth`, `api`, `mcp-server`, `iac`, `lambda`)

## Steps

### 1. Select Type and Scope

Identify the change type and the component it affects.

**Constraints:**
- You MUST select exactly one type: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `perf`, `test`, `ci`, `build`
- You MUST include a scope — full conventional commits require scope in this project
- You MUST NOT omit the scope

### 2. Write the Commit Message

**Format:** `<type>(<scope>): <description>`

**Constraints:**
- You MUST write the description in lowercase
- You MUST NOT end the description with a period
- You SHOULD focus the description on the "why", not the "what"
- For breaking changes, you MUST append `!` after type/scope: `feat(auth)!: remove legacy token format`
- You MAY add a `BREAKING CHANGE: <detail>` footer for additional context on breaking changes

## Examples

```
feat(mcp-server): add cost anomaly detection tool
fix(lambda): handle missing STAGE env var on cold start
refactor(iac): extract reusable role construct for cross-account access
test(cost-explorer): add e2e coverage for multi-account rollup
chore(deps): bump fastmcp to 2.1.0
feat(auth)!: replace session tokens with short-lived JWTs
```
