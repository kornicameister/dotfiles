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

## Architecture Boundaries When Using DDD with Ports and Adapters

- Read the working issue, parent/dependencies, related open issues and governing/linked ADRs before changing shared contracts. Preserve accepted decisions and supersession history; record an intentional architectural change in an ADR with rejected alternatives and migration obligations.
- Keep domain behavior and application use cases independent of CLI/HTTP payloads, SDKs, ORM models and persistence implementations. Domain objects must not depend on application command DTOs or handlers. Core-owned ports describe required capabilities; adapter implementations depend inward on those contracts.
- A driving adapter translates its own payload into an application-owned command. Use cases interpret commands and invoke domain behavior. A repository/checkpoint adapter must not interpret inbound command kinds merely to decide how to persist state; translate the request into its dedicated core-defined persistence contract.
- Reuse explicit common-language identities and domain values where their meaning is shared. Do not use one transport/command/ORM/checkpoint DTO as a universal model. Introduce mappings for semantic boundaries, without manufacturing duplicate classes where the same common-language value is appropriate.
- Keep concrete adapter selection, dependency construction and runtime wiring in a composition root outside the business core. Schema creation/migrations are separate administrative operations, not repository construction or ordinary command behavior.
- Preserve required transaction consistency while separating contracts. Replay metadata and pending-effect intents may belong to the same aggregate checkpoint transaction; removing command coupling must not split them into independently committed writes. Such technical records do not automatically constitute additional aggregates.
- Enforce the chosen dependency direction with architecture tests in the normal test/CI path. Cover prohibited import edges and require explicit architectural roles for new modules. Static import tests complement contract/recovery tests; they do not prove semantic correctness of every payload.

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

### Set-Based Consistency Validation (Cross-Aggregate Uniqueness)

**The one exception to "business rules live inside aggregates":** a rule like "no two Orders share
a reference number" can't be enforced by any single aggregate, because one aggregate instance has
no way to know about its siblings — it only guards its own consistency boundary. This is a named
DDD limitation, not a modeling mistake to fix by trying harder.

**Constraints:**
- You MUST enforce this kind of rule with a domain service that queries the repository, not by
  adding a lookup method to the aggregate itself
- You MUST treat the check as best-effort — it is read-then-write and races under concurrent
  creates
- You MUST back it with a real uniqueness constraint at the persistence layer (unique index/column)
  as the actual guarantee — the domain service only gets to fail fast with a clear error, it is not
  the source of truth for uniqueness

```python
class OrderReferenceAlreadyExistsError(Exception):
    def __init__(self, reference: str) -> None:
        super().__init__(f"Order reference already exists: {reference}")
        self.reference = reference

def ensure_order_reference_is_unique(
    repository: OrderRepository, reference: str, exclude_id: UUID | None = None
) -> None:
    existing = repository.get_by_reference(reference)
    if existing is not None and existing.order_id != exclude_id:
        raise OrderReferenceAlreadyExistsError(reference)
```

`exclude_id` matters the moment this rule also guards an update/rename: without it, renaming an
Order back to its own current reference reads as a conflict with itself.

## MUST NOTs

- You MUST NOT put business rules in service classes — put them inside aggregates, except
  set-based consistency validation (see above), which cannot live inside any single aggregate
- You MUST NOT modify multiple aggregates in one transaction — use domain events for coordination
- You MUST NOT design aggregates to match database tables — design for transactional consistency
