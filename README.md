# Kuu Orchestration

Kuu Orchestration is a small Codex plugin for native-subagent software delivery. The primary task owns requirements, routing, integration, and acceptance; implementers write every shipped code/config line; a fresh reviewer evaluates every round.

| Lane | Route | Use it when |
|---|---|---|
| Fast | Any available GPT Luna version; medium effort when supported | One module or two tightly coupled files, known pattern, reversible change, simple acceptance check |
| Deep | Any available GPT Sol version or Astra; xhigh effort when supported | Cross-module or shared-contract work, unclear shape, hard rollback, or sensitive behavior |
| Review | Fresh GPT Sol or Astra agent; xhigh effort when supported | Every implementation round, with only the goal, constraints, acceptance criteria, diff, and evidence |

Native subagents are the default. A user-visible Codex task is reserved for work that must outlive the parent task, needs direct user follow-up, requires durable independent worktree ownership, or waits on external state. Delegation may nest only to depth 2, and an implementer may create at most one bounded child.

## Prerequisites

Set the delegation depth in `~/.codex/config.toml`. Primary/default model settings are independent from Advisor lane routing; keep those values at your preferred baseline because the skill requests each lane's model and effort explicitly per assignment.

```toml
[agents]
max_depth = 2
```

## Model selection and user overrides

The lane is the job; the model is who does it. Changing the model does not remove fresh review, safety boundaries, or acceptance checks. The primary/default model remains independent, and this plugin does not override an applicable no-delegation instruction.

- Resolve exact IDs and supported effort levels from the live host. GPT-5.6, GPT-6, and later available versions in the preferred families are allowed; examples are not a fixed allowlist. Choose among them for the task's capability, latency, and cost needs.
- Fast prefers Luna. Deep and Review accept Sol or Astra equally; when neither family is available, a suitable authorized alternative is allowed and must be disclosed. Fast needs user authorization to leave Luna.
- Explicit user model/effort choices override these defaults for their stated scope. For example: "Use GPT-5.6 Sol for Deep," "Use Astra for review," or "Use GPT-6 Sol for Fast in this task." Resolve a family request against available models; do not invent an ID. If a pinned model/effort is unavailable, ask unless fallback was already authorized.
- Do not silently substitute models, enable providers, change global configuration, or bypass data-access/cost boundaries. Code/test/review failures and full agent slots do not justify availability fallback.
- If availability fails after work starts, reconcile partial work before one bounded replacement attempt. Deep and Review keep fresh context. Unobservable runtime identity is reported as unverified, not assumed.

The [Advisor skill](plugins/kuu-orchestration/skills/advisor/SKILL.md#select-the-model-for-each-assignment) is the authoritative routing policy. [Model-routing scenarios](tests/model-routing.md) cover expected decisions and release checks. Host controls still determine which routes can actually be enforced; see the [official subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents).

## Install

```powershell
codex plugin marketplace add Kuu44/kuu-orchestration
codex plugin add kuu-orchestration@kuu-orchestration
```

After cloning, `./install.ps1` runs the same two official commands with exit-code checks. Start a new Codex task after installation, then ask normally for a software change or invoke the skill:

```text
Use $kuu-orchestration:advisor to implement and verify this change.
```

When the skills catalog is truncated, the full `$kuu-orchestration:advisor` namespace is required; `$advisor` does not resolve reliably.

## Update

```powershell
codex plugin marketplace upgrade kuu-orchestration
codex plugin add kuu-orchestration@kuu-orchestration
```

Start a new task so Codex discovers the updated skill.

## Workflow

1. Read the touched path and callers; state the root cause in one sentence.
2. Measure boundaries, contracts, owners, rollback cost, shape clarity, and reviewability; route Fast or Deep.
3. Give the implementer exactly `GOAL`, `FILES`, `PATTERN`, `CONSTRAINTS`, and `DONE WHEN`.
4. Send only the goal, constraints, acceptance criteria, actual diff or commit, and evidence to a fresh reviewer.
5. Integrate in the primary task: inspect the diff, rerun acceptance checks, and report shipped, failed, and skipped checks.

Fast gets one bounded `FIX` retry in the same implementer. `RETHINK` or a second non-shippable Fast attempt escalates to a fresh Deep implementer. Every new round gets a fresh reviewer.

## Verify a checkout

```powershell
python "$HOME/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py" plugins/kuu-orchestration
python "$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py" plugins/kuu-orchestration/skills/advisor
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path ./install.ps1), [ref]$null, [ref]$errors) | Out-Null
if ($errors.Count) { throw ($errors -join [Environment]::NewLine) }
```

## Inspiration

The repo-marketplace/plugin/skill layout was inspired by [DannyMac180/sol-advisor](https://github.com/DannyMac180/sol-advisor). Kuu Orchestration's workflow and implementation are original.

## License

MIT
