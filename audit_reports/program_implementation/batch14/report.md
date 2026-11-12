# Batch 14 — missing-argument navigation ownership

## Reproduction and smallest fix

Five edit screens scheduled redirects but could keep building null-dependent forms (four crash) or redirect after a newer route replaced them. The analysis screen could pop a newer route from its deferred missing-argument callback.

The existing fallback remains unchanged when the originating route is current. A mounted/current-route check blocks stale callbacks. Four edit views return an empty widget while their existing redirect is pending, avoiding null-dependent form construction. No new routes, argument mapping, valid-input fields, validation, permissions or API calls introduced.

## Exact files changed

- lib/features/planning/view/screens/places/edit_places.dart
- lib/features/stations/view/screens/edit_staion.dart
- lib/features/Counter/view/screens/edit_counter.dart
- lib/features/chemcails/view/screens/edit_chemcials.dart
- lib/features/technology/view/screens/edittech.dart
- lib/features/analysis/view/screen/analysis.dart
- test/program/missing_argument_navigation_test.dart (new, 12 regressions)
- test/investigation/mutation_completion_test.dart (new, two separate current-behavior characterizations; no mutation implementation changes)

Complete implementation diff: batch.diff, manually inspected. Resource/async inventory and ownership_assessment.md are audit evidence, not additional code edits.

## Actual verification

- Baseline: 221 tests passed.
- Initial five-screen test: 1 passed / 9 failed (null form construction and stale redirects).
- Analysis sibling baseline: 1 passed / 1 failed (newer route popped).
- Final approved suite: 233 passed / 0 failed, including all 12 new route cases and prior valid-route/session/report tests.
- Separate in-memory mutation characterization: 2 passed / 0 failed, confirming late success redirect and late error dialog after disposal. These do not assert a fix and send no backend request.
- Flutter analyze: 53 existing diagnostics, no errors, exit 1. No new diagnostics.
- Flutter Web build: passed, 62.4s. Wasm dry run succeeded; no full Wasm runtime claim.
- git diff --check: passed.
- All 30 frozen contract files still match the program baseline. No network/model/repository/financial/session/dependency changes. Complete source patch only changes missing-argument branch behavior; valid forms and request construction untouched.

No business data caching, backend modifications, business mutations, auth bypass or personal credentials. UX-05 remains DEFERRED. Protected live verification remains blocked. Mutation suppression needs the explicit workflow decision requested from the user; no speculative fix applied. Performance phase not started.
