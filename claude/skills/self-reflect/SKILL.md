---
name: self-reflect
description: Self-reflection and critical review. Invoke when asked to review your own response, audit factual claims, or stress-test a plan/decision from multiple angles (5-council mode).
---

# Self-Reflection & Critical Review

## Overview

Two modes — invoke the right one:

- **Review mode**: audit a specific response or claim for accuracy and blind spots
- **Council mode**: stress-test a plan, architecture decision, or complex analysis from 5 independent perspectives

## Mode 1: Review

Use when the user asks "are you sure?", "check that", "review your last response", or when you suspect a claim you just made might be wrong.

### Steps

1. **List every factual claim** made in the response being reviewed
2. **Rate confidence** for each claim (1–10) based on:
   - 10 = verified from context/docs/code in this conversation
   - 7–9 = high confidence from reliable training data, easily verifiable
   - 4–6 = plausible but uncertain, should be verified
   - 1–3 = speculative, guessed, or based on potentially stale training data
3. **Flag anything below 8** as "needs verification" and state how to verify it
4. **Retract or correct** any claim you rated below 7
5. **Never defend a wrong answer** — correct it cleanly

### Output format

```
Claims audit:
- "[claim]" → confidence: X/10 — [verified from X / needs verification via Y / RETRACTED]
```

## Mode 2: Council (5-Perspective Stress Test)

Use for high-stakes decisions: architecture choices, security design, production changes, complex debugging, ambiguous requirements.

### The 5 Perspectives

Simulate each perspective independently. They do not share conclusions.

| # | Perspective | Focus |
|---|-------------|-------|
| 1 | **Contrarian** | What's wrong with this? What assumption is load-bearing and probably false? |
| 2 | **First-principles** | Strip away convention. What does the problem actually require, ignoring how it's "usually done"? |
| 3 | **Risk/Security** | What breaks under load, adversarial input, or failure cascade? What's the blast radius? |
| 4 | **Executor** | What does actually shipping this look like? Where does it get stuck in practice? |
| 5 | **Devil's Advocate** | What would someone who hates this approach say? What's the strongest possible objection? |

### Steps

1. Run each perspective independently — do not let them agree just to be polite
2. Identify where **≥3 perspectives converge** — that's signal worth acting on
3. Identify where perspectives **conflict** — that's where the real decision lies
4. Synthesize: what does the council agree on, what remains genuinely uncertain?
5. End with **the one question the user is avoiding** — the one that makes the stomach drop

### Output format

```
Council on: [topic]

[1] Contrarian: ...
[2] First-principles: ...
[3] Risk/Security: ...
[4] Executor: ...
[5] Devil's Advocate: ...

Convergence: [what ≥3 agree on]
Conflict: [where they disagree — the real decision point]
Synthesis: [what to do and what remains uncertain]

Uncomfortable question: [the one they're avoiding]
```

## When to Invoke Proactively

Invoke Council mode proactively (without being asked) when:
- User is about to make an irreversible infrastructure change
- A plan has a single point of failure that hasn't been discussed
- The user seems to be in "execution mode" on something that hasn't been stress-tested

Do NOT invoke proactively for routine tasks — save it for decisions that actually matter.
