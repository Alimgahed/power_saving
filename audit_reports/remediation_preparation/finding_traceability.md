# Finding traceability — Phase 0

All 30 original finding IDs are retained. READY means eligible for a future authorized batch, not authorized now. BLOCKED takes precedence if closing a finding requires a frozen-domain/contract change. REQUIRES INVESTIGATION means local evidence or runtime compatibility is insufficient. No remediation has been implemented.

The seven reports contain 30 uniquely numbered findings plus unnumbered recommendations. The supplementary register below carries those narrative observations without inventing original severities or inflating the 30-finding total.

| Finding | Original severity | Evidence classification | Status | Dependencies |
|---|---|---|---|---|
| SEC-01 | High | Confirmed insecure configuration | BLOCKED | Q-HTTPS |
| SEC-02 | High | Confirmed unsafe sink; exploit conditional | BLOCKED | Q-CHART, SEC-01 |
| SEC-03 | High | Confirmed output-encoding gap; exploit conditional | READY | BASE, API-FREEZE |
| SEC-04 | High | Confirmed cache isolation gap; exposure conditional | READY | BASE, QA-01 |
| SEC-05 | Medium | Confirmed fail-open client default | READY | BASE, APPROVED-AUTH, QA-01 |
| SEC-06 | Medium | Architectural weakness | READY | BASE, APPROVED-AUTH, SEC-04, SEC-05 |
| DATA-01 | High | Confirmed arithmetic defect | BLOCKED | Q-BILL, BASE |
| DATA-02 | High | Confirmed lifecycle/data-flow defect | BLOCKED | Q-BILL, LIFE-01 |
| DATA-03 | Medium | Confirmed missing dependency | BLOCKED | Q-BILL, DATA-02 |
| UX-01 | Medium | Confirmed navigation defect | REQUIRES INVESTIGATION | BASE, Q-NAV |
| UX-02 | Medium | Confirmed reactive wiring defect | READY | BASE |
| UX-03 | Medium | Confirmed loading-state defect | READY | BASE, DATA-06 |
| UX-04 | Medium | Confirmed assignment defect | READY | BASE |
| REL-01 | Medium | Confirmed error-state gap | READY | BASE, DATA-06 |
| DATA-04 | High | Confirmed destructive refresh behavior; timing-dependent | READY | BASE |
| DATA-05 | High | Potential data-association defect | READY | BASE, DATA-06 |
| DATA-06 | Medium | Potential asynchronous race | READY | BASE, API-FREEZE |
| DATA-07 | Medium | Confirmed partial-report behavior | BLOCKED | Q-REPORT, BASE |
| UX-05 | Low | Confirmed reporting inconsistency | READY | BASE |
| ARCH-01 | Medium | Architectural weakness | REQUIRES INVESTIGATION | API-FREEZE, QA-01 |
| NET-01 | Medium | Confirmed missing control | REQUIRES INVESTIGATION | API-FREEZE, ARCH-01 |
| NET-02 | Medium | Potential mutation replay | BLOCKED | Q-AUTH, API-FREEZE |
| PERF-01 | Medium | Static performance opportunity | REQUIRES INVESTIGATION | BASE, QA-01 |
| LIFE-01 | Medium | Confirmed cleanup omissions; runtime impact unmeasured | READY | BASE |
| BUILD-01 | High | Confirmed source configuration gaps; release outcome unverified | REQUIRES INVESTIGATION | Q-PLATFORM, API-FREEZE |
| BUILD-02 | Medium | Confirmed release configuration weakness | BLOCKED | Q-SIGNING |
| QA-01 | High | Confirmed assurance gap | READY | BASE |
| UX-06 | Medium | Confirmed platform feature gap | BLOCKED | Q-PLATFORM, Q-CHART |
| UX-07 | Low | Confirmed unused extension hook | REQUIRES INVESTIGATION | BASE, Q-VALIDATION |
| BUILD-03 | Low | Confirmed asset reference defects | REQUIRES INVESTIGATION | Q-ASSETS |

## SEC-01: Credentials and authenticated requests use HTTP

**Original severity:** High. **Status:** BLOCKED. **Evidence:** Confirmed insecure configuration.

**Exact source/symbol anchors:** [lib/global/ip_config.dart:19](/Users/alimegahed/power_saving/lib/global/ip_config.dart:19) (`static String get baseUrl`); [lib/features/auth/data/repositories/auth_repository_impl.dart:5](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:5) (`/login`); [lib/network/network.dart:20](/Users/alimegahed/power_saving/lib/network/network.dart:20) (`'Authorization'`)

**Root cause:** Every baseUrl branch selects http://. Login serializes username/password into the request; both clients attach bearer tokens to subsequent requests. No transport upgrade is implemented in the client.

**User impact:** An observer or active attacker on the network path can read or alter traffic where these endpoints are reachable. HTTPS hosting also risks blocked mixed-content API calls. Actual interception and production deployment were not tested.

**Dependencies:** Q-HTTPS

**Proposed client-side work:** Document the HTTP exposure; no endpoint substitution in this program. Prepare an external owner decision only.

**Backend/business dependency and gate:** HTTPS requires a different approved endpoint/server TLS configuration; both are frozen.

**Regression tests:** In a non-production environment, inspect login and authenticated requests and confirm HTTPS-only operation, including LAN and native targets.

**Acceptance:** In a non-production environment, inspect login and authenticated requests and confirm HTTPS-only operation, including LAN and native targets. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## SEC-02: Server HTML executes in an unsandboxed chart frame

**Original severity:** High. **Status:** BLOCKED. **Evidence:** Confirmed unsafe sink; exploit conditional.

**Exact source/symbol anchors:** [lib/global/iframe_web.dart:15](/Users/alimegahed/power_saving/lib/global/iframe_web.dart:15) (`..srcdoc = htmlContent`); [lib/controller/voltage/financial.dart:27](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:27) (`waterChartHtml =`)

**Root cause:** financialAnalysis reads water_chart from the API and registerIframe assigns it directly to IFrameElement.srcdoc without sandbox restrictions. The chart HTML is treated as executable content.

**User impact:** A party able to alter that HTML response, including an active attacker on the configured HTTP path, can inject browser script into the frame. Same-origin privileges and token exposure depend on deployment/CSP and browser behavior; no exploit was run.

**Dependencies:** Q-CHART, SEC-01

**Proposed client-side work:** Inventory chart capabilities and offline fixtures; design isolation only after a compatible approved contract exists.

**Backend/business dependency and gate:** Chart HTML is executable by design. Sandbox/origin changes could disable existing chart scripts, downloads or interaction; chart capability/security contract is unknown.

**Regression tests:** Use an inert marker fixture and a controlled local security test to verify frame isolation, parent DOM access restrictions, and storage boundaries.

**Acceptance:** Use an inert marker fixture and a controlled local security test to verify frame isolation, parent DOM access restrictions, and storage boundaries. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## SEC-03: Report data is interpolated into executable HTML

**Original severity:** High. **Status:** READY. **Evidence:** Confirmed output-encoding gap; exploit conditional.

