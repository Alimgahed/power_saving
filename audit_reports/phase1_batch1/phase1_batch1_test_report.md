# Phase 1 — Batch 1 test report

Commands used `/Users/alimegahed/Documents/SDK/flutter/bin/flutter`, with `--no-pub`; mocks used synthetic tokens/data only. SDK cache writes required sandbox escalation and were approved. No production endpoints were called.

| Execution | Actual result | Evidence |
| --- | --- | --- |
| `flutter test --no-pub test/state_management/characterization_test.dart` before source edits | PASS, 4 tests | characterization_before.log |
| `flutter test --no-pub test/state_management test/auth_repository_test.dart` final | PASS, 36 tests (34 new, 2 existing) | targeted_tests.log |
| `flutter test --no-pub` | FAIL at discovery of existing test/widget_test.dart (no main); 36 executable tests passed | all_tests.log |
| `flutter analyze --no-pub` | Nonzero: 62 warning/info findings, zero errors | analyze.log |
| `flutter build web --no-pub --output /private/tmp/power-saving-batch1-web` | PASS, output compiled; Wasm dry run also succeeded | build_web.log |
| `git diff --check` | PASS | final shell verification |

The analyzer was run on implemented source. Every flagged source line exists in HEAD; no flagged source line was introduced by this batch. This is a line-level comparison, not a claim that a baseline analyzer execution occurred. Hash/scope evidence is in compatibility_checks.json.

Regression coverage includes warm reference cache, controller and cursor identity, dirty selections/year/increase/method, added/removed/restored place types; independent planning channels; old planning submissions; all six bill field owners; reorder/filter/delete/readd and controller disposal; history page/filter/cache ordering and loading; late 401 after newer result, disposal and token changes; replacement session service; exact operational POST body; successful save dialog and refresh; newer edits survive save completion; pending saves after disposal/session change.

An initial regression compilation attempt used await on Get.reset (void); the test was corrected. A save header assertion initially omitted the charset automatically appended by package:http; it was corrected to the existing actual request value application/json; charset=utf-8. Production wire behavior was not changed to satisfy tests. Final targeted log supersedes those intermediate failed attempts.

Tests are deterministic synthetic controller/transport tests plus a save-dialog widget test. They do not establish production server availability or native-platform support. No deployment was performed. The unrelated no-main test and existing analyzer warnings were deliberately left outside this batch.
