# Program batch 05 — recoverable station lookups

N22 / REL-01 / DATA-06. FollowingStationsController let failed reads escape its unawaited onInit; AddStationController silently swallowed branch/source failures. Added independent loading, error and empty-result presentation plus retry buttons; preserved forms/selections, existing HTTP requests, success parsing and mutation behavior. Added RequestGuard ownership for those two lookup operations. Existing area lookup and addStation POST are untouched.

Exact source files: `lib/features/stations/controller/following_stations_controller.dart`, `lib/features/stations/controller/add_stations_controller.dart`, `lib/features/stations/view/screens/following_stations.dart`, `lib/features/stations/view/screens/add_station.dart`. Test: `test/program/lookup_error_test.dart`.

Initial reproductions: both error/retry tests failed. The default tablet-sized add form also exposed dropdown overflow; documented and isolated in batch06, lookup UI tests use 1440px. Final four focused cases cover retry buttons → unchanged GET requests → empty-success state, retained name input and closed-owner response rejection. Combined 175 passed (excluding the staged failing batch06 characterization). Analyzer 59 existing diagnostics; Web build passed 44.2s; diff check passed. Full diff reviewed in `batch.diff`.

Requests remain GET `/station-techs` and GET `/new-station`. No new payload, status interpretation, default values, selection reset or automatic retry. API models/serializers, all validation and POST submission code remain byte-identical. No data cache. No latency/heap speedup claim. Next: isolated shared dropdown sizing fix; other lookup/mutation ownership requires separate evidence.
