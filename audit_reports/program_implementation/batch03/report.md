# Program batch 03 — read response ownership

P-READ-01 / DATA-06 / LIFE-01: six read controllers applied responses and presented errors after closure; older responses could replace newer results. Reused existing RequestGuard, closed it with the controller, checked ownership after await/catch/finally and passed the existing local transport callback. No request cancellation or server mutation behavior changed. A superseding background read now retains responsibility for terminating a foreground read's loading indicator; a separate read-owned flag avoids claiming loading started only by an unrelated mutation.

Exact source files:
- `lib/features/Counter/controller/counter.dart` (`fetchAllCounters`)
- `lib/features/stations/controller/all_stations_controller.dart` (`getStations`)
- `lib/features/planning/controller/place/places_controller.dart` (`allPlaces`)
- `lib/features/home/controller/home.dart` (`home`)
- `lib/features/auth/controller/all_user.dart` (`loadUsers`)
- `lib/features/predaction/controller/prediaction.dart` (`prediactions`)

Test: `test/program/read_ownership_test.dart`. Baseline: 18 reproduced failures (latest result, closed success, closed error across six flows). Additional foreground/background characterization: 4 failures before loading handoff fix. Final combined: 168 passed. Analyzer: 59 existing diagnostics, no new findings. Web build passed (56.7s); `git diff --check` passed. Full isolated diff reviewed in `batch.diff`.

Tests assert exact GET paths `/gauges`, `/stations`, `/places`, base URL dashboard, `/all-users`; prediction remains POST `/prediction/7` with `{}`. Bearer headers unchanged. Models, status handling, active error text, sorting, filters, dashboard units and prediction mapping unchanged. Older data/errors are suppressed only when owner or request is obsolete. No cache or storage added. This is correctness/lifecycle evidence, no claimed timing speedup.

Remaining: prediction A-result displayed after a B-request failure is a separate labeling investigation (N07); read guards do not resolve it. Mutation completion, other form lookups and user-management optimistic workflows are not generalized by this batch. Next: confirmed exclusive resource cleanup and post-frame ownership, separately tested.
