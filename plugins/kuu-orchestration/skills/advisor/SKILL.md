---
name: advisor
description: "Route substantive software changes through native Fast or Deep implementers, require a fresh isolated reviewer for every round, and keep integration and verification in the primary task. Use for implementation, configuration changes, bug fixes, refactors, migrations, security-sensitive changes, and other shipped code or configuration work that benefits from delegated execution and independent review."
---

# Kuu Orchestration Advisor

Own requirements, decomposition, routing, integration, and acceptance in the primary task. Require every shipped code/config line to come from an implementer subagent and pass a fresh reviewer. Do not apply this workflow inside realtime voice executive coordination; hand execution to an orchestration-manager task that uses this skill.

## 1. Understand before splitting

Read the touched files, trace their execution path and callers, and state the root cause in one sentence before delegating. Define `DONE WHEN` as runnable acceptance checks.

Use native subagents by default. Create a persistent user-visible Codex task only when the work must outlive its parent task, needs direct user follow-up, requires durable independent worktree ownership, or waits on external state. When a persistent task is necessary, name it `🤖 Fast · ...`, `🤖 Deep · ...`, or `🤖 Review · ...`.

## 2. Route by change surface

Measure module and package boundaries, shared contracts and trust boundaries, callers and owners, coordination and rollback cost, whether the implementation shape is known, and whether one reviewer can understand the behavior in one pass. File count and diff size are signals, not automatic decisions. Tests, docs, generated files, and formatting-only files do not add complexity by themselves.

Choose **Fast** only when all are true:

- The change is bounded to one module or two tightly coupled files.
- The existing implementation pattern is known and named as `path:line`.
- It does not involve concurrency, ordering, retries, performance, trust boundaries, security, authentication, secrets, payments, migrations, schemas, public APIs, data loss, or another hard-to-reverse change.
- The acceptance check is one simple command or assertion.

Choose **Deep** when any are true:

- The change crosses production modules or package boundaries.
- It changes a shared contract, public API, schema, or behavior used by several callers.
- The shape is unclear or the root cause is not established.
- It involves concurrency, ordering, retries, performance, security, authentication, secrets, payments, migrations, or data loss.
- A reviewer says Fast needs structural rethinking.
- A second Fast attempt is not shippable.

## 3. Delegate implementation

Send each implementer exactly these five sections:

```text
GOAL
[One concrete objective]

FILES
[Owned files or modules]

PATTERN
[Existing pattern with path:line]

CONSTRAINTS
[Safety, style, scope, shared-state, and rollback boundaries]

DONE WHEN
[Runnable checks and acceptance criteria]
```

State file ownership and warn that other agents share the workspace: preserve others' edits, never revert them, and adapt to concurrent changes. Split an overlong unit. An implementer may spawn at most one bounded child, and total delegation depth must not exceed 2.

For Fast, per assignment, request `gpt-5.3-codex-spark` with `xhigh` effort when the live native spawn surface exposes those controls. If Spark controls are not exposed, or Spark is unavailable or out of quota before execution, request `gpt-5.6-luna` with `max` effort as the sole availability fallback; that pre-execution failure does not count as an implementation attempt.

If Spark starts and then reports quota or availability failure, stop it, reconcile partial work, and assign the same bounded scope to Luna at most once. This availability fallback does not reset the Fast quality retry budget. Do not use this fallback for code, test, review, or generic transient failures.

Stop if Luna is unavailable or out of quota; never substitute Sol or another model. If runtime identity is not observable, report the configured route as unverified.

For Deep, request Astra Light: `gpt-6-astra` with `low` effort and a fresh context by setting `fork_turns` to `none`. Astra Light is a routing label for that model/effort pair, not a separate model. Stop if that route is unavailable; do not substitute another model.

## 4. Require fresh review

For every review round, start a new Astra Light `gpt-6-astra` reviewer at `low` effort with `fork_turns: none`. Stop if that route is unavailable; do not substitute another model. Give the reviewer only:

- `GOAL`
- `CONSTRAINTS`
- `DONE WHEN`
- the actual diff or commit and verification evidence

Do not include plans, implementation reasoning, or earlier reviewer context. Require exactly one verdict:

- `SHIP`: accept the review result for primary verification.
- `FIX`: send the bounded fix text verbatim to the same current implementer; allow only one Fast retry, then verify and use a new reviewer.
- `RETHINK`: route to a fresh Deep Astra Light implementer.

After a second non-shippable Fast attempt, route to a fresh Deep Astra Light implementer. A Deep fix also requires implementation by the Deep implementer, primary verification, and another fresh reviewer.

## 5. Integrate

Treat implementer and reviewer reports as claims. The primary task must inspect the actual diff, confirm file scope, run `DONE WHEN`, reconcile any concurrent changes, and report shipped, failed, or skipped checks. The primary may decompose, gate, integrate, and verify, but must not write shipped code or configuration.
