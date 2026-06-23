# Global Instructions

## Skills — Proactive Usage

You MUST check available skills before responding. If a skill covers the topic, you MUST invoke it — never answer from memory when a skill exists for that domain.

**Constraints:**
- You MUST invoke `conventional-commits` before writing any git commit message — you MUST NOT format a commit from memory
- You MUST invoke `python` before writing or reviewing any Python code
- You MUST invoke `tdd` before writing any test or setting up pytest fixtures
- You MUST invoke `bdd` before writing any Gherkin scenario or pytest-bdd step definition
- You MUST invoke `ddd` before implementing any aggregate, entity, value object, or repository
- You MUST invoke `awsume` before running any awsume command or managing AWS credentials
- You MUST invoke `git-worktree` when comparing branches — you MUST NOT stash or checkout to compare
- You MUST invoke `powertools-logger` before using AWS Lambda Powertools Logger — reserved key collisions cause runtime KeyErrors
- You MUST invoke `find-docs` when asked about any library, framework, SDK, or AWS service API
