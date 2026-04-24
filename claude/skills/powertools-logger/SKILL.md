---
name: powertools-logger
description: AWS Lambda Powertools Logger gotchas and patterns. Use when working with Python logging in Lambda, Powertools Logger, or structured logging.
---

## Reserved keys in extra/kwargs
Python's LogRecord reserved keys CANNOT be used in `extra={}` or as direct kwargs:
- `message` — WILL throw `KeyError: "Attempt to overwrite 'message' in LogRecord"`
- Other reserved: `name`, `msg`, `args`, `levelname`, `levelno`, `pathname`, `filename`, `module`, `exc_info`, `exc_text`, `stack_info`, `lineno`, `funcName`, `created`, `msecs`, `relativeCreated`, `thread`, `threadName`, `processName`, `process`

If you need to log a field called `message`, rename it (e.g. `result_message`, `response_message`).

## Flattening nested dicts into extra
- ALWAYS check for reserved key collisions before flattening
- Safer to keep nested: `extra={"result": {...}}` if the inner dict might contain reserved keys

## Child loggers
Use `Logger(child=True)` in submodules — inherits config from root `Logger()`.
