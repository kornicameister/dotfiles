---
name: ddd
description: Domain-Driven Design tactical patterns. ALWAYS invoke when implementing aggregates, entities, value objects, repositories, or domain events in Python. Prevents common DDD mistakes (anemic models, multi-aggregate transactions).
---

# Domain-Driven Design

## Overview

SOP for DDD tactical patterns in Python. You MUST invoke before implementing any aggregate, entity, value object, repository, or domain event.

## Parameters

- **bounded_context** (required): The domain area being modeled
- **aggregate** (required): The aggregate root being designed

## Top-Level Constraints

- You MUST NOT apply DDD to simple CRUD operations, reporting/analytics apps, or POCs
- You MUST keep each transaction to a single aggregate — MUST NOT modify multiple aggregates in one transaction
- You MUST reference other aggregates by ID only — MUST NOT hold direct object references
- You MUST keep aggregates small (2-3 entities max) — larger aggregates signal wrong boundaries
- You MUST put business logic inside domain objects — MUST NOT put it in service classes (anemic model anti-pattern)

## Patterns

### Value Objects (Immutable)

**Constraints:**
- You MUST use `ConfigDict(frozen=True)` — MUST NOT create mutable value objects
- You MUST validate invariants in the constructor using Pydantic validators

```python
from pydantic import BaseModel, ConfigDict, Field

class Money(BaseModel):
    model_config = ConfigDict(frozen=True)

    amount: float = Field(ge=0)
    currency: str = Field(pattern=r'^[A-Z]{3}$')

    def add(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(amount=self.amount + other.amount, currency=self.currency)
```

### Entities (Identity-Based)

**Constraints:**
- You MUST implement equality based on ID, not field values
- You MUST generate IDs at construction time using `uuid4()`

```python
from uuid import UUID, uuid4

class Order(BaseModel):
    order_id: UUID = Field(default_factory=uuid4)

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Order):
            return False
        return self.order_id == other.order_id
```

### Aggregates (Consistency Boundary)

**Constraints:**
- You MUST enforce all invariants inside the aggregate before state changes
- You MUST collect domain events on the aggregate and publish after save
- You MUST reference other aggregates by ID — MUST NOT store object references

```python
class Order(BaseModel):
    order_id: UUID = Field(default_factory=uuid4)
    customer_id: UUID  # ✅ ID reference — MUST NOT be Customer object
    lines: list[OrderLine] = Field(default_factory=list)
    status: str = "pending"
    _events: list[DomainEvent] = []

    def add_line(self, product_id: UUID, quantity: int) -> None:
        if self.status != "pending":
            raise ValueError("Cannot modify confirmed orders")
        self.lines.append(OrderLine(product_id=product_id, quantity=quantity))

    def confirm(self) -> None:
        if not self.lines:
            raise ValueError("Cannot confirm empty order")
        self.status = "confirmed"
        self._events.append(OrderConfirmed(order_id=self.order_id))
```

### Domain Events (Past Tense)

**Constraints:**
- You MUST name events in past tense: `OrderConfirmed`, `PaymentProcessed`
- You MUST make events immutable using `ConfigDict(frozen=True)`

```python
class DomainEvent(BaseModel):
    model_config = ConfigDict(frozen=True)
    event_id: UUID = Field(default_factory=uuid4)

class OrderConfirmed(DomainEvent):
    order_id: UUID
    total: float
```

### Repositories (Abstract Interface)

**Constraints:**
- You MUST define an abstract base class with `ABC` for each repository
- You MUST provide an in-memory implementation for tests — MUST NOT mock the repository in unit tests

```python
from abc import ABC, abstractmethod

class OrderRepository(ABC):
    @abstractmethod
    def get_by_id(self, order_id: UUID) -> Order | None: ...

    @abstractmethod
    def save(self, order: Order) -> None: ...

class InMemoryOrderRepository(OrderRepository):
    def __init__(self) -> None:
        self._orders: dict[UUID, Order] = {}

    def get_by_id(self, order_id: UUID) -> Order | None:
        return self._orders.get(order_id)

    def save(self, order: Order) -> None:
        self._orders[order.order_id] = order
```

## MUST NOTs

- You MUST NOT put business rules in service classes — put them inside aggregates
- You MUST NOT modify multiple aggregates in one transaction — use domain events for coordination
- You MUST NOT design aggregates to match database tables — design for transactional consistency
