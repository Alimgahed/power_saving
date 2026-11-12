# Refresh-safe app-bar back navigation

Scope: user authorized fallback to home on every protected screen when no previous page exists, without running tests.

Changed this increment:
- lib/core/widgets/app_back_button.dart: await maybePop rather than selecting behavior solely using canPop. Fall back only if the back request is unhandled. Respect handled/vetoed requests, guard repeated clicks, and check mounted/current-route ownership after awaiting. Default destination is /home.
- lib/core/widgets/custom_app_bar.dart: protected screens use /home at root; public registration preserves /Login. Use the actual Navigator route and pushReplacementNamed instead of relying on Get.currentRoute duplicate suppression.
- lib/core/widgets/main_screen/reuseable_appbar.dart: searchable list bars use the same direct root replacement to /home.
- lib/features/reports/view/screens/report.dart: uses the common default fallback.

Existing screen stacks still pop normally. Named navigation still uses the application's registered route generator and authentication middleware. No API, business, report export, authentication policy, cache or dependency changes. Previous work retained; UX-05 deferred.

Source review and git diff --check completed. No tests, analyzer, build, live authenticated verification or business mutations performed. The exact runtime cause of the user's no-op was not reproduced; these changes address the identified unhandled-back and missing/default-fallback paths, not a claim of proven runtime resolution.