**Exact source/symbol anchors:** [lib/features/reports/view/widgets/branch_report.dart:60](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:60) (`${b.branchName}`); [lib/features/reports/view/screens/report.dart:836](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:836) (`final rows =`); [lib/global/html_web.dart:13](/Users/alimegahed/power_saving/lib/global/html_web.dart:13) (`html.Blob`)

**Root cause:** BranchReportPrinter.rowCells inserts branchName into <td> markup without escaping. BaseReportPrinter also inserts the cached employee name and form text into HTML, then openHtmlReport opens a text/html Blob. Other report/plan printers use the same interpolation approach.

**User impact:** HTML-like data can change the printed document. Script execution is possible if attacker-controlled strings reach these fields; server-side validation, actual stored malicious data and browser exploitability were not inspected.

**Dependencies:** BASE, API-FREEZE

**Proposed client-side work:** Escape all text at the HTML boundary; allow only intentional template markup. Avoid raw HTML-returning cell APIs and validate image URL/base64 contexts separately.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Generate local reports containing &, <, >, quotes, Arabic names, and inert HTML tags; verify literal text, unchanged structure and no executable user content.

**Acceptance:** Generate local reports containing &, <, >, quotes, Arabic names, and inert HTML tags; verify literal text, unchanged structure and no executable user content. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## SEC-04: Logout leaves static data caches available to the next account

**Original severity:** High. **Status:** READY. **Evidence:** Confirmed cache isolation gap; exposure conditional.

**Exact source/symbol anchors:** [lib/features/home/view/widgets/enterprise_sidebar.dart:172](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:172) (`Future<void> _handleLogout`); [lib/global/data.dart:27](/Users/alimegahed/power_saving/lib/global/data.dart:27) (`void clear()`); [lib/features/auth/controller/all_user.dart:10](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:10) (`static List<dynamic>? sessionCache`)

**Root cause:** Logout clears preferences and SessionService lists/user, but the static caches in user, station, meter, bill, relation, chemical and planning controllers remain. Cache-first loaders display those records before background authorization completes. Outstanding requests have no session-generation check.

**User impact:** On a shared browser/app process, a subsequent account can see prior-account cached records on accessible screens; authorization failure does not undo the initial display. Severity depends on whether accounts have different data entitlements. A late prior-session response can repopulate a cleared cache.

**Dependencies:** BASE, QA-01

**Proposed client-side work:** Scope repositories/caches to authenticated identity, clear all session data atomically, cancel or reject old-session responses, and avoid displaying unauthorized stale data.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** With fake responses, sign in as A, warm caches, log out, sign in as B with narrower permissions, and verify no A data appears even when delayed A responses finish.

**Acceptance:** With fake responses, sign in as A, warm caches, log out, sign in as B with narrower permissions, and verify no A data appears even when delayed A responses finish. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## SEC-05: Missing role data defaults to the administrator group

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed fail-open client default.

**Exact source/symbol anchors:** [lib/features/auth/model/login.dart:24](/Users/alimegahed/power_saving/lib/features/auth/model/login.dart:24) (`groupId: json['group_id']??1`); [lib/features/home/view/widgets/enterprise_sidebar.dart:123](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:123) (`if (_hasAccess([1]))`)

**Root cause:** User.fromJson assigns group 1 when group_id is absent/null; group 1 enables user administration menu items. Cached User data is restored without server revalidation at startup.

**User impact:** Malformed or stale user payloads receive administrator UI visibility. This does not establish backend privilege escalation; API role enforcement is unavailable for review.

**Dependencies:** BASE, APPROVED-AUTH, QA-01

**Proposed client-side work:** Validate raw login/restored identity at the session boundary before User.fromJson/admin fallback or persistence. Reject missing/null/invalid group_id, clear invalid session, and show a friendly login message. Use only recognized IDs represented by current source (1–7); preserve all valid-user role behavior and wire/parser mappings.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Parse a user without group_id and confirm no privileged menus/actions are enabled. Separately test server authorization with role-specific credentials in an authorized environment.

**Acceptance:** Parse a user without group_id and confirm no privileged menus/actions are enabled. Separately test server authorization with role-specific credentials in an authorized environment. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## SEC-06: Session validity and authorization are not enforced at route boundaries

**Original severity:** Medium. **Status:** READY. **Evidence:** Architectural weakness.

**Exact source/symbol anchors:** [lib/main.dart:115](/Users/alimegahed/power_saving/lib/main.dart:115) (`initialRoute: user != null`); [lib/features/home/view/widgets/navigation_helper.dart:11](/Users/alimegahed/power_saving/lib/features/home/view/widgets/navigation_helper.dart:11) (`if (user != null)`); [lib/network/network.dart:30](/Users/alimegahed/power_saving/lib/network/network.dart:30) (`remove('token')`)

**Root cause:** Routes have no authentication/role middleware. Navigation checks rely on cached user presence and menu visibility. 401/403 handlers remove token but leave cached/in-memory user; 403 is treated as expired authentication. Password-change success navigates to login without clearing session.

**User impact:** Direct route navigation bypasses menu restrictions, and reload can restore /home with no valid token. Forbidden actions can unnecessarily log out otherwise valid users. Backend data access remains unverified.

**Dependencies:** BASE, APPROVED-AUTH, SEC-04, SEC-05

**Proposed client-side work:** Keep public registration accessible. Guard protected routes against invalid local sessions without inventing group restrictions for valid users. After successful password change retain session/navigation when existing token remains valid; handle later existing auth errors without new protocol or token-rotation assumptions. No extra startup API request or generalized 403 policy change.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Exercise absent/expired token, 403, password change, reload and direct navigation to every privileged route; verify coherent state and correct forbidden handling.

**Acceptance:** Exercise absent/expired token, 403, password change, reload and direct navigation to every privileged route; verify coherent state and correct forbidden handling. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-01: Meter rollover undercounts consumption by one reading unit

**Original severity:** High. **Status:** BLOCKED. **Evidence:** Confirmed arithmetic defect.

**Exact source/symbol anchors:** [lib/features/bill/controller/bills.dart:152](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:152) (`readingDiff = (rolloverValue-1`); [lib/features/bill/controller/bills.dart:133](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:133) (`calculatedConsumption.value =`)

**Root cause:** Bills._calculateReadingDifference subtracts 1 from the wrap modulus. For a four-digit meter changing 9999 to 0, it calculates 0 rather than 1; 9998 to 2 gives 3 rather than 4. Consumption is then multiplied by the reading factor. The modulus is inferred from the previous reading digit count rather than meter metadata.

**User impact:** Bills around rollover understate consumption by one unit times the factor. Incorrectly inferred meter width and treating all decreases as rollovers add a separate domain risk.

**Dependencies:** Q-BILL, BASE

**Proposed client-side work:** Write characterization tests for the exact current expression, explicitly label known discrepancy; do not fix it.

**Backend/business dependency and gate:** Correcting the rollover expression changes a business formula. Preserve the current result even when mathematically suspicious until owner-approved examples authorize a later exception.

