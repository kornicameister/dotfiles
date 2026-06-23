---
name: bdd
description: Behavior-Driven Development with pytest-bdd. ALWAYS invoke when writing Gherkin scenarios, pytest-bdd step definitions, or any BDD acceptance tests. Never write feature files without this skill loaded.
---

# Behavior-Driven Development

## Overview

SOP for BDD with pytest-bdd. You MUST invoke before writing any Gherkin feature file or step definitions. BDD is for acceptance and integration tests — you MUST NOT use it for unit tests (use `tdd` skill instead).

## Parameters

- **feature** (required): The user-facing behavior to specify
- **role** (required): The specific role performing the action (e.g. "Premium Customer", "Operator")

## Top-Level Constraints

- You MUST use BDD only for acceptance and integration tests — MUST NOT use for unit tests
- You MUST write Gherkin scenarios in declarative style (WHAT, not HOW)
- You MUST be specific about WHO is acting — MUST NOT use generic "User" or "I"
- You MUST NOT reference UI elements (IDs, XPaths, CSS selectors) in feature files

## Steps

### 1. Three Amigos Review

Before writing any Gherkin, align on the scenario with three perspectives.

**Constraints:**
- You MUST clarify business value (why) before automating
- You MUST identify edge cases during this phase
- You SHOULD surface assumptions before writing scenarios, not after

| Role | Question |
|------|----------|
| Business | Why does this behavior matter? |
| Developer | Is this feasible? Any constraints? |
| Tester | What are the edge cases? |

### 2. Write the Gherkin Scenario

**Constraints:**
- You MUST write WHAT happens (declarative) — MUST NOT describe HOW (imperative)
- You MUST structure as: Given (precondition) / When (action) / Then (observable outcome)
- You MUST NOT reference implementation details in step text
- You SHOULD use `Background:` for Given steps repeated across scenarios in the same feature

```gherkin
# ✅ Declarative — MUST write like this
Scenario: Premium customer receives discount at checkout
  Given "Alice" is logged in as a premium customer
  When Alice adds a $100 product to her cart
  Then Alice should see a 10% discount applied

# ❌ Imperative — MUST NOT write like this
When I click button with id "submit-btn"
Then I see element with xpath "//div[@class='success']"
```

```gherkin
Feature: Cost Analysis

  Background:
    Given the system is online
    And I am authenticated as an operator

  Scenario: View monthly costs for single account
    When I request costs for account "123456789012" in "2026-05"
    Then I should see a cost breakdown by service
```

### 3. Implement Step Definitions

**Constraints:**
- You MUST import `from pytest_bdd import scenarios, given, when, then, parsers`
- You MUST use `parsers.parse` for parametrized step text
- You MUST NOT duplicate step definitions — use parametrization or shared fixtures
- You SHOULD reuse steps via pytest fixtures shared across feature files

```python
from pytest_bdd import scenarios, given, when, then, parsers

scenarios('../features/checkout.feature')

@given(parsers.parse('"{name}" is logged in as a premium customer'))
def premium_customer(name: str) -> dict:
    return {"name": name, "tier": "premium"}

@when(parsers.parse('Alice adds a ${amount:d} product to her cart'))
def add_product(cart: ShoppingCart, amount: int) -> None:
    cart.add_item(price=amount)

@then('Alice should see a 10% discount applied')
def verify_discount(cart: ShoppingCart) -> None:
    assert cart.discount_rate == 0.10
```

### 4. Tag for Test Categories

**Constraints:**
- You MUST tag slow tests with `@slow`
- You MUST tag API tests with `@api`
- You MUST tag e2e tests with `@e2e`
- You MAY combine tags: `@smoke @api`

```gherkin
@api @smoke
Feature: Cost Explorer API

  @slow
  Scenario: Multi-account cost rollup
    ...
```

## MUST NOTs

- You MUST NOT write BDD for unit tests — use the `tdd` skill
- You MUST NOT automate scenarios before Three Amigos alignment
- You MUST NOT use "User" as role — always use a specific persona
