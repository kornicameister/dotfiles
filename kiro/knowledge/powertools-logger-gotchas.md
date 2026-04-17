# AWS Lambda Powertools Logger (Python) - Lessons Learned

## Reserved keys in extra/kwargs
Python's LogRecord has reserved keys that CANNOT be used in `extra={}` or as direct kwargs:
- `message` — WILL throw `KeyError: "Attempt to overwrite 'message' in LogRecord"`
- Other reserved: `name`, `msg`, `args`, `levelname`, `levelno`, `pathname`, `filename`, `module`, `exc_info`, `exc_text`, `stack_info`, `lineno`, `funcName`, `created`, `msecs`, `relativeCreated`, `thread`, `threadName`, `processName`, `process`

If you need to log a field called `message`, rename it (e.g. `result_message`, `response_message`).

## Flattening nested dicts into extra — watch out!
When converting `logger.debug("msg", result={...})` to `logger.debug("msg", extra={...})`:
- ALWAYS check for reserved key collisions before flattening
- Safer to keep nested: `extra={"result": {...}}` if the inner dict might contain `message` or other reserved keys

## Structured logging patterns
Two equivalent ways to add metadata:
```python
logger.info("Order processed", extra={"order_id": "123"})  # via extra dict
logger.info("Order processed", order_id="123")              # via direct kwargs
```
Both produce identical JSON output. Pick one style per project for consistency.

## Child loggers
Use `Logger(child=True)` in submodules — inherits service name, log level, and config from root `Logger()`.

## Migration from loguru
loguru's `logger.debug("msg", key=value)` maps directly to Powertools kwargs style. Just swap the import.

## Migration from stdlib logging
Replace `from logging import getLogger` + `getLogger("name")` with `from aws_lambda_powertools import Logger` + `Logger(child=True)`. Convert f-string messages to structured kwargs.