**Regression tests:** Add boundary cases for maximum→0, maximum−1→2, unchanged reading, normal increment, factor >1 and invalid decreases. Confirm results with the billing domain owner.

**Acceptance:** Add boundary cases for maximum→0, maximum−1→2, unchanged reading, normal increment, factor >1 and invalid decreases. Confirm results with the billing domain owner. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-02: Billing dialog replaces controllers that hold calculation listeners

**Original severity:** High. **Status:** BLOCKED. **Evidence:** Confirmed lifecycle/data-flow defect.

**Exact source/symbol anchors:** [lib/features/Counter/view/screens/Counter.dart:329](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:329) (`Get.put(Bills()).onInit()`); [lib/features/Counter/view/screens/Counter.dart:390](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:390) (`.briefReadingController =`); [lib/features/Counter/view/screens/Counter.dart:409](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:409) (`.readingFactorController =`); [lib/features/bill/controller/bills.dart:88](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:88) (`void _setupListeners()`)

**Root cause:** Opening a bill manually calls onInit on the GetX-managed controller. The dialog builder then replaces briefReadingController and readingFactorController after _setupListeners attached callbacks to their prior instances. It also creates controllers during build.

**User impact:** Editing the displayed previous reading or factor alone no longer triggers its intended recalculation; totals may remain stale until another watched field changes. Repeated dialog opens/rebuilds abandon controllers and can reset edits.

**Dependencies:** Q-BILL, LIFE-01

**Proposed client-side work:** Characterize listener lifecycle and draft values first; separate resource disposal from any observable calculation change.

**Backend/business dependency and gate:** Reconnecting inputs changes when financial values recalculate. Pure disposal can be separated, but the finding cannot be closed under an unapproved financial-behavior change.

**Regression tests:** Open a bill, change only factor and then only previous reading, verify consumption/total change immediately, and repeat open/close/rebuild while preserving draft edits.

**Acceptance:** Open a bill, change only factor and then only previous reading, verify consumption/total change immediately, and repeat open/close/rebuild while preserving draft edits. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-03: Rounding and manual consumption edits do not recompute totals

**Original severity:** Medium. **Status:** BLOCKED. **Evidence:** Confirmed missing dependency.

**Exact source/symbol anchors:** [lib/features/bill/controller/bills.dart:88](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:88) (`void _setupListeners()`); [lib/features/bill/controller/bills.dart:187](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:187) (`final rounding =`); [lib/features/Counter/view/screens/Counter.dart:700](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:700) (`billsController.roundingController,`)

**Root cause:** _calculateTotal reads roundingController and powerConsumpController, but neither is listened to by _setupListeners. Both are editable form fields. Submission serializes their current values alongside billTotalController, which may reflect an older calculation.

**User impact:** A bill can contain a rounding/consumption value inconsistent with its submitted total. Whether the backend recomputes totals is unknown.

**Dependencies:** Q-BILL, DATA-02

**Proposed client-side work:** Characterize stale-total behavior and freeze submission values; await approval for recalculation changes.

**Backend/business dependency and gate:** Adding recalculation dependencies or submit-time recomputation changes financial results/timing; requires authoritative rounding and editable-consumption rules.

**Regression tests:** Change rounding as the last field before submitting and compare displayed total, payload, and expected arithmetic; repeat for manually entered consumption.

**Acceptance:** Change rounding as the last field before submitting and compare displayed total, payload, and expected arithmetic; repeat for manually entered consumption. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-01: Add Bill action targets an unregistered route

**Original severity:** Medium. **Status:** REQUIRES INVESTIGATION. **Evidence:** Confirmed navigation defect.

**Exact source/symbol anchors:** [lib/features/bill/view/screens/bills.dart:144](/Users/alimegahed/power_saving/lib/features/bill/view/screens/bills.dart:144) (`Get.offNamed('/addBill')`); [lib/main.dart:116](/Users/alimegahed/power_saving/lib/main.dart:116) (`getPages:`)

**Root cause:** The Bills screen exposes an Add Bill button pointing to /addBill. No matching GetPage, alternate route handler, or unknownRoute implementation appears in main.dart. The implemented new-bill journey lives in the meter card dialog.

**User impact:** Users starting from bill history reach an unresolved navigation destination instead of creating a bill. Exact GetX error/fallback presentation was not executed.

**Dependencies:** BASE, Q-NAV

**Proposed client-side work:** Link the action to the existing meter-selection/billing flow or register a dedicated bill creation route with required arguments.

**Backend/business dependency and gate:** Identify the intended existing meter-selection→bill journey and argument/back-stack expectations before wiring the absent route; do not remove the action.

**Regression tests:** Traverse every visible navigation action and compare static route names; then perform an offline widget navigation test for Add Bill.

**Acceptance:** Traverse every visible navigation action and compare static route names; then perform an offline widget navigation test for Add Bill. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-02: Technology-bill text search does not react to text edits

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed reactive wiring defect.

**Exact source/symbol anchors:** [lib/features/tech_bills/controller/techbills.dart:133](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:133) (`ever(searchController.obs`); [lib/features/tech_bills/controller/techbills.dart:153](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:153) (`searchController.text = value`); [lib/features/tech_bills/view/screens/tech_bills.dart:48](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:48) (`controller.onSearchChanged(value)`)

**Root cause:** The search worker observes an Rx wrapper around a TextEditingController instance. onSearchChanged mutates its .text rather than the observed Rx value; no text listener or direct applyFilters call is attached to the edit path.

**User impact:** Typing a query leaves results unchanged until another action invokes applyFilters, such as changing a branch filter.

**Dependencies:** BASE

**Proposed client-side work:** Observe an RxString query or register/dispose a text listener and debounce that query. Avoid rewriting the text value from its own onChanged callback.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Type an unmatched term without changing another filter and verify an empty-result state after the debounce; clear it and verify restored records.

**Acceptance:** Type an unmatched term without changing another filter and verify an empty-result state after the debounce; clear it and verify restored records. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-03: Cached refresh can leave catalog spinners permanently active

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed loading-state defect.

**Exact source/symbol anchors:** [lib/features/chemcails/controller/chemacial.dart:108](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:108) (`Future<void> forceRefresh()`); [lib/features/relations/controller/relations/relation.dart:111](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:111) (`Future<void> forceRefresh()`); [lib/features/technology/controller/technlogy.dart:175](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:175) (`Future<void> forceRefresh()`)

**Root cause:** These refresh methods set a loading flag then invoke cache-first loading. With a warm cache, the loader returns before clearing that flag, and the background branch intentionally does not clear foreground loading. Chemical/relation refresh wrappers also return before their asynchronous loads finish.

**User impact:** Refreshing a previously loaded catalog can leave its loading UI active even when new data arrives. StationsController has a finally covering its cache branch, so the same permanent-spinner claim is not made for stations.

**Dependencies:** BASE, DATA-06

**Proposed client-side work:** Separate force-refresh from cache-first load, await the real request, and guarantee loading reset in finally for the owner of the flag.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Warm each cache, refresh successfully and with a failed response, and assert the refresh Future and spinner finish in both cases.

