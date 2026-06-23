---
name: tdd
description: Test-Driven Development with pytest. ALWAYS invoke when writing tests, implementing TDD, using pytest fixtures, or mocking with pytest-mock. Required for correct MockType usage and async test config.
---

# Test-Driven Development

## Overview

SOP for TDD using pytest and pytest-mock. You MUST invoke this before writing any test or any code that needs to be tested. The TDD cycle is: **Red → Green → Refactor**, one failing test at a time.

## Parameters

- **feature** (required): The behavior or function being tested
- **dependencies** (optional): External dependencies to mock (DB, AWS clients, HTTP)

## Top-Level Constraints

- You MUST NOT write production code before writing a failing test
- You MUST use `pytest` and `pytest-mock` — MUST NOT use `unittest`
- You MUST use `faker` for ALL test data — MUST NOT hardcode strings, numbers, or timestamps
- You MUST use `MockType` for type hints on all mocks
- You MUST NOT mock the function under test — only mock its external dependencies

## Steps

### 1. Name the Test

**Constraints:**
- You MUST name tests using pattern: `test_<method>_given_<scenario>_should_<result>`
- You MUST NOT use vague names like `test_works`, `test_login`, or `test_ok`

```python
def test_register_given_valid_email_should_return_success(): ...
def test_register_given_existing_email_should_raise_conflict_error(): ...
```

### 2. Write a Failing Test (Red)

Write the minimal test that captures the expected behavior. Run it and watch it fail.

**Constraints:**
- You MUST watch the test fail before writing any implementation — a test that was never red is suspect
- You MUST use `faker` for all input data
- You MUST import `from pytest_mock import MockerFixture, MockType`
- You MUST use `MockType` as the type annotation for all mocks

```python
def test_send_notification_given_valid_user_should_return_true(
    faker: Faker,
    mocker: MockerFixture,
) -> None:
    mock_email: MockType = mocker.Mock()
    mock_email.send.return_value = True
    user_id = faker.uuid4()

    result = send_notification(user_id, email_service=mock_email)

    assert result is True
```

### 3. Write Minimal Implementation (Green)

Write only enough code to make the failing test pass.

**Constraints:**
- You MUST NOT write more code than needed to pass the current test (Uncle Bob's 3rd law)
- You MUST run the test after implementing to confirm it passes
- You MUST NOT add features not covered by a test

### 4. Refactor

Clean up code while keeping tests green.

**Constraints:**
- You MUST keep all tests passing throughout the refactor
- You MUST NOT add new behavior during refactoring — only improve structure
- You SHOULD improve naming, remove duplication, simplify logic

### 5. Repeat

**Constraints:**
- You MUST repeat the Red → Green → Refactor cycle for each new behavior
- You MUST NOT write multiple failing tests before implementing — one cycle at a time

## Fixtures

**Constraints:**
- You MUST use pytest fixtures instead of setup/teardown methods
- You SHOULD use `autouse=True` for fixtures that apply to all tests in a module

```python
@pytest.fixture(autouse=True)
def environ() -> None:
    os.environ["STAGE"] = "test"
    os.environ["SERVICE_NAME"] = "test-service"

@pytest.fixture
def mock_repo(mocker: MockerFixture) -> MockType:
    return mocker.Mock(spec=UserRepository)
```

## Async Tests

**Constraints:**
- You MUST configure `asyncio_mode = "auto"` in `pyproject.toml` `[tool.pytest.ini_options]`
- You MUST mark async tests with `@pytest.mark.asyncio`
- You MUST use `mocker.AsyncMock` for mocking async callables

## AWS Lambda Pattern

**Constraints:**
- You MUST NOT mix AWS client instantiation with business logic in the handler
- You MUST extract business logic into a separate testable function that receives dependencies as parameters

```python
# ✅ Testable — dependencies injected
def get_user(user_id: str, repository: UserRepository) -> User | None:
    return repository.get(user_id)

def lambda_handler(event: dict, context: LambdaContext) -> dict:
    repository = DynamoDBUserRepository(os.environ["TABLE_NAME"])
    user = get_user(event["pathParameters"]["userId"], repository)
    return {"statusCode": 200, "body": user.to_json()}
```

## MUST NOTs

- You MUST NOT test private methods — test behavior through the public interface only
- You MUST NOT mock your own domain logic — only mock external dependencies (DB, API, AWS)
- You MUST NOT write a test without at least one `assert`
- You MUST NOT rely on test execution order — each test MUST be fully independent
- You MUST NOT use `os.environ` inside production functions — extract at module level
