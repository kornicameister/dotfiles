---
name: powertools-logger
model: claude-haiku-4-5-20251001
description: AWS Lambda Powertools Logger gotchas and patterns. ALWAYS invoke when working with Powertools Logger, Lambda logging, or structured logging. Reserved key collisions cause runtime KeyErrors — do not answer from memory.
---

# AWS Lambda Powertools Logger

## Overview

SOP for safe usage of AWS Lambda Powertools Logger. You MUST invoke this before writing any logging code in Lambda — reserved key violations cause runtime `KeyError` crashes that are difficult to debug.

## Reserved Keys — MUST NOT Use

**Constraints:**
- You MUST NOT pass any of these keys to `extra={}` or as direct kwargs — they throw `KeyError` at runtime:
  `message`, `name`, `msg`, `args`, `levelname`, `levelno`, `pathname`, `filename`, `module`,
  `exc_info`, `exc_text`, `stack_info`, `lineno`, `funcName`, `created`, `msecs`,
  `relativeCreated`, `thread`, `threadName`, `processName`, `process`
- If you need to log a field named `message`, you MUST rename it (e.g. `result_message`, `response_message`)

```python
logger.debug("Calling tool", args=args)          # ❌ MUST NOT — KeyError at runtime
logger.debug("Calling tool", tool_args=args)     # ✅ MUST use renamed key
```

## Nested Dicts in extra

**Constraints:**
- You MUST check for reserved key collisions before flattening any nested dict into `extra`
- You SHOULD keep nested dicts intact when they may contain reserved keys

```python
# ❌ Risky if result dict contains "message"
logger.info("Done", **result)

# ✅ Safe — keep nested
logger.info("Done", extra={"result": result})
```

## Structured Logging Patterns

**Constraints:**
- You MUST pick one style per project and be consistent — MUST NOT mix both styles in the same codebase

```python
logger.info("Order processed", extra={"order_id": "123"})  # style A: extra dict
logger.info("Order processed", order_id="123")              # style B: direct kwargs
# Both produce identical JSON output
```

## Child Loggers

**Constraints:**
- You MUST use `Logger(child=True)` in submodules — inherits service name, log level, and config from root `Logger()`
- You MUST NOT create a new root `Logger()` in submodules — it creates a separate logger with no shared config
