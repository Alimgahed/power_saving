# Dependency-aware implementation plan

**Plan only. Stop after Phase 0 and obtain explicit Phase 1 authorization.** No task authorizes backend/schema changes, API/authentication contract changes, financial/domain changes, feature removal or dependency replacement. A task marked READY is only eligible for a future authorized batch.

## Stage 1 — baseline and regression protection

Dependencies: reviewed Phase 0 snapshot and explicit next-phase authorization. Owner: frontend/QA, with domain reviewer for fixture interpretation.

Preserve master, lockfile and audit artifacts. Compare hashes before/after each batch; never reset/clean user changes. Establish a small fake-HTTP/local-state seam only if needed, retaining existing operation-specific behavior. Add characterization fixtures for exact current meter formulas, event timing, all 59 API call sites, serializers, role menus and route/session transitions. Label known discrepancies as current behavior, not endorsed business rules. Deny live network in tests. Do not upgrade packages to make tests pass without approval.

Exit: actual executed results reported honestly; current characterization and proposed target tests separated; no unrelated source or contract drift. No arbitrary coverage percentage target.

## Stage 2 — stability, lifecycle, consistency and confirmed bugs

After Stage 1, the following are separable feature batches, not an instruction to delegate:

| Batch | Findings | Eligible implementation | Dependencies and exit |
|---|---|---|---|
| S2-A draft preservation | DATA-04/05 | Preserve planning inputs by placeTypeId and technology-bill drafts by techBillId. No value recalculation. | Stable-ID fixtures; reordered/refreshed data retains exact input values and payloads. |
| S2-B asynchronous state | DATA-06, REL-01 | Reject stale commits; fetch analysis from lifecycle; terminal loading/empty/error and retry same request. | Controlled completion-order tests; no server cancellation or mutation replay. |
| S2-C interactions | UX-02/03/04 | Query observation, refresh completion/loading ownership, registration loading assignment and duplicate-submit exclusion. | Delayed fake requests/widget tests; unchanged individual request content and permissions. |
| S2-D cleanup | LIFE-01 | Dispose owned workers/controllers and replaced resources where observable behavior stays equivalent. | Ownership tests; billing recalculation subset DATA-02/03 deferred. |
| S2-E report metadata | UX-05 | Display count of exported filtered rows. | Same rows/order/totals/units/formatting; only count metadata corrected. |

DATA-01/02/03 and DATA-07 stay blocked. A nonblocking completeness warning may be separately scoped without closing DATA-07 or changing row rejection/export behavior.

## Stage 3 — client-side security and session isolation

Dependencies: Stage 1 and relevant Stage 2 request/draft ownership fixtures.

SEC-04: account-scoped caches and stale-response rejection across explicit logout/account change. Preserve bearer protocol, storage keys, role policy and endpoints; clear only session-owned data. SEC-03: context-aware encoding of dynamic HTML text while retaining intentional template markup, visible content and print controls. Test every report variant, Arabic and special characters.

SEC-02 remains gated on compatible chart isolation. SEC-01 remains blocked. SEC-05/06 are READY under the user-approved policy: preserve public registration, reject invalid raw group information before session creation/restoration, block invalid-session protected navigation, and retain session/navigation after password-change success when the existing token allows. Preserve valid-role mappings and all wire contracts; do not add refresh flow, validation endpoints, new roles or generalized 403 policy changes.

Exit: actual offline security fixtures demonstrate isolation/encoding and unchanged requests/features; unresolved threat assumptions stay documented.

## Stage 4 — networking reliability without contract changes

Dependencies: API-FREEZE, QA-01 and investigation of ARCH-01/NET-01. Coordinate with DATA-06/SEC-04.

Consolidate behind an injected transport only when snapshots preserve each profile: exact method/path/query/headers/body/status/parser behavior, legacy empty bearer versus ApiClient conditional bearer/Accept, and current attempt semantics. Deduplicate user feedback with recovery tests. Establish operation-appropriate deadlines; timeout of a write means unknown outcome, not server rollback. No new retries on legacy calls, server cancellation endpoints, pagination or idempotency fields. NET-02 remains blocked on auth replay policy.

Exit: request/response parity for every affected caller, no unintended header/payload/attempt-count drift. Existing contract inconsistencies are documented, not normalized.

## Stage 5 — UI/UX, responsive layouts and navigation

Dependencies: baseline tests, UX-01/UX-07 investigations, supported-platform policy. Unrelated visual checks need not wait on blocked backend decisions.

Repair Add Bill through the approved existing journey while retaining actions/routes/arguments/back behavior. Validate all 36 named routes, 35 feature-screen files and auxiliary tariff/chart/forecast surfaces. Standardize existing tokens/components incrementally using actual screenshots and keyboard/assistive-technology evidence. Check narrow/landscape/enlarged-text dialogs, cards, tables and focus. Preserve Arabic/RTL, printed information and units; do not remove dense data or features to simplify layout. New field validation, role rules or native feature removal are not authorized.

Exit: recorded actual visual/interaction results; every existing journey remains reachable. Native print/chart work awaits UX-06 decision.

## Stage 6 — performance, automated QA and release readiness

Dependencies: stable correctness baseline, PERF-01 measurements, platform/signing decisions.

Profile synthetic datasets and optimize client rendering/index/image decoding only with unchanged output and measured before/after evidence. No API pagination/export endpoint changes. Establish CI with existing approved tooling, isolated fixtures and no package upgrades. Verify merged native artifacts/signing in an authorized environment. BUILD-01/03 require investigation; BUILD-02/UX-06 remain decision-gated. Document toolchain and preserve user lockfile changes instead of regenerating as housekeeping.

Exit: actual tests/builds/profiles with environment details; no unsupported production-ready assertion. Backend security/database performance remain outside scope.

## Recommended first authorized batch

First add baseline characterization/regression protection. Then implement **DATA-04 planning draft preservation, DATA-05 stable technology-bill draft identity and DATA-06 stale-response rejection**, with targeted tests preceding fixes and exact numerical/request parity. These high-impact client consistency issues are independent of blocked financial-rule corrections. If stable IDs are missing/unstable, block that subset instead of inventing an API identity contract.

SEC-04 and SEC-03 are the next security batch after session/HTML fixtures. UX-02/03/04 and UX-05 can run as independent small batches; they need not wait for HTTPS or billing policy. Each batch reports files, executed/not-executed tests, contract snapshots, preservation results and remaining blockers. Never count a safe subset as closure of a blocked original finding.

## Effect of approved decisions

The user clarified that current billing rules must remain and the system is internal. This does not unblock billing corrections, HTTPS, native parity or signing. Approved local authentication policy is included in Stage 3 and T-AUTH-01–06; it can be the first security batch after baseline/session fixtures. No implementation begins during Phase 0.
