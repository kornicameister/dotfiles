---
name: awsume
description: AWS credential management with awsume. Use when assuming AWS roles, listing accounts, switching AWS profiles, or working with AWS credentials.
---

## Usage

- `awsume <profile>` — assume a profile
- `awsume -l` — list all profiles (names, types, regions, account IDs)
- `awsume -l more` — list with extra details (slower, calls STS)
- `awsume -u` — unset current AWS env vars
- `awsume -r <profile>` — force refresh credentials
- `awsume -s <profile>` — show export commands for another shell session
- `awsume --role-arn <account_id>:<role_name>` — assume role by ARN (supports role-chaining)
- `awsume --region <region> <profile>` — override region

## Fish shell integration

Use `fish -c` to run awsume in fish context:
```
fish -c 'awsume <profile>; and <command>'
```

## Key flags

- `--auto-refresh` / `-a` — auto refresh credentials in background
- `--kill-refresher` / `-k` — stop auto-refresh (with profile or all)
- `--source-profile` — specify source profile for role-arn assume
- `--external-id` — pass external ID for cross-account roles
- `--mfa-token` — supply MFA token non-interactively
- `--session-name` — custom role session name
