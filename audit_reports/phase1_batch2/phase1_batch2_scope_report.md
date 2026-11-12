# Phase 1 — Batch 2 scope report

## Selection gate

Read finding_traceability.md, implementation_plan.md and blocked_items.md. Recorded classifications, not inferred readiness, governed selection.

| Finding | Recorded status | Batch decision |
| --- | --- | --- |
| UX-01 Add Bill navigation | REQUIRES INVESTIGATION | EXCLUDED. Q-NAV still needs the intended existing meter-selection journey, arguments and back-stack expectations. No route replacement, invented workflow or removal of action. |
| UX-02 Technology Bills search | READY | IMPLEMENTED. Existing text/filter semantics preserved; correct observation/debounce. |
| UX-03 Warm-cache loading | READY; BASE, DATA-06 | IMPLEMENTED for the three named catalogs. Batch 1 guard verified and reused to resolve response ownership locally; no unresolved dependency requiring another batch. |
| UX-04 Registration loading | READY | IMPLEMENTED for public registration assignment, in-flight exclusion and disabled submit. Password-change and authentication policy work excluded from this batch's explicit registration scope. |
| REL-01 Analysis errors/loading | READY; BASE, DATA-06 | IMPLEMENTED for station analysis and financial chart identified in the finding. Lifecycle/request guard plus terminal states/retry. Chart security/platform policy not changed. |

## Preservation and boundaries

Captured baseline hashes before edits. Thirteen existing source files changed for this batch, plus one small retry-view widget and one test file. Exact file list and reasons are in the implementation report. Batch 1 guard, shared transport, Planning, bill history and tests remain unchanged. Only the operational Technology Bills search portion was modified in its existing Batch 1 controller; stable-ID draft/save methods remain intact. Public login navigation, all route declarations, bindings, models, calculations and dependency files retain their baseline hashes.

No backend change, formula/recalculation correction, security remediation, networking consolidation, full UI redesign, performance optimization, new dependency, role policy change or blocked-finding implementation. Temporary web build output is /private/tmp/power-saving-batch2-web; no deployment. Reports/logs are under audit_reports/phase1_batch2. Existing user modifications were not overwritten.

## Remaining risks / excluded work

UX-01 remains investigation-gated. Other blocked Phase 0 findings remain unchanged, including financial formulas, report completeness, TLS/chart isolation, native parity and signing. Static cache cross-account partitioning remains a separate security finding. Native chart behavior and visual layout require their own authorized verification; no visual QA is claimed here. Existing analyzer debt and the unrelated empty widget test entry point remain. Request guards govern local effects, not server cancellation. The initial pre-edit regression execution was interrupted for a harness scheduling issue; tests were corrected and all 60 runnable tests ultimately passed.

Stop condition satisfied: only this selected Batch 2 work was completed. Any subsequent batch requires explicit approval.