**Acceptance:** Warm each cache, refresh successfully and with a failed response, and assert the refresh Future and spinner finish in both cases. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-04: Registration loading state never changes

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed assignment defect.

**Exact source/symbol anchors:** [lib/features/auth/controller/new_user.dart:47](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:47) (`isLoading.value==true`); [lib/features/auth/view/screens/new_user.dart:193](/Users/alimegahed/power_saving/lib/features/auth/view/screens/new_user.dart:193) (`onTap: () {`)

**Root cause:** NewUsercontroller.new_user uses equality comparisons instead of assignments for all loading changes. The form submit InkWell remains enabled; password-change submit likewise remains actionable while showing a spinner.

**User impact:** No registration progress state is shown and repeated taps can send duplicate requests. Backend duplicate protection is unknown.

**Dependencies:** BASE

**Proposed client-side work:** Assign loading state correctly, reject reentrant submissions at controller level, and disable submit interaction while awaiting completion.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Use a delayed fake registration/password request and tap repeatedly; expect one in-flight operation and an accurate completion/error state.

**Acceptance:** Use a delayed fake registration/password request and tap repeatedly; expect one in-flight operation and an accurate completion/error state. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## REL-01: Analysis and financial charts can remain in loading UI after failure

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed error-state gap.

**Exact source/symbol anchors:** [lib/features/analysis/view/screen/analysis.dart:35](/Users/alimegahed/power_saving/lib/features/analysis/view/screen/analysis.dart:35) (`controller.getAnalysis(station:`); [lib/features/analysis/controller/analysis.dart:14](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:14) (`anl=null`); [lib/features/Ploitly.dart:37](/Users/alimegahed/power_saving/lib/features/Ploitly.dart:37) (`c.waterChartHtml == null`)

**Root cause:** AnalysisView starts requests from build and represents null data as loading. Analysis.getAnalysis catches errors without a terminal error state/update. SunburstPage also uses null chart HTML as loading; financialAnalysis lacks a distinct error/empty state and does not update the GetBuilder on its catch path.

**User impact:** After an API or parsing failure the user sees an indefinite spinner; an ancestor rebuild can reissue analysis work. This is not a claim of a self-triggering infinite build loop.

**Dependencies:** BASE, DATA-06

**Proposed client-side work:** Fetch once from lifecycle/argument changes; model loading/data/empty/error explicitly and expose retry.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Return timeout, malformed payload, missing chart and 500 fixtures; verify each exits loading and retry makes exactly one request.

**Acceptance:** Return timeout, malformed payload, missing chart and 500 fixtures; verify each exits loading and retry makes exactly one request. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-04: Planning reference refresh discards active input controllers

**Original severity:** High. **Status:** READY. **Evidence:** Confirmed destructive refresh behavior; timing-dependent.

**Exact source/symbol anchors:** [lib/features/planning/controller/blance_chart/blance_chart.dart:127](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:127) (`Future<void> allvalues`); [lib/features/planning/controller/blance_chart/blance_chart.dart:130](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:130) (`textControllers.clear()`); [lib/features/planning/controller/place/edit_place_type_controller.dart:89](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:89) (`allvalues(isBackground: false)`)

**Root cause:** allvalues constructs blank text controllers from cache and then again when its background response returns. Existing entries are cleared without preserving draft values or disposing replaced controllers. Editing place types also refreshes the active balance controller.

**User impact:** A user can enter ministry-method values after cached rendering and lose them when a slow reference refresh completes. Reference data ownership is coupled to mutable form state.

**Dependencies:** BASE

**Proposed client-side work:** Keep reference records separate from draft controllers; reconcile by stable placeTypeId, preserve dirty inputs, and dispose only removed entries.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Warm the cache, delay place-types response, enter values, then complete it and verify the draft is preserved. Repeat while updating a place type in another view.

**Acceptance:** Warm the cache, delay place-types response, enter values, then complete it and verify the draft is preserved. Repeat while updating a place type in another view. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-05: Technology-bill drafts are keyed by mutable list position

**Original severity:** High. **Status:** READY. **Evidence:** Potential data-association defect.

**Exact source/symbol anchors:** [lib/features/tech_bills/controller/techbills.dart:55](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:55) (`final chlorineControllers =`); [lib/features/tech_bills/view/screens/tech_bills.dart:164](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:164) (`final originalIndex =`); [lib/features/tech_bills/controller/techbills.dart:248](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:248) (`fetchTechBills(isBackground: true)`)

**Root cause:** All row form keys and input-controller maps use integer indexes. Cards recover originalIndex using indexOf. A successful save refreshes the full data list without remapping/discarding other draft maps by bill ID.

**User impact:** If the server removes/reorders rows on refresh, another row can inherit unsaved chemical/water values. A later save may submit that draft against a different techBillId. Server ordering stability was not specified.

**Dependencies:** BASE, DATA-06

**Proposed client-side work:** Key draft controllers and widget identity by immutable techBillId; merge refreshed records without moving dirty drafts between records.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Enter values for two bill IDs, complete a refresh that reorders/removes one record, and verify each draft remains attached to its original ID.

**Acceptance:** Enter values for two bill IDs, complete a refresh that reorders/removes one record, and verify each draft remains attached to its original ID. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-06: Older requests can overwrite newer bill filters and pages

**Original severity:** Medium. **Status:** READY. **Evidence:** Potential asynchronous race.

**Exact source/symbol anchors:** [lib/features/bill/controller/all_bills.dart:84](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:84) (`Future<void> allbills`); [lib/features/bill/controller/tech_bills.dart:40](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:40) (`Future<void> allbills`)

**Root cause:** Each search/filter/page request updates shared lists and pagination when it completes. Neither controller uses cancellation, request generation, or a response-versus-active-query check. Cache background loads can overlap user-selected filters.

**User impact:** A slower old search response can replace a newer result, including page metadata. Debounce reduces requests but cannot order their completion.

**Dependencies:** BASE, API-FREEZE

**Proposed client-side work:** Snapshot query identity and commit only the latest response; cancel obsolete reads where possible and scope cache entries by query/account.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Hold response A, issue and finish B, then finish A; displayed rows and page metadata must remain B.

**Acceptance:** Hold response A, issue and finish B, then finish A; displayed rows and page metadata must remain B. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## DATA-07: Malformed report rows are omitted without a persistent completeness warning

**Original severity:** Medium. **Status:** BLOCKED. **Evidence:** Confirmed partial-report behavior.

**Exact source/symbol anchors:** [lib/features/reports/controller/reports_controller.dart:224](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:224) (`branchs.add(ReportBranch.fromJson(i))`); [lib/features/reports/model/report.dart:71](/Users/alimegahed/power_saving/lib/features/reports/model/report.dart:71) (`factory ReportBranch.fromJson`)

**Root cause:** getReports catches individual row parse failures, shows dialogs, and continues with remaining rows. It then computes totals and allows normal report rendering/printing. Several model fields require numeric values and other missing values silently default to zero.

**User impact:** A report with omitted or defaulted data can look complete after dialogs are dismissed and understate totals. The frequency of malformed payloads is not known.

