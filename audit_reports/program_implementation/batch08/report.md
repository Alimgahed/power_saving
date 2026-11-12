# Program batch 08 — form lookup lifecycle

P-READ-01 / DATA-06 / LIFE-01. Nine form owners still displayed lookup-error dialogs after their screens closed. Added operation-specific RequestGuards to ten remaining GET lookup methods; separate branch/area guards avoid invalidating unrelated lookups. All mutation methods, initialization values, model parsing and active error messages remain unchanged.

Exact source files:
- `lib/features/Counter/controller/add_counter_controller.dart` / `edit_counter_controller.dart`: allVoltige
- `lib/features/planning/controller/place/add_places_controller.dart` / `edit_places_controller.dart`: allNewData
- `lib/features/planning/controller/place/edit_place_type_controller.dart`: fetchPlaceTypes
- `lib/features/stations/controller/add_stations_controller.dart`: allareas
- `lib/features/stations/controller/edit_stations_controller.dart`: allBranches + allareas
- `lib/features/relations/controller/add_relations_controller.dart`: new_relations
- `lib/features/chemcails/controller/add_chemacial.dart`: getchemicals

Test `test/program/form_lookup_ownership_test.dart`: nine failures before fix → nine passes. Combined non-security suite: 193 passed. Analyzer: 59 existing diagnostics (one staged SEC-03 test-literal notice corrected before final analysis). Web build passed (108.0s); diff check passed. Full diff reviewed in `batch.diff`. All GET paths, empty bodies and bearer headers preserved; response mapping branches and POST methods unchanged. No caching, cancellations or automatic write retries added. No performance claim.

Remaining: mutation completion/navigation ownership and billing-related controller replacement require their own workflow-specific evidence. Next: user-authorized SEC-03 HTML encoding; UX-05 remains deferred.
