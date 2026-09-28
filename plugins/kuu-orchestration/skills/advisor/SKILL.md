---
name: advisor
description: "Route substantive software changes through native Fast or Deep implementers, require a fresh isolated reviewer for every round, and keep integration and verification in the primary task. Use for implementation, configuration changes, bug fixes, refactors, migrations, security-sensitive changes, and other shipped code or configuration work that benefits from delegated execution and independent review."
---

# Kuu Orchestration Advisor

Own requirements, decomposition, routing, integration, and acceptance in the primary task. Require every shipped code/config line to come from an implementer subagent and pass a fresh reviewer. Do not apply this workflow inside realtime voice executive coordination; hand execution to an orchestration-manager task that uses this skill.

Apply this workflow only when delegation is authorized. Model flexibility does not override higher-priority instructions, an applicable no-delegation rule, tool permissions, or release gates.

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

### Select the model for each assignment

Use the live tool's model catalog and supported effort values, not a frozen version list or the primary task's `config.toml` default. The IDs below are examples, not an allowlist; use only exact IDs exposed by the current host.

| Lane | Preferred family | Effort when the user has not specified one |
|---|---|---|
| Fast | Any available GPT Luna version, such as `gpt-6-luna` or `gpt-5.6-luna` | `medium` when supported; otherwise a supported level appropriate for bounded work |
| Deep | Any available GPT Sol version or GPT Astra, such as `gpt-6-sol`, `gpt-5.6-sol`, or `gpt-6-astra` | `xhigh` when supported; otherwise a supported level suitable for demanding reasoning |
| Review | Any available GPT Sol version or GPT Astra, independently selected for a fresh reviewer | `xhigh` when supported; otherwise a supported level suitable for critical review |

When several preferred models are available, choose for the task's capability, latency, and cost needs; neither a particular version nor Sol over Astra is mandatory. A model may come through a host-provided alias, but do not invent IDs or infer its family from an ambiguous label such as "Luna Sol." Resolve ambiguity only when it changes the choice.

**User overrides come first.** An explicit user request may replace any lane's model family, exact model, or effort, including a non-default model for Fast or Review. Apply the requested scope (one assignment, lane, or task); if unspecified, keep it task-scoped and do not rewrite persistent settings. A replacement does not change the lane's responsibilities or fresh-review requirement. If a requested family, exact model, or effort is unavailable, ask for a replacement unless the user already authorized a fallback. Do not silently swap a pinned choice.

**Availability fallback.** For Deep and Review, try another available Sol or Astra before leaving those families. If no eligible Sol/Astra is available because of model access, unsupported routing, or exhausted quota, another available model suitable for the lane is allowed without a new preference question; disclose its exact ID, effort, and why it was selected. Keep existing provider/data permissions: fallback is not permission to enable a provider, send data to a new destination, spend beyond the user's scope, or bypass a gate. If no suitable authorized model exists, report the blocker. For Fast, try another Luna version; if no Luna is available, ask for a replacement unless the user has already authorized one.

Code failures, failing tests, reviewer rejection, transient tool errors, or full agent slots are not model unavailability. They follow the normal fix/escalation or capacity path. If a model becomes unavailable after work started, stop that attempt, inspect and preserve partial edits/evidence, then hand off only the remaining work. Bound an availability recovery to one replacement execution per assignment; if that fails too, report the blocker instead of cycling models. An interrupted review is not a verdict: start its replacement in fresh context.

Pass the selected model and supported effort explicitly when the live spawn surface exposes them. If those controls are absent, use a documented host mechanism only when it can enforce the selected route; otherwise report routing as unavailable and stop. Never label an inherited default as the requested model. Report configured/requested routing separately from observed runtime identity; if identity is not observable, say it is unverified.

For model overrides, use `fork_turns: none` or a bounded partial fork only when the live tool supports it; a full-history fork may prohibit overrides. Deep and Review always use `fork_turns: none`.

## 4. Require fresh review

For every review round, select a model under the policy above and start a new reviewer with `fork_turns: none`. The reviewer may use the same model as the implementer, but must be a different agent with fresh context. Give the reviewer only:

- `GOAL`
- `CONSTRAINTS`
- `DONE WHEN`
- the actual diff or commit and verification evidence

Do not include plans, implementation reasoning, or earlier reviewer context. Require exactly one verdict:

- `SHIP`: accept the review result for primary verification.
- `FIX`: send the bounded fix text verbatim to the same current implementer; allow only one Fast retry, then verify and use a new reviewer.
- `RETHINK`: route to a fresh Deep implementer using the selection policy above.

After a second non-shippable Fast attempt, route to a fresh Deep implementer using the selection policy above. Preserve any user override applicable to Deep; do not carry a Fast-only override into another lane. A Deep fix also requires implementation by the Deep implementer, primary verification, and another fresh reviewer.

## 5. Integrate

Treat implementer and reviewer reports as claims. The primary task must inspect the actual diff, confirm file scope, run `DONE WHEN`, reconcile any concurrent changes, and report shipped, failed, or skipped checks. The primary may decompose, gate, integrate, and verify, but must not write shipped code or configuration.