**Dependencies:** Q-REPORT, BASE

**Proposed client-side work:** Capture parse rejection counts in fixtures. Propose an additive warning without changing row selection, sums or export availability; totals/default changes remain blocked.

**Backend/business dependency and gate:** Rejecting rows, changing defaults or preventing export changes report totals/workflow. A nonblocking completeness warning is a separable client-only subset; acceptance of partial reports requires approval.

**Regression tests:** Use one valid and one malformed row; verify the report cannot be mistaken for a complete dataset and its export includes the warning.

**Acceptance:** Use one valid and one malformed row; verify the report cannot be mistaken for a complete dataset and its export includes the warning. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-05: Printed record count ignores active report filters

**Original severity:** Low. **Status:** READY. **Evidence:** Confirmed reporting inconsistency.

**Exact source/symbol anchors:** [lib/features/reports/view/screens/report.dart:836](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:836) (`final rows = controller.filteredBranchs`); [lib/features/reports/view/screens/report.dart:890](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:890) (`${controller.branchs.length}`)

**Root cause:** Print rows come from filteredBranchs while the printed total-record header uses branchs.length.

**User impact:** A filtered export states the unfiltered record count, undermining auditability and reconciliation.

**Dependencies:** BASE

**Proposed client-side work:** Show displayed count and optional source count separately, and include active filters in the print header.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Load ten rows, filter to two, print locally and confirm the record count and filter description match the two exported rows.

**Acceptance:** Load ten rows, filter to two, print locally and confirm the record count and filter description match the two exported rows. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## ARCH-01: Transport and repository layers own navigation and dialogs

**Original severity:** Medium. **Status:** REQUIRES INVESTIGATION. **Evidence:** Architectural weakness.

**Exact source/symbol anchors:** [lib/core/network/api_client.dart:67](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:67) (`showCustomErrorDialog`); [lib/core/repositories/base_repository.dart:24](/Users/alimegahed/power_saving/lib/core/repositories/base_repository.dart:24) (`Get.offAll`); [lib/network/network.dart:31](/Users/alimegahed/power_saving/lib/network/network.dart:31) (`Get.offAll`)

**Root cause:** There are two HTTP implementations. Only authentication uses ApiClient/BaseRepository/Result. Both infrastructure layers import presentation helpers; BaseRepository imports the login view. A failure may trigger a dialog in transport, another in repository, and another in the calling controller. Static import analysis confirms an auth cycle.

**User impact:** Network policy and user feedback diverge across features; unit tests need UI setup, retries can stack dialogs, and changes to login presentation affect data-layer dependencies.

**Dependencies:** API-FREEZE, QA-01

**Proposed client-side work:** Consolidate behind an injected transport boundary incrementally; return typed errors and let a session coordinator/presentation layer own navigation and one user notification.

**Backend/business dependency and gate:** Characterize both transports and every caller before consolidation; preserve differences in headers, statuses and error handling intentionally.

**Regression tests:** With an injected failing client, verify no UI side effects occur below controllers and exactly one user message is emitted per final failed operation.

**Acceptance:** With an injected failing client, verify no UI side effects occur below controllers and exactly one user message is emitted per final failed operation. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## NET-01: Most feature requests have no application timeout or cancellation

**Original severity:** Medium. **Status:** REQUIRES INVESTIGATION. **Evidence:** Confirmed missing control.

**Exact source/symbol anchors:** [lib/network/network.dart:22](/Users/alimegahed/power_saving/lib/network/network.dart:22) (`final res = await http.get`); [lib/network/network.dart:49](/Users/alimegahed/power_saving/lib/network/network.dart:49) (`final res = await http.post`); [lib/core/network/api_client.dart:11](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:11) (`defaultTimeoutSeconds = 15`)

**Root cause:** fetchData/postData await top-level http calls without a deadline. Most feature controllers use this legacy path. The authentication-only ApiClient has a 15-second per-attempt timeout, so its safeguards do not cover catalogs, bills, reports and forecasts.

**User impact:** A stalled response can leave business forms/read screens pending until transport-level behavior resolves it. Navigation does not cancel requests or prevent stale completion side effects.

**Dependencies:** API-FREEZE, ARCH-01

**Proposed client-side work:** Use bounded, operation-specific deadlines and stale-result rejection in the shared transport. Retry only safe operations; surface retryable read failures without losing drafts.

**Backend/business dependency and gate:** Establish safe operation deadlines and recovery semantics. Client timeout is not server cancellation and must not trigger mutation replay.

**Regression tests:** Use a fake client that never resolves; each operation should reach a bounded recoverable state and leaving the screen should prevent later UI mutations.

**Acceptance:** Use a fake client that never resolves; each operation should reach a bounded recoverable state and leaving the screen should prevent later UI mutations. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## NET-02: Authentication client retries POSTs after ambiguous failures

**Original severity:** Medium. **Status:** BLOCKED. **Evidence:** Potential mutation replay.

**Exact source/symbol anchors:** [lib/core/network/api_client.dart:31](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:31) (`return _executeWithRetry(() async`); [lib/core/network/api_client.dart:68](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:68) (`if (attempts >= maxRetryAttempts)`); [lib/features/auth/data/repositories/auth_repository_impl.dart:45](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:45) (`/change-password`)

**Root cause:** ApiClient routes POST through the same three-attempt retry wrapper as GET. A timeout falls into the generic catch and is retried. The server may have committed a password change before a response was lost. No idempotency key appears.

**User impact:** Repeated mutation requests can create misleading failure after success or other replay effects. Current usage is login/password change; this is not claimed for all legacy business POSTs.

**Dependencies:** Q-AUTH, API-FREEZE

**Proposed client-side work:** Characterize exactly three attempts and current delay/error behavior; document ambiguous mutation completion. Do not add idempotency fields or change authentication behavior.

**Backend/business dependency and gate:** Changing replay behavior on password mutation affects an unverified authentication recovery contract. No idempotency header/key or backend change is authorized.

**Regression tests:** Simulate server-side commit followed by lost response; verify the client does not blindly repeat a password mutation and offers a coherent recovery path.

**Acceptance:** Simulate server-side commit followed by lost response; verify the client does not blindly repeat a password mutation and offers a coherent recovery path. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## PERF-01: Reports eagerly render and print whole result sets

**Original severity:** Medium. **Status:** REQUIRES INVESTIGATION. **Evidence:** Static performance opportunity.

**Exact source/symbol anchors:** [lib/features/reports/controller/reports_controller.dart:201](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:201) (`final res = await postData`); [lib/features/reports/view/screens/report.dart:741](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:741) (`rows: buildRows()`); [lib/features/reports/view/widgets/branch_report.dart:26](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:26) (`controller.filteredBranchs.map`)

**Root cause:** Report API loads the full date-range result; filtering and totals run locally. DataTable builds every row inside nested SingleChildScrollViews. Printing joins all rows into one HTML string. The controller builds _index but applyFilters does not use it.

**User impact:** Large date ranges increase main-isolate parsing/filtering/layout work and retained objects. No observed frame times or latency measurements exist. Bill-history endpoints already use pagination and should not be described as globally unpaginated.

