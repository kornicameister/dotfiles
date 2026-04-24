# Global Instructions

## Git Worktrees

- When comparing branches (e.g. synth output, file diffs), use `git worktree add /tmp/<name> <branch>` instead of stashing/checking out
- Always clean up worktrees after use with `git worktree remove /tmp/<name>`
- This avoids disrupting the current working tree and is safe for concurrent operations

## Commit Convention

Always use FULL Conventional Commits (with scope) in every project.

Format: `<type>(<scope>): <description>`

Types: feat, fix, refactor, chore, docs, style, perf, test, ci, build

- Type is REQUIRED
- Scope is REQUIRED (full conventional commits)
- Description is REQUIRED, lowercase, no period at end
- Breaking changes: use `!` after type/scope or `BREAKING CHANGE:` footer

## AWS Lambda Powertools Logger (Python)

### Reserved keys in extra/kwargs
Python's LogRecord has reserved keys that CANNOT be used in `extra={}` or as direct kwargs:
- `message` — WILL throw `KeyError: "Attempt to overwrite 'message' in LogRecord"`
- Other reserved: `name`, `msg`, `args`, `levelname`, `levelno`, `pathname`, `filename`, `module`, `exc_info`, `exc_text`, `stack_info`, `lineno`, `funcName`, `created`, `msecs`, `relativeCreated`, `thread`, `threadName`, `processName`, `process`

If you need to log a field called `message`, rename it (e.g. `result_message`, `response_message`).

### Flattening nested dicts into extra
- ALWAYS check for reserved key collisions before flattening
- Safer to keep nested: `extra={"result": {...}}` if the inner dict might contain `message` or other reserved keys

### Structured logging patterns
```python
logger.info("Order processed", extra={"order_id": "123"})  # via extra dict
logger.info("Order processed", order_id="123")              # via direct kwargs
```
Both produce identical JSON output. Pick one style per project for consistency.

### Child loggers
Use `Logger(child=True)` in submodules — inherits service name, log level, and config from root `Logger()`.
