# Shared drawer access across application screens

Requested scope: direct cross-screen navigation from every authenticated screen; preserve business behavior and permissions. Previous instruction not to run tests retained.

Implemented:
- AppToolbar detects the surrounding Scaffold drawer and renders one common menu button. Back remains physically left, menu right. Custom/search/report bars inherit this behavior.
- AppScaffold and RTLScaffold provide the existing HomeDrawer only for authenticated sessions. Public registration remains public, with no authenticated menu for anonymous users.
- Enabled existing drawer on following stations, technology invoice details and place types.
- Added the existing drawer to plain Scaffold pages: Charts (the actual economic-analysis drawer destination), Places, balance print preview, local forecast results and the registered gauge page. Forecast results now have a shared app bar without altering result data or pagination.
- Removed manual menu buttons from the default scaffold header, HomeAppBar and technical-office bar to avoid duplicate buttons.
- Drawer selections close the drawer before executing existing actions. Home selection now navigates to /home instead of only closing the drawer. Home is no longer highlighted on every screen.
- Converted drawer destination strings beginning './' to their existing registered absolute route names. No new routes or permission mappings.

Files changed in this increment:
lib/core/widgets/app_toolbar.dart
lib/core/widgets/app_scaffold.dart
lib/core/widgets/rtl_scafold.dart
lib/features/home/view/widgets/home_app_bar.dart
lib/features/home/view/widgets/home_drawer.dart
lib/features/tech_bills/view/screens/tech_bills.dart
lib/features/stations/view/screens/following_stations.dart
lib/features/bill/view/screens/Tech_bills.dart
lib/features/planning/view/screens/places/place_types_list_screen.dart
lib/features/planning/view/screens/places/places.dart
lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart
lib/features/planning/view/screens/blance_chart/ml_forecast_result_screen.dart
lib/features/Ploitly.dart
lib/test.dart

Review: source inspection and git diff --check completed. Formatter parsed 11 selected files in output=none mode, then failed writing its analytics metadata outside the sandbox; this was not a clean command success. No tests, analyzer, builds, live authenticated checks or business submissions run. No performance timing measurements taken or speed-up claimed.

Navigation intentionally retains existing push/back behavior and Get's current-route duplicate prevention. No aggressive stack clearing/replacement: those could discard draft form state or controllers needed by another screen. No data caching, API changes, financial changes, new dependencies, or authentication policy changes. UX-05 remains deferred. Compact-width rendering of action-heavy bars and authenticated runtime navigation still need live verification; no claim of 100% correctness/performance.
