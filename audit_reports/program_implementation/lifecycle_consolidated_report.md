# Consolidated lifecycle/navigation checkpoint

Accepted batches 11–13 preserved; batch 14 adds six guarded missing-argument navigation flows. No broad refactor, backend/API/business/security/report behavior change or cache/dependency introduced. UX-05 remains deferred.

| Batch | Confirmed fix | Final approved tests |
|---|---|---:|
| 11 | Station/place initialization ignores disposed owners | 215 |
| 12 | User dialog disposes three text fields and notifier with its subtree | 218 |
| 13 | User card/dialog wraps content without dropping fields/actions | 221 |
| 14 | Five edit redirects and Analysis back callback cannot act from a stale route; invalid forms do not build | 233 |

Exact changes, red/green evidence and limitations: [11–13 continuation](continuation_lifecycle_responsive.md), [batch 14](batch14/report.md). Complete latest code diff: batch14/batch.diff. Final analyze: 53 existing findings, no errors; Web build 62.4s and Wasm dry run passed; diff check passed. All 30 frozen contract files unchanged against the program baseline. Existing dirty user/remediation changes preserved; no commits/resets performed.

## Ownership coverage and unresolved findings

[Ownership assessment](batch14/ownership_assessment.md) and its 45-file source inventory cover explicit fields, scroll/animation/focus controllers, timers, workers/listeners, bindings, dynamic drafts and route callbacks. Existing search cancellation and resource disposal protections remain passing. This is not a heap-profile or proof of zero leaks across every route.

- Confirmed late chemical mutation completion changes a newer screen after disposal (success redirect or failure dialog). Two separate in-memory characterization tests pass and capture unchanged POST/body/header behavior. Mutation implementation is unchanged. Pending explicit decision: allow request completion but suppress disposed-owner UI updates/navigation/dialogs, or preserve existing behavior.
- Financial controller replacement can affect recalculation/field identity; remains blocked under preservation rules.
- Legacy dashboard ScrollController helpers lack disposal but have no confirmed callers; not treated as a reproduced live leak.
- Other mutation/navigation/shared-owner patterns need individual reproduction and workflow decisions. Authentication routing callbacks are outside this patch; policies untouched.
- Protected live verification remains blocked without an authorized session; no personal credentials or authentication bypass. Public live coverage remains the accepted batch 11 evidence. No business mutation was sent during tests.

## Next phase

[Performance profiling proposal](performance_profiling_proposal.md) documents scope, current correctness/build baseline, missing runtime metrics, measurement protocol and evidence gates. Profiling and optimization have NOT started. Runtime baseline values must be collected under an agreed authorized measurement setup and documented before any optimization.

## Approved continuation — batch 15

The chemical-specific pending decision above is resolved by explicit user approval. Both add and edit now suppress disposed-owner completion side effects while preserving their dispatched requests and active behavior. [Batch 15 report](batch15/report.md) records 14 failing disposed cases before the fix, 28 focused passing cases afterward, and 261 combined tests passed. Other workflow/financial gates and profiling status are unchanged.
