---
name: awsume
model: claude-haiku-4-5-20251001
description: AWS credential management with awsume. ALWAYS invoke when assuming AWS roles, listing accounts, switching profiles, or running any awsume command. Do not guess flags from memory.
---

# Awsume

## Overview

SOP for AWS credential management with awsume. You MUST invoke this before running any awsume command or managing AWS credentials — MUST NOT guess flags or syntax from memory.

## Parameters

- **profile** (required): The awsume profile name to assume
- **command** (optional): The AWS CLI command to run after assuming credentials

## Steps

### 1. Select the Profile

**Constraints:**
- You MUST run `awsume -l` to list available profiles if the target profile is unknown
- You MUST use `awsume -l more` for extended details including account IDs (slower, calls STS)

### 2. Assume Credentials

**Constraints:**
- You MUST wrap awsume in `fish -c` when running in a fish shell context
- You MUST verify credentials after assuming with `aws sts get-caller-identity`
- You SHOULD chain commands with `; and` in fish shell

```fish
# Assume profile and verify
fish -c 'awsume <profile>; and aws sts get-caller-identity'

# Assume and run a command
fish -c 'awsume <profile>; and <aws-command>'
```

### 3. Common Operations

```fish
awsume -l              # list all profiles
awsume -l more         # list with account IDs (calls STS, slower)
awsume -u              # unset current AWS env vars
awsume -r <profile>    # force refresh credentials
awsume -s <profile>    # show export commands for another shell session
```

## Key Flags

| Flag | Purpose |
|------|---------|
| `--role-arn <account_id>:<role_name>` | Assume role by ARN (supports role-chaining) |
| `--region <region> <profile>` | Override region |
| `--auto-refresh` / `-a` | Auto-refresh credentials in background |
| `--kill-refresher` / `-k` | Stop auto-refresh |
| `--source-profile` | Specify source profile for role-arn assume |
| `--external-id` | Pass external ID for cross-account roles |
| `--mfa-token` | Supply MFA token non-interactively |
| `--session-name` | Custom role session name |
