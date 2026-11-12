# Phase 1 — Batch 1 implementation report

Completed 2026-11-11 against master / bf78471. Scope: DATA-04, DATA-05, DATA-06 and directly related stale lifecycle effects only. Phase 0 documents and current working tree were verified before changes; source matched the preparation baseline. Existing pubspec.lock modifications were retained byte-for-byte. No commits, resets, dependency upgrades, backend changes or later batches were performed.

## Source changes

| File | Finding and change |
| --- | --- |
| lib/core/utils/request_guard.dart (new) | DATA-06: per-owner generation tickets, disposal and token/cached-user/session identity checks prevent obsolete responses from committing. No HTTP cancellation or wire changes. |
| lib/features/planning/controller/blance_chart/blance_chart.dart | DATA-04/06: retain text controllers by placeTypeId during cache/network refresh; initialize only new IDs. Separate area, type and submit generations; guard result navigation, including delayed navigation. Retain selected area and draft values. |
| lib/features/planning/view/screens/blance_chart/blance.dart | DATA-04: bind existing selected area and retain a disabled display item if reference refresh removes that selection; new available choices still update. |
| lib/features/tech_bills/controller/techbills.dart | DATA-05/06: active operational implementation now owns six draft maps and form keys by techBillId instead of list index. Dispose removed records' fields. Guard reads/saves, invalidate earlier reads when saving, preserve edits made while saving, and avoid recreating removed drafts on save completion. |
| lib/features/tech_bills/view/screens/tech_bills.dart | DATA-05: pass domain ID to all fields, form keys and save/loading state; key cards by bill ID. Same validators, parsing and six save values. |
| lib/features/bill/controller/all_bills.dart | DATA-06: latest generation plus query identity controls response/cache/error/loading commits; disposal invalidates requests. |
| lib/features/bill/controller/tech_bills.dart | DATA-06: same protection for technology history; retain and dispose the existing debounce worker. |
| lib/network/network.dart | DATA-06: optional local ownership callback prevents obsolete 401/403 responses from clearing the current token or navigating. Existing callers and current responses retain original transport/authentication behavior. No consolidation. |

## Root causes and handling

Planning refresh recreated every editing controller, losing text and selection. It now reconciles reference IDs and retains drafts. Removed place-type drafts remain owned until the screen closes and are restored if that ID reappears; they are excluded from payload while absent from active reference data. Removed area selection stays visible without silently choosing a different area or clearing increase values.

Operational Technology Bills indexed drafts by mutable list position. Drafts now follow the same techBillId already used by the existing save endpoint. Filtering does not dispose drafts; actual removal from refreshed source data does. Reappearing deleted bills get fresh empty drafts. The legacy nested technology controller remains untouched.

Affected asynchronous calls committed regardless of order/lifecycle. Guards reject superseded requests before parsing, cache writes, state changes, dialogs and navigation. Independent planning reference channels do not suppress each other. History additionally checks query identity, including debounce gaps. Cached results remain immediate and refresh is still initiated; returned refresh futures now include their background request completion.

## Tests

| Added file | Purpose |
| --- | --- |
| test/state_management/fixtures.dart | Synthetic reference/bill/page fixtures and controllable MockClient requests. |
| test/state_management/characterization_test.dart | Four established behavior tests added and passed before production edits: planning payload/numbers, operational filtering/field reuse, both history request/response mappings and page totals. |
| test/state_management/regression_test.dart | Thirty regressions: dirty text/selection, reference addition/removal/restoration, independent channels, A/B ordering, ID ownership across filtering/reorder/removal, resource disposal, pagination/filter/cache races, obsolete auth errors, session/disposal changes, exact save body and successful save/newer edit behavior. |

Verification: 36 runnable tests passed (34 new plus 2 existing); web build passed. Analyzer completed with 62 existing-line findings and no errors. Full-suite discovery fails on pre-existing commented-out test/widget_test.dart with no main; it was not altered. See the test report and retained logs.

## Remaining limitations and blockers

No implementation blocker remains for this batch. Full-suite green status is blocked by the unrelated empty widget test entry point. Analyzer cleanup is outside scope. No production API, manual end-to-end session, native-platform or live-data test was performed. Stable draft ownership uses the existing domain identifier; missing/duplicate server IDs are not assigned invented identities or new response parsing rules. Static cache partitioning/auth policy hardening, other findings, and legacy removal remain outside this batch. Requests already sent can still execute on the server; guards govern local response effects only. Session detection uses existing observable identity/token state, not an invented server revocation protocol.

No deviation from authorized remediation scope. The transport callback is narrowly required to prevent stale callers from changing session/navigation before controller guards can run. Stop here; later batches require explicit approval.
