# Model-routing acceptance scenarios

These are decision-level regression cases for the instruction-only Advisor skill, not an executable router. Read the candidate skill, use each synthetic host inventory below, and record the chosen lane/model, effort, context, and disclosure or blocker. Use only the stated inventory; do not actually spawn agents or mutate a project for these cases. A self-review of these cases is not an independent model evaluation or proof of live runtime identity.

Model names such as `other-reasoner` and a future Luna version below are synthetic host entries, not claims that those products exist. Unless specified otherwise, model controls exist, delegation is authorized, and the named model supports the lane's preferred effort.

| Case | Input / live inventory | Expected decision |
|---|---|---|
| 1. Older Fast model | Bounded known-pattern change; only `gpt-5.6-luna` available | Fast on that Luna, medium; no exact-version blocker. |
| 2. Later Fast model | Same change; host exposes a newer GPT Luna family entry | Use its exact advertised ID and supported effort, not a fabricated GPT-6 alias. |
| 3. Older Deep model | Shared API change; only `gpt-5.6-sol` available | Deep on that Sol, xhigh, fresh context. |
| 4. Astra review | Only `gpt-6-astra` available for review | New Astra reviewer with fresh context; no requirement for Sol specifically. |
| 5. Preferred choice | Both Sol and Astra available, no override | Either appropriate preferred model is valid; report the selected ID/effort. Do not leave these families unnecessarily. |
| 6. Availability fallback | All Sol/Astra unavailable; authorized `other-reasoner` can perform Deep work | Use that alternative with supported effort; disclose why. Preserve Deep and fresh-review responsibilities. |
| 7. Unauthorized destination | Only alternative would send private code to an unapproved provider | Stop and request the required permission/choice; availability is not data-transfer authorization. |
| 8. Fast replacement | User says "Use GPT-6 Sol for Fast in this task"; that model is available | Honor task-scoped override; keep the Fast scope and review gate; no persistent config write. |
| 9. Exact pin unavailable | User pins `gpt-5.6-sol`/high for Review; only Astra is available and no fallback authorized | Ask for a replacement; do not silently select Astra. |
| 10. Family override | User asks for Astra reviews; available Astra supports only high | Resolve the available Astra ID, select supported high, and disclose. If user also pinned xhigh, ask instead. |
| 11. No Luna | Fast-eligible work, only Sol available, no override | Ask for a Fast replacement; do not relabel the work Deep solely to bypass the Luna preference. |
| 12. Missing controls | Model/effort controls absent; no documented mechanism can enforce the route | Report unavailable routing; do not claim inheritance selected the requested model. |
| 13. Test or review failure | Sol runs but tests fail, or reviewer returns FIX | Follow the fix/review loop, not availability fallback. RETHINK or the second failed Fast attempt escalates to Deep. |
| 14. Mid-run quota failure | Deep implementer loses quota after partial edits | Preserve/reconcile those edits; one replacement execution at most. A second availability failure stops. |
| 15. Review interruption | Reviewer loses access before a verdict | Replacement review is a new agent with fresh context; no inherited review conclusions and no assumed SHIP. |
| 16. Lane-scoped override | Fast-only model override, then RETHINK | Select Deep under its own policy; do not carry Fast-only selection into Deep. |
| 17. Full slots | Preferred model is available but agent slots are full | Handle capacity without model cycling or bypassing review. |
| 18. No delegation | Applicable instruction prohibits delegation | Do not start this workflow or switch models to evade the instruction. |

## Release checks

1. Read the full skill against all cases; distinguish a policy walkthrough from a live agent test.
2. Run the official skill and plugin validators, parse `install.ps1`, and run `git diff --check`.
3. Inspect the complete diff for remaining fixed-version or no-fallback instructions and for accidental changes to Fast/Deep escalation and fresh-review boundaries.
4. After publishing, refresh the configured Git marketplace and reinstall the plugin. Compare every installed package file with the committed source, accounting only for line endings.
5. Report the published commit, installed version, review type, and any runtime routing not exercised. A new task is needed to pick up the updated skill.
