# Program batch 01 — owned search debounce

Addressed P-LIFE-01 / LIFE-01. GetX 4.7.3 `debounce` disposes the stream subscription but leaves an already scheduled Debouncer timer alive. Eight controller tests reproduced post-close search/filter/pagination changes. Added `lib/core/utils/owned_debounce.dart` to own both subscription and timer; existing `Worker.dispose` now closes both. No callback runs after disposal.

Changed controllers (one import and function-name replacement each):
- `lib/features/Counter/controller/counter.dart`
- `lib/features/stations/controller/all_stations_controller.dart`
- `lib/features/planning/controller/place/places_controller.dart`
- `lib/features/chemcails/controller/chemacial.dart`
- `lib/features/relations/controller/relations/relation.dart`
- `lib/features/technology/controller/technlogy.dart`
- `lib/features/bill/controller/all_bills.dart`
- `lib/features/bill/controller/tech_bills.dart`

Added test: `test/program/debounce_lifecycle_test.dart` (16 cases). Existing active delays remain 300ms, or 500ms for technology bill history. Filtering, pagination callback bodies, all requests/serializers and business formulas are unchanged; full isolated diff in `batch.diff`. No data caching.

Results: baseline 117 passed; before fix 8 passed / 8 failed; focused after fix 16 passed; combined 133 passed; analyzer 59 pre-existing diagnostics; Web build passed (355.3s), wasm dry run succeeded; `git diff --check` passed. Initial analyzer run included two diagnostics from archived source copies; renamed those copies `.dart.before`, final result returned to baseline. No production warning was suppressed.

Evidence is callback cancellation, not a measured heap/frame-rate claim. RequestGuard and session protections unchanged. Remaining work: ownership of other resources and async reads; UI responsiveness requires separate runtime tests. Next batch: confirmed shared-header overflow and accessible back action, with title/action preservation.