**Dependencies:** BASE, QA-01

**Proposed client-side work:** Profile synthetic lists and prototype client-only lazy rendering preserving all records/filter order/totals/print output. No server pagination.

**Backend/business dependency and gate:** Measure local fixture scale first. Only client rendering/index improvements are eligible; new API pagination or export endpoints are prohibited.

**Regression tests:** Measure frame build/raster timing, heap, decode/filter duration and payload bytes with synthetic 100/1,000/10,000-row fixtures in a disposable test environment.

**Acceptance:** Measure frame build/raster timing, heap, decode/filter duration and payload bytes with synthetic 100/1,000/10,000-row fixtures in a disposable test environment. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## LIFE-01: Several controllers and subscriptions lack a complete disposal path

**Original severity:** Medium. **Status:** READY. **Evidence:** Confirmed cleanup omissions; runtime impact unmeasured.

**Exact source/symbol anchors:** [lib/features/technology/controller/edit_tech_controller.dart:30](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:30) (`void onClose()`); [lib/features/tech_bills/controller/new_tech_bills.dart:99](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:99) (`void onClose()`); [lib/features/reports/view/screens/report.dart:630](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:630) (`final ScrollController verticalController`); [lib/features/bill/controller/tech_bills.dart:32](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:32) (`debounce(searchQuery`)

**Root cause:** EditTechController omits disposal of its five text controllers. NewTechBillsController omits calculated/measured controllers and their listeners. Reports creates ScrollControllers per table build without disposal. TechBillscontroller discards its debounce Worker; ReportsController discards everAll Worker. Billing ratio controllers and replaced tariff controllers have similar ownership gaps.

**User impact:** Repeated visits can retain listeners/resources and reset scroll position; exact retained heap and whether garbage collection recovers each instance are unmeasured. These are lifecycle omissions, not proof of a measured leak size.

**Dependencies:** BASE

**Proposed client-side work:** Assign each resource one lifecycle owner, retain/dispose workers, avoid new controllers in build, and dispose replaced collection entries.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Repeat open/edit/close and filter actions under a heap profiler; confirm no accumulating controller/listener instances and preserved intended scroll state.

**Acceptance:** Repeat open/edit/close and filter actions under a heap profiler; confirm no accumulating controller/listener instances and preserved intended scroll state. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## BUILD-01: Native release networking is not fully configured

**Original severity:** High. **Status:** REQUIRES INVESTIGATION. **Evidence:** Confirmed source configuration gaps; release outcome unverified.

**Exact source/symbol anchors:** [android/app/src/main/AndroidManifest.xml:2](/Users/alimegahed/power_saving/android/app/src/main/AndroidManifest.xml:2) (`<application`); [android/app/src/debug/AndroidManifest.xml:6](/Users/alimegahed/power_saving/android/app/src/debug/AndroidManifest.xml:6) (`android.permission.INTERNET`); [macos/Runner/Release.entitlements:5](/Users/alimegahed/power_saving/macos/Runner/Release.entitlements:5) (`com.apple.security.app-sandbox`); [android/app/src/main/res/xml/network_security_config.xml:4](/Users/alimegahed/power_saving/android/app/src/main/res/xml/network_security_config.xml:4) (`<domain-config`)

**Root cause:** Main Android manifest lacks INTERNET permission while debug/profile add it. Its network_security_config is not referenced by the application manifest and its public-host entry differs from ApiConfig. macOS release enables sandbox without network.client entitlement. iOS Info.plist has no HTTP exceptions while client URLs are HTTP.

**User impact:** Native builds can fail to access APIs even when web/debug appears to work. Final merged Android manifest, signed entitlements and iOS transport behavior were not tested, so platform failures are not presented as observed runtime results.

**Dependencies:** Q-PLATFORM, API-FREEZE

**Proposed client-side work:** Adopt HTTPS, declare required release network permission/entitlements deliberately, and verify merged/signed artifacts for each supported platform.

**Backend/business dependency and gate:** Inspect actual merged artifacts, platform support and current host/configuration relationships. No HTTP→HTTPS or server configuration changes are authorized.

**Regression tests:** Build in an authorized disposable environment and inspect the merged release manifest and signed entitlements; smoke-test authenticated networking on supported devices.

**Acceptance:** Build in an authorized disposable environment and inspect the merged release manifest and signed entitlements; smoke-test authenticated networking on supported devices. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## BUILD-02: Android release build uses debug signing

**Original severity:** Medium. **Status:** BLOCKED. **Evidence:** Confirmed release configuration weakness.

**Exact source/symbol anchors:** [android/app/build.gradle.kts:37](/Users/alimegahed/power_saving/android/app/build.gradle.kts:37) (`signingConfig = signingConfigs.getByName("debug")`)

**Root cause:** The release build type explicitly selects the debug signing configuration; namespace/application ID also remain com.example.power_saving.

**User impact:** The configuration is unsuitable as a controlled production signing/distribution process. No actual distributed APK or signing certificate was inspected.

**Dependencies:** Q-SIGNING

**Proposed client-side work:** Define a protected release signing workflow, deployment identity and CI secret handling; preserve signing continuity for any already distributed app.

**Backend/business dependency and gate:** Production signing identity, key custody and distribution continuity are unknown; owner-provided signing plan required.

**Regression tests:** Inspect a release artifact certificate and identifiers in a safe build environment; verify production keys never enter source control.

**Acceptance:** Inspect a release artifact certificate and identifiers in a safe build environment; verify production keys never enter source control. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## QA-01: Automated tests do not cover business workflows

**Original severity:** High. **Status:** READY. **Evidence:** Confirmed assurance gap.

**Exact source/symbol anchors:** [test/auth_repository_test.dart:7](/Users/alimegahed/power_saving/test/auth_repository_test.dart:7) (`group('Enterprise Monadic Result Tests'`); [test/widget_test.dart:12](/Users/alimegahed/power_saving/test/widget_test.dart:12) (`// void main()`)

**Root cause:** The two active Dart tests exercise Result success/failure only; despite its filename, auth_repository_test does not test repository I/O. widget_test is entirely commented out. No tracked CI workflow or integration-test suite was found. Native RunnerTests are template shells.

**User impact:** Billing arithmetic, session transitions, report accuracy, navigation and asynchronous races lack a regression safety net. No test execution or coverage measurement was performed.

**Dependencies:** BASE

**Proposed client-side work:** Prioritize pure billing tests, fake-client contract/session tests, navigation/form widget tests and a small isolated end-to-end suite before broader refactoring.

**Backend/business dependency and gate:** Source-supported client-only work; eligible only after explicit Phase 1 authorization and characterization tests.

**Regression tests:** Run the proposed cases in a disposable environment with network denied and explicit fixtures; publish real test results/coverage only when measured.

**Acceptance:** Run the proposed cases in a disposable environment with network denied and explicit fixtures; publish real test results/coverage only when measured. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-06: Native print action has no implementation

**Original severity:** Medium. **Status:** BLOCKED. **Evidence:** Confirmed platform feature gap.

