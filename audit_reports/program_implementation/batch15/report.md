# Batch 15 — approved chemical mutation completion ownership

## Authorization and exact scope

User explicitly approved allowing dispatched chemical mutations to finish while suppressing UI side effects after controller disposal; active-owner behavior and the request contract must remain unchanged. Both add and edit were independently reproduced within this boundary. No other mutation workflow changed. UX-05 remains DEFERRED; profiling not started.

## Exact source/test files changed

- lib/features/chemcails/controller/add_chemacial.dart: six added lines, two per-operation existing transport liveness callbacks, two post-await disposal returns, two catch-path disposal returns.
- test/investigation/mutation_completion_test.dart: previous two current-behavior characterizations replaced with 28 acceptance regressions for the approved lifecycle behavior. Despite its historical directory name, this file now asserts the fixed behavior and is included in the combined suite.

Documentation: this report, batch.diff, test.diff, baseline snapshots/logs, compatibility.json; prior consolidated report and audit register updated to supersede the pending chemical decision. All unrelated pre-existing working-tree modifications preserved.

## Root cause and implementation

addchemicals and editchemicals unconditionally handled completion through global dialogs/navigation and, for add, loading updates even after GetX disposal. Transport 401/403 handling could itself redirect before the controller catch ran. The existing postData isCurrent callback is now supplied as !isClosed, preventing obsolete-owner transport side effects without changing the HTTP request. Post-await and catch guards prevent all local completion side effects once disposed.

No new request guard/latest-request suppression, retry, duplicate prevention policy, cancellation or resubmission introduced. The original request Future is awaited normally. While active, the existing 200 success path, non-200 handling, validation, messages, navigation and loading behavior are unchanged. Active 401/403 still clears the session and redirects through the existing transport mechanism. The disposed-owner callback applies the already-existing transport ownership hook; network/auth implementation and policies are not edited.

## Reproduction and test evidence

- Baseline before any changes: 235 passed (233 approved regression tests plus the former two mutation-characterization tests).
- Expanded tests before production fix: 14 active-owner cases passed; all 14 disposed-owner cases failed. Both add and edit reproduced the defect.
- Focused after fix: 28 passed.
- Matrix: add/edit × active/disposed × HTTP 200, 201, 400, 401, 403, 500 and thrown transport error.
- Each test asserts exact URL, POST, complete serialized fixture payload, JSON content type and Bearer header; exactly one mock request occurs and its awaited Future finishes. The in-memory mock has no real-network fallback.
- Disposed cases assert no route change, no popup-route creation, no open dialog, unchanged loading value and zero loading notifications, and unchanged token even on obsolete 401/403 responses.
- Active cases preserve success/failure routes and dialog creation/error text; 401/403 preserves logout. The odd existing 201 handling is intentionally preserved, not normalized.
- Combined final suite: **261 passed, zero failed**. Command: flutter test --no-pub test/session_security test/functional_reliability test/state_management test/auth_repository_test.dart test/lifecycle test/program test/security_encoding test/investigation.
- Flutter analyze: **53 pre-existing diagnostics, no errors**, exit 1; no new diagnostics.
- Flutter Web build passed in 37.6s; Wasm dry run succeeded (no full Wasm runtime claim). git diff --check passed; full six-line implementation diff and expanded test diff reviewed.

## Related-flow review and preservation

Chemical add and edit screen callbacks have no additional side effects after awaiting these controller methods. Existing chemical catalog and lookup reads already use request ownership; unchanged. The two chemical POST call sites are the only chemical mutation transports found by the current source search. No speculative changes to shared ownership or other features.

All 30 frozen contract files still match program-baseline hashes (compatibility.json), including network/repositories/models, financial controller, session/auth, routes and dependencies. Endpoint strings, methods, headers and reference.toJson payload construction remain identical. No backend changes, financial/business rules, authentication protocol, report output, API caching or dependencies changed. No business mutation sent during testing.

## Limits

Protected-screen live verification remains blocked without an authorized test session; this batch is mock/unit/widget evidence, not a live-backend exercise. Scope is completion after disposal, not changing which UI actions submit requests, overlapping active submissions or other feature workflows. The closed controller intentionally retains its last loading value because changing it would violate the approved no-state-update boundary; it is no longer an active screen owner.
