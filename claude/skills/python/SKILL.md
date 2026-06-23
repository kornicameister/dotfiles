---
name: python
model: claude-haiku-4-5-20251001
description: Python coding style and conventions. ALWAYS invoke when writing or reviewing any Python code in this project. Enforces required patterns (keyword-only args, match/case, arg sorting) that are not obvious from training data.
---

# Python Style

## Overview

SOP for Python code style in this project. You MUST invoke this before writing or reviewing any Python code. These conventions are project-specific and differ from general Python defaults.

## Top-Level Constraints

- You MUST use `match`/`case` over `if/elif` chains when branching on a value or structure
- You MUST annotate every function argument with a type hint — MUST NOT leave any parameter unannotated
- You MUST use `str | None` — MUST NOT use `Optional[str]`
- You MUST NOT use single-letter variable names outside of comprehension conventions (`k`, `v`, `i`, `x`)

## Function Arguments

**Constraints:**
- You MUST place each argument on its own line when a function has more than one argument
- You MUST sort arguments from shortest to longest name (applies to both definitions AND call sites)
- You MUST use `*` to enforce keyword-only arguments in source code functions
- You MUST NOT use `*` in test functions — pytest handles arguments by name
- Exception: MUST NOT use `*` when the function signature is dictated by an external framework

```python
# ✅ Source code — keyword-only, sorted by name length
def process_request(
    *,
    id: str,
    name: str,
    payload: dict[str, Any],
    session_id: str,
) -> dict[str, Any]:
    pass

# ✅ Test function — no * needed, sorted by name length
def test_something(
    faker: Faker,
    mocker: MockerFixture,
    lambda_context: LambdaContext,
    api_gateway_event: dict[str, Any],
) -> None:
    pass

# ✅ Call site — kwargs sorted by name length
process_request(
    id=record_id,
    name=service_name,
    payload=event_data,
    session_id=current_session,
)
```

## Pattern Matching

**Constraints:**
- You MUST prefer `match`/`case` over `if/elif` chains — MUST NOT write `if/elif` chains when `match` applies

```python
# ✅ MUST use
match status:
    case 200:
        return "ok"
    case 404:
        return "not found"
    case _:
        return "error"

# ❌ MUST NOT use when match applies
if status == 200:
    return "ok"
elif status == 404:
    return "not found"
```

## Docstrings and Comments

**Constraints:**
- You MUST use Google-style docstrings for public classes and functions
- You MUST NOT add docstrings to test functions — tests should be self-explanatory
- You MUST NOT add module-level docstrings
- You SHOULD NOT add comments — prefer descriptive naming over comments
- You MAY add a comment only when the WHY is non-obvious (hidden constraint, workaround, subtle invariant)

## Side Effects

**Constraints:**
- You MUST NOT read `os.environ` inside functions — extract at module level or pass as parameter
- You SHOULD use a valid default (`"dev"`, `"staging"`, `"prod"`) or raise `ValueError` when env var is required

```python
# ❌ Side effect inside function
def send_message(message: str) -> str:
    stage = os.environ.get("STAGE")  # MUST NOT

# ✅ Extract at module level
STAGE = os.environ.get("STAGE", "dev")

def send_message(message: str, *, stage: str) -> str:
    ...
```