**Exact source/symbol anchors:** [lib/global/html_stub.dart:5](/Users/alimegahed/power_saving/lib/global/html_stub.dart:5) (`void openHtmlReport`); [lib/global/iframe_stub.dart:8](/Users/alimegahed/power_saving/lib/global/iframe_stub.dart:8) (`return const SizedBox.shrink()`); [lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:168](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:168) (`openHtmlReport(printContent)`)

**Root cause:** Non-web openHtmlReport is a no-op and the chart platform stub returns an empty widget. Print/chart screens are registered without platform capability gates.

**User impact:** Users on native targets can invoke print with no result, or see blank financial charts after loading. Whether native platforms are officially supported is undocumented.

**Dependencies:** Q-PLATFORM, Q-CHART

**Proposed client-side work:** Document the native no-op; investigate an equivalent native implementation with existing dependencies after platform approval. Do not hide existing actions.

**Backend/business dependency and gate:** Implementing native output needs a supported-platform and fidelity contract; hiding/removing existing buttons or features is prohibited.

**Regression tests:** On each claimed supported platform, verify chart rendering and print/export success or a clear unsupported-capability state.

**Acceptance:** On each claimed supported platform, verify chart rendering and print/export success or a clear unsupported-capability state. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## UX-07: Shared text field ignores its custom validator parameter

**Original severity:** Low. **Status:** REQUIRES INVESTIGATION. **Evidence:** Confirmed unused extension hook.

**Exact source/symbol anchors:** [lib/my_widget/sharable.dart:19](/Users/alimegahed/power_saving/lib/my_widget/sharable.dart:19) (`Function()? validator;`); [lib/my_widget/sharable.dart:96](/Users/alimegahed/power_saving/lib/my_widget/sharable.dart:96) (`validator: useValidator`)

**Root cause:** CustomTextFormField accepts validator but its build method always uses a hardcoded required-only validator when useValidator is true. No caller-supplied validation is invoked.

**User impact:** Future/existing callers relying on that API cannot enforce domain validation. Concrete form paths often perform separate checks, so universal validation failure is not claimed.

**Dependencies:** BASE, Q-VALIDATION

**Proposed client-side work:** Use a typed String? Function(String?) validator and combine required/domain validation explicitly; validate numeric ranges and relationships at submission as well.

**Backend/business dependency and gate:** Audit all custom-validator call sites and establish intended validation behavior before activating the unused hook.

**Regression tests:** Create a widget test with a custom rejecting validator and verify its error appears; audit numeric/date/range fields independently.

**Acceptance:** Create a widget test with a custom rejecting validator and verify its error appears; audit numeric/date/range fields independently. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## BUILD-03: Launcher and browser icons point to absent files

**Original severity:** Low. **Status:** REQUIRES INVESTIGATION. **Evidence:** Confirmed asset reference defects.

**Exact source/symbol anchors:** [pubspec.yaml:37](/Users/alimegahed/power_saving/pubspec.yaml:37) (`image_path:`); [web/index.html:33](/Users/alimegahed/power_saving/web/index.html:33) (`rel="icon"`)

**Root cause:** Launcher configuration points at images/710.jpg but tracked images contains 710.png. Browser favicon references a generated-image filename absent at the web root; a similarly named image exists under images/.

**User impact:** Icon generation or favicon loading can fail. No generator was executed and deployed rewrites were not inspected.

**Dependencies:** Q-ASSETS

**Proposed client-side work:** Align configuration with intended tracked assets and document the icon generation step. Verify browser asset resolution in the built artifact.

**Backend/business dependency and gate:** Confirm intended icon asset identity and build asset resolution before changing references or running generators.

**Regression tests:** Check configured paths statically and inspect a disposable built site for missing icon requests.

**Acceptance:** Check configured paths statically and inspect a disposable built site for missing icon requests. Also: frozen request method/URL/query/headers/body and response mapping snapshots must be unchanged; no feature removed and no source changes during Phase 0.

## Consolidation without lost IDs

- Session work groups SEC-04/05/06; SEC-04/05/06 are READY under the explicit approved local policy. Wire authentication protocol, valid-role mapping and retry semantics remain frozen.
- Billing draft ownership groups DATA-02/03 and LIFE-01; disposal outside billing may proceed later, but calculation behavior remains frozen.
- Transport/error ownership groups ARCH-01, NET-01/02 and REL-01; error-state UI can be tested separately from changing transport policy.
- Report integrity groups DATA-07, UX-05, SEC-03 and PERF-01; escaping/count correction can be isolated from totals, parser defaults and pagination.
- Release/platform work groups BUILD-01/02/03 and UX-06; no feature may be hidden to resolve a platform gap.

BASE = current snapshot + characterization fixtures. API-FREEZE = exact call-site/serializer snapshots. Q-* = decisions in blocked_items.md. Runtime reproduction remains pending for all UI behavior; source-confirmed does not mean tests ran.

## Approved clarification register

The user explicitly approved public registration, rejection of missing/null/invalid group_id at login/startup, preservation of existing valid-role permissions, and retaining the session/navigation after successful password change when the existing token allows it. SEC-05/06 are therefore READY for later client-only implementation. This is authorization of policy, not authorization to start Phase 1. Request/response schemas and model contracts remain frozen; validate raw identity at the session boundary instead of inventing fields or server validation calls. Recognized IDs 1–7 are the union already represented in source menu rules, not new roles. Unknown backend-recognized IDs must be escalated if later evidence establishes them.

Billing answer “use the same role in my code” is interpreted as preserve current code rules/calculations; DATA-01/02/03 stay scope-BLOCKED. The system is internal; TLS, chart capabilities and supported platforms were not specified. Internal deployment does not establish trusted transit or safe executable HTML.

## Supplemental narrative-observation traceability

The seven audits also discuss the following unnumbered risks/opportunities. They have **no original severity assigned** and are not added to the 30 original-finding totals. Each row preserves its report context; source-level risk is not runtime confirmation. Dependencies refer to original IDs/stages. Exact primary source files/symbols are listed; runtime validation is pending for every performance/visual claim.

