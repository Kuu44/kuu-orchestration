# Kuu Orchestration

Kuu Orchestration is a small Codex plugin for native-subagent software delivery. The primary task owns requirements, routing, integration, and acceptance; implementers write every shipped code/config line; a fresh reviewer evaluates every round.

| Lane | Route | Use it when |
|---|---|---|
| Fast | GPT-6 Luna (`gpt-6-luna`, medium effort) | One module or two tightly coupled files, known pattern, reversible change, simple acceptance check |
| Deep | GPT-6 Sol (`gpt-6-sol`, xhigh effort) | Cross-module or shared-contract work, unclear shape, hard rollback, or sensitive behavior |
| Review | Fresh GPT-6 Sol (`gpt-6-sol`, xhigh effort) | Every implementation round, with only the goal, constraints, acceptance criteria, diff, and evidence |

Native subagents are the default. A user-visible Codex task is reserved for work that must outlive the parent task, needs direct user follow-up, requires durable independent worktree ownership, or waits on external state. Delegation may nest only to depth 2, and an implementer may create at most one bounded child.

## Prerequisites

Set the delegation depth in `~/.codex/config.toml`. Primary/default model settings are independent from Advisor lane routing; keep those values at your preferred baseline because the skill requests each lane's model and effort explicitly per assignment.

```toml
[agents]
max_depth = 2
```

Fast implementation requests GPT-6 Luna (`gpt-6-luna`) with medium effort per assignment. If the requested route is unavailable, report it as unverified and stop rather than substituting another model.

Deep implementation and every fresh reviewer request GPT-6 Sol (`gpt-6-sol`) explicitly with xhigh effort. Stop if that route is unavailable. There is no model fallback.

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
