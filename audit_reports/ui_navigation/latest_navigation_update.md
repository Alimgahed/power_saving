# Navigation and shared app bars — latest requested scope

User requested no test runs for this update. No tests, analyzer, builds, authenticated screen visits, or business submissions were performed in this update.

## Changes
- `lib/core/widgets/app_toolbar.dart`: common gradient, 56px toolbar, centered title, white foreground, zero scroll elevation. Toolbar placement is LTR so navigation remains physically left; title/search/actions retain the surrounding text direction.
- `lib/core/widgets/app_back_button.dart`: fixed left-pointing arrow; existing stack pop and root fallback retained.
- `lib/core/widgets/custom_app_bar.dart`, `lib/core/widgets/main_screen/reuseable_appbar.dart`: use shared toolbar, retaining actions and search callbacks.
- `lib/core/widgets/app_scaffold.dart`: use shared bar with back and drawer access.
- `lib/features/home/view/widgets/home_app_bar.dart`, `lib/features/home/view/screens/home.dart`: shared dashboard header with menu access.
- `lib/features/tech_bills/view/screens/tech_bills.dart`: use shared searchable toolbar, retaining search callbacks.
- `lib/features/Ploitly.dart`, `lib/test.dart`: shared chart/gauge route headers.
- `lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart`: shared toolbar; print callback unchanged.
- `lib/features/reports/view/screens/report.dart`: shared fixed app bar; print callback, filters, report tables and export routines unchanged.
- `lib/features/bill/view/screens/bills.dart`: Add Bill previously used unregistered `/addBill`; now pushes registered `/Countrts`. Existing meter-specific “فاتورة جديدة” flow remains the entry to the actual bill form. Pushing retains the bill list for back navigation; no new route added.
- Existing assertions in `test/program/responsive_headers_test.dart` and `test/program/navigation_layout_consistency_test.dart` updated for fixed-left icon; NOT executed.

Prior working-tree form spacing changes were preserved.

## Evidence and limitations
Source inspection confirmed `/addBill` was absent from `lib/main.dart`, `/Countrts` is protected and has CounterBinding, and its meter cards already expose the bill creation workflow. This fixes the missing navigation target; it is not a claim that authenticated runtime behavior has been verified.

`git diff --check` passed. Dart formatter parsed the selected modified files; formatter analytics cleanup reported a sandbox permission failure writing outside the workspace. No successful analyzer/build/test claim is made. Existing screenshots and test logs in this directory predate this update and do not verify the final left-back design.

No API/controller/model/authentication, financial calculations, export generation, caching or dependencies were changed. UX-05 remains DEFERRED. Protected live verification remains blocked pending an authorized account/session.