| Reference / source symbol | Root cause and user impact | Proposed client-only work / dependency | Regression and acceptance | Status / backend or business gate |
|---|---|---|---|---|
| N01 — reports 03/06, lib/features/relations/controller/relations/relation.dart, RelationsController.editRelation | Status action uses GET; unsafe-method semantics possible. | Inventory only; API-FREEZE. | Request fixture keeps GET/path/headers; server meaning remains unverified. | BLOCKED: method change prohibited. |
| N02 — report 03, lib/features/Counter/controller/counter.dart, CounterController.addCounter | Uses new-station unlike dedicated meter creator; latent wrong-endpoint risk. | Trace reachability, no endpoint substitution. | Fixture distinguishes both calls; owner resolves contract before any correction. | BLOCKED: API change/assumption. |
| N03 — report 03, lib/features/auth/data/repositories/auth_repository_impl.dart, login | Persistence precedes complete User parse and ignores save result; partial session possible. | Stage 3 validate approved group boundary before usable persistence; characterize other parsing/storage failures. | Invalid group never creates usable session; preserve unrelated response models. | READY for approved group subset; other persistence semantics REQUIRES INVESTIGATION. |
| N04 — reports 03/06, lib/network/network.dart and CRUD add/edit methods | Transport accepts 2xx, callers often accept only 200; successful writes may look failed with undocumented status. | Freeze response behavior; request fixtures. | Distinct 200/201/204 fixtures retain current interpretation. | BLOCKED for changed status contracts. |
| N05 — report 03, lib/features/bill/model/bills_model.dart, GuageBill.fromJson; report.dart ReportBranch.fromJson | Specific default year/zeros/null coercions can mask missing data. | Characterization only; DATA-07. | Missing fields map identically; no new schema assumptions. | BLOCKED: parsing/domain contract. |
| N06 — reports 03/04, lib/features/bill/controller/bills.dart, addnewbill | Invalidates bill history but not meter final-reading cache; stale next-bill prerequisite risk. | Investigate server update/invalidation graph. | Two-bill synthetic sequence; no changed reading arithmetic/request. | REQUIRES INVESTIGATION: server reading update semantics. |
| N07 — reports 03/05, lib/features/predaction/controller/prediaction.dart, prediactions | Failure retains previous result; wrong selected-station interpretation possible. | Characterize selection/result ownership and add stale/error labeling if compatible; DATA-06. | Station A success then B failure cannot present A as verified B; payload unchanged. | REQUIRES INVESTIGATION: rendered labeling/effect. |
| N08 — report 04, lib/main.dart, main | Malformed cached JSON triggers dialog before runApp; startup recovery risk. | Stage 3 invalid-session recovery after navigator exists; SEC-05/06. | Invalid cached group/JSON exits safely to login; no new API request. | READY for approved invalid-session recovery. |
| N09 — report 04, lib/global/app_theme.dart, AppTheme.lightTheme; pubspec.yaml assets | Font loading and large PNG may affect cold start. | Measure critical path, preserve assets/appearance; Stage 6. | Actual bytes/timing/visual parity; no unsupported startup claim. | REQUIRES INVESTIGATION; dependency/asset changes separately approved. |
| N10 — report 04, catalog controllers sessionCache/master/display lists | Reparse/copy/cache refresh increases CPU/memory; duplicate requests possible. | Profile typed-cache/dedup options after SEC-04. | Same data/freshness/session behavior; measured improvement. | REQUIRES INVESTIGATION. |
| N11 — report 04, lib/features/analysis/view/screen/analysis.dart, _extractChartsList and image rendering | Base64 plus decoded images allocate repeatedly. | Profile/retain immutable decoded bytes per response. | Identical chart images and zoom; measured decode/heap improvement. | REQUIRES INVESTIGATION. |
| N12 — report 04, lib/features/home/view/screens/home.dart, _HoverStatCardState.build | Formatter creation/animation/shadows may cost frames. | Profile first; reduced-motion review, Stage 6. | Same KPI values/labels; measured frame impact, accessibility check. | REQUIRES INVESTIGATION. |
| N13 — report 04, lib/features/reports/controller/reports_controller.dart, _buildSearchIndex/applyFilters | Unused index wastes allocations. | Remove/use index only after exact filtering parity; PERF-01. | Same selected records/order and sums across all filters. | READY for parity-proven client-only cleanup; execution deferred. |
| N14 — reports 03/04, lib/features/bill/controller/all_bills.dart, _fetchLatestBackground; other async wrappers | Unawaited work lets callers resume early; cache freshness not explicit. | Define ownership/completion and await only where intended; UX-03/DATA-06. | Refresh Future matches its documented completion; no extra request. | READY within confirmed refresh fix; other wrappers REQUIRES INVESTIGATION. |
| N15 — reports 03/05, lib/core/widgets/app_scaffold.dart, build; responsive_wrapper.dart; accessible_focus_wrapper.dart | desktopHeader ignored and unused wrappers; inconsistent implementation, not proven bad visuals. | Verify intended layout/keyboard behavior; Stage 5. | Existing features and all breakpoints reachable, actual screenshot/focus evidence. | REQUIRES INVESTIGATION. |
| N16 — report 05, lib/global/app_theme.dart, darkTheme; lib/main.dart MyApp.build | Dark theme unused; Arabic strings versus supported English declaration. | Document actual light/Arabic support, do not introduce new product behavior without decision. | No claim of English/dark support; existing locale/RTL remains. | REQUIRES INVESTIGATION: product support policy. |
| N17 — report 05, lib/my_widget/sharable.dart, showSuccessToast/showCustomErrorDialog | Blocking modals and repeated infrastructure dialogs add steps; raw errors may disclose details. | Single presentation owner and sanitized messages retaining recovery; ARCH-01. | One terminal notification and preserved success/error action semantics. | REQUIRES INVESTIGATION. |
| N18 — report 05, report widgets branch_report.dart and home.dart KPI labels | Unit labels differ, possible misleading interpretation. | Document discrepancies, no conversion/relabeling. | Same numeric values and unit labels until authoritative contract. | BLOCKED: measurement/domain rules. |
| N19 — reports 05/07, all feature screens (35-file inventory) | Fixed rows/card ratios, missing labels/focus and motion behavior may harm accessibility. | Actual device/keyboard/semantics/contrast checks before bounded UI fixes. | T-RESP-01 across supported targets, no features removed. | REQUIRES INVESTIGATION; visual status NOT VERIFIED. |
| N20 — reports 06/07, lib/shared_pref/cache.dart, Cache; auth repository | Client-readable token persistence; rotation/revocation/backend authorization unknown. | Document threat model; approved local invalid-session validation only. | Existing storage/auth protocol unchanged; no unsupported server security claim. | BLOCKED for protocol/storage architecture changes. |
| N21 — reports 06/07, pubspec.lock, analysis_options.yaml, README.md, platform configuration | Advisory status, toolchain pinning, deprecated warnings, CI/runbooks absent or weak. | Nonmutating advisory review later; document toolchain and proposed CI using existing dependencies. | Actual tests/advisory evidence; no dependency regeneration or upgrade without approval. | REQUIRES INVESTIGATION; QA-01 test scope remains READY. |
| N22 — report 05, lib/features/stations/controller/following_stations_controller.dart, stationsTechs; add_stations_controller.dart allBranches | Missing catch / empty catch leave lookup failures unrecoverable or silent. | Add explicit terminal error/retry state after characterization; REL-01 pattern. | Failure/empty/success fixtures, same requests and selection values. | READY for local error presentation; execution deferred. |
| N23 — Phase 0 clarification, sidebar/drawer _buildMenuItems | Reports group 4 visibility differs between navigation surfaces. | Preserve both valid-user mappings; SEC-05/06 validation cannot standardize this. | T-AUTH-02 snapshots both surfaces separately. | BLOCKED for role-policy change; preserve current behavior. |

These observations overlap original findings where indicated; they are not duplicate implementation tickets. Expanded work must keep the original IDs in PR/test references and must not broaden an approved batch merely because an observation appears here.
