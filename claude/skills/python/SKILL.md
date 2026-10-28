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

## Modern Python and Interpreter Compatibility

Use modern language and standard-library features when they make the code clearer.
Check `requires-python`, the lockfile and the actual interpreter before selecting
syntax. For new projects, prefer Python 3.14 when the user and dependency support
permit it; do not silently raise an existing project's minimum version.

- Prefer built-in generic collections (`list[str]`, `dict[str, int]`) and imports
  from `collections.abc` for collection/callable interfaces. Avoid legacy
  `typing.List`, `typing.Dict` and unnecessary compatibility backports.
- On Python 3.12+, use `type Result = Success | Failure` for explicit aliases and
  native type parameters (`class Repository[T]: ...`, `def identity[T](...) -> T`)
  when generics are actually needed; avoid adding a TypeVar-based abstraction
  merely to demonstrate typing.
- Use `Self` for methods returning the implementing class and `@override` for
  overridden methods when supported by the declared interpreter range. Keep
  discriminated unions/exhaustive `match` branches where they express real cases.
- On Python 3.14+, rely on deferred annotations for ordinary forward references;
  do not add `from __future__ import annotations` or quote types by habit. For
  runtime introspection, choose the required `annotationlib.get_annotations`
  format explicitly. Verify framework compatibility before changing existing
  annotation handling; runtime-evaluated class bases and expressions are separate.
- Prefer frozen, keyword-only dataclasses for immutable records when framework
  validation is unnecessary. Domain/value-object requirements from the relevant
  project or DDD skill still apply.
- Adopt features such as template strings, subinterpreters or free threading only
  for a demonstrated requirement and after checking downstream support. Template
  strings require an appropriate consumer; they do not make SQL/shell/HTML safe
  automatically. New syntax is not a reason to add concurrency or dependencies.
- Set the same supported interpreter in package metadata, local tooling and CI;
  run tests, type checks and package builds on that interpreter. A pass on an
  older interpreter does not verify Python 3.14 compatibility.

Verify details against the declared Python version's official documentation:
[Python 3.14 changes](https://docs.python.org/3.14/whatsnew/3.14.html),
[typing](https://docs.python.org/3.14/library/typing.html),
[annotationlib](https://docs.python.org/3.14/library/annotationlib.html),
[dataclasses](https://docs.python.org/3.14/library/dataclasses.html).

## Astral Tooling

For new Python projects, use uv for environment/dependency management, Ruff for
linting and formatting, and ty for type checking. Prefer this stack over adding
Black/isort or mypy to a new project. Preserve an existing project's tool choices
unless migration is requested or needed; check compatibility before replacing a
checker that relies on plugins or project-specific behavior.

- Lock development tools in `uv.lock`. Configure project rules in `pyproject.toml`.
- Use `ruff check` for lint diagnostics, `ruff check --fix` for reviewed automatic
  fixes, `ruff format` for formatting, and `ruff format --check` in CI.
- Run `ty check` against the declared project/interpreter and fix diagnostics;
  do not suppress checks to claim compatibility. Verify current framework support
  against the actual pinned release.
- Set Ruff's `target-version` to the supported Python minimum and keep package,
  type-checker and CI interpreter constraints aligned. Install dependencies before
  study/runtime interaction, not during an answer or application command.

Official references: [uv](https://docs.astral.sh/uv/),
[Ruff](https://docs.astral.sh/ruff/), [ty](https://docs.astral.sh/ty/).
