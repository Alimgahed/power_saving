# Evidence-backed finding register

Severity reflects likely business impact, not a measured exploit score. “Confirmed” means the implementation establishes the stated defect/control gap; it does not imply runtime reproduction. Conditional impact and unknown server behavior are called out explicitly. Validation steps below are recommendations, not tests already run.

| ID | Severity | Classification | Finding |
|---|---|---|---|
| SEC-01 | High | Confirmed insecure configuration | Credentials and authenticated requests use HTTP |
| SEC-02 | High | Confirmed unsafe sink; exploit conditional | Server HTML executes in an unsandboxed chart frame |
| SEC-03 | High | Confirmed output-encoding gap; exploit conditional | Report data is interpolated into executable HTML |
| SEC-04 | High | Confirmed cache isolation gap; exposure conditional | Logout leaves static data caches available to the next account |
| SEC-05 | Medium | Confirmed fail-open client default | Missing role data defaults to the administrator group |
| SEC-06 | Medium | Architectural weakness | Session validity and authorization are not enforced at route boundaries |
| DATA-01 | High | Confirmed arithmetic defect | Meter rollover undercounts consumption by one reading unit |
| DATA-02 | High | Confirmed lifecycle/data-flow defect | Billing dialog replaces controllers that hold calculation listeners |
| DATA-03 | Medium | Confirmed missing dependency | Rounding and manual consumption edits do not recompute totals |
| UX-01 | Medium | Confirmed navigation defect | Add Bill action targets an unregistered route |
| UX-02 | Medium | Confirmed reactive wiring defect | Technology-bill text search does not react to text edits |
| UX-03 | Medium | Confirmed loading-state defect | Cached refresh can leave catalog spinners permanently active |
| UX-04 | Medium | Confirmed assignment defect | Registration loading state never changes |
| REL-01 | Medium | Confirmed error-state gap | Analysis and financial charts can remain in loading UI after failure |
| DATA-04 | High | Confirmed destructive refresh behavior; timing-dependent | Planning reference refresh discards active input controllers |
| DATA-05 | High | Potential data-association defect | Technology-bill drafts are keyed by mutable list position |
| DATA-06 | Medium | Potential asynchronous race | Older requests can overwrite newer bill filters and pages |
| DATA-07 | Medium | Confirmed partial-report behavior | Malformed report rows are omitted without a persistent completeness warning |
| UX-05 | Low | Confirmed reporting inconsistency | Printed record count ignores active report filters |
| ARCH-01 | Medium | Architectural weakness | Transport and repository layers own navigation and dialogs |
| NET-01 | Medium | Confirmed missing control | Most feature requests have no application timeout or cancellation |
| NET-02 | Medium | Potential mutation replay | Authentication client retries POSTs after ambiguous failures |
| PERF-01 | Medium | Static performance opportunity | Reports eagerly render and print whole result sets |
| LIFE-01 | Medium | Confirmed cleanup omissions; runtime impact unmeasured | Several controllers and subscriptions lack a complete disposal path |
| BUILD-01 | High | Confirmed source configuration gaps; release outcome unverified | Native release networking is not fully configured |
| BUILD-02 | Medium | Confirmed release configuration weakness | Android release build uses debug signing |
| QA-01 | High | Confirmed assurance gap | Automated tests do not cover business workflows |
| UX-06 | Medium | Confirmed platform feature gap | Native print action has no implementation |
| UX-07 | Low | Confirmed unused extension hook | Shared text field ignores its custom validator parameter |
| BUILD-03 | Low | Confirmed asset reference defects | Launcher and browser icons point to absent files |

## SEC-01 — Credentials and authenticated requests use HTTP

**High · Confirmed insecure configuration**

**Evidence.** Every baseUrl branch selects http://. Login serializes username/password into the request; both clients attach bearer tokens to subsequent requests. No transport upgrade is implemented in the client.

**Source.** [lib/global/ip_config.dart:19](/Users/alimegahed/power_saving/lib/global/ip_config.dart:19); [lib/features/auth/data/repositories/auth_repository_impl.dart:5](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:5); [lib/network/network.dart:20](/Users/alimegahed/power_saving/lib/network/network.dart:20)

**Impact / scenario.** An observer or active attacker on the network path can read or alter traffic where these endpoints are reachable. HTTPS hosting also risks blocked mixed-content API calls. Actual interception and production deployment were not tested.

**Recommended direction.** Provide authenticated HTTPS endpoints and an explicit environment configuration. Verify certificate/hostname validation and migrate clients before removing HTTP service.

**Validation to perform.** In a non-production environment, inspect login and authenticated requests and confirm HTTPS-only operation, including LAN and native targets.

## SEC-02 — Server HTML executes in an unsandboxed chart frame

**High · Confirmed unsafe sink; exploit conditional**

**Evidence.** financialAnalysis reads water_chart from the API and registerIframe assigns it directly to IFrameElement.srcdoc without sandbox restrictions. The chart HTML is treated as executable content.

**Source.** [lib/global/iframe_web.dart:15](/Users/alimegahed/power_saving/lib/global/iframe_web.dart:15); [lib/controller/voltage/financial.dart:27](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:27)

**Impact / scenario.** A party able to alter that HTML response, including an active attacker on the configured HTTP path, can inject browser script into the frame. Same-origin privileges and token exposure depend on deployment/CSP and browser behavior; no exploit was run.

**Recommended direction.** Serve charts as structured data where possible. Otherwise isolate executable chart content on a separate origin or a tightly sandboxed frame without same-origin privilege, and use HTTPS/CSP.

**Validation to perform.** Use an inert marker fixture and a controlled local security test to verify frame isolation, parent DOM access restrictions, and storage boundaries.

## SEC-03 — Report data is interpolated into executable HTML

**High · Confirmed output-encoding gap; exploit conditional**

**Evidence.** BranchReportPrinter.rowCells inserts branchName into <td> markup without escaping. BaseReportPrinter also inserts the cached employee name and form text into HTML, then openHtmlReport opens a text/html Blob. Other report/plan printers use the same interpolation approach.

**Source.** [lib/features/reports/view/widgets/branch_report.dart:60](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:60); [lib/features/reports/view/screens/report.dart:836](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:836); [lib/global/html_web.dart:13](/Users/alimegahed/power_saving/lib/global/html_web.dart:13)

**Impact / scenario.** HTML-like data can change the printed document. Script execution is possible if attacker-controlled strings reach these fields; server-side validation, actual stored malicious data and browser exploitability were not inspected.

**Recommended direction.** Escape all text at the HTML boundary; allow only intentional template markup. Avoid raw HTML-returning cell APIs and validate image URL/base64 contexts separately.

**Validation to perform.** Generate local reports containing &, <, >, quotes, Arabic names, and inert HTML tags; verify literal text, unchanged structure and no executable user content.

## SEC-04 — Logout leaves static data caches available to the next account

**High · Confirmed cache isolation gap; exposure conditional**

**Evidence.** Logout clears preferences and SessionService lists/user, but the static caches in user, station, meter, bill, relation, chemical and planning controllers remain. Cache-first loaders display those records before background authorization completes. Outstanding requests have no session-generation check.

**Source.** [lib/features/home/view/widgets/enterprise_sidebar.dart:172](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:172); [lib/global/data.dart:27](/Users/alimegahed/power_saving/lib/global/data.dart:27); [lib/features/auth/controller/all_user.dart:10](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:10)

**Impact / scenario.** On a shared browser/app process, a subsequent account can see prior-account cached records on accessible screens; authorization failure does not undo the initial display. Severity depends on whether accounts have different data entitlements. A late prior-session response can repopulate a cleared cache.

**Recommended direction.** Scope repositories/caches to authenticated identity, clear all session data atomically, cancel or reject old-session responses, and avoid displaying unauthorized stale data.

**Validation to perform.** With fake responses, sign in as A, warm caches, log out, sign in as B with narrower permissions, and verify no A data appears even when delayed A responses finish.

## SEC-05 — Missing role data defaults to the administrator group

**Medium · Confirmed fail-open client default**

**Evidence.** User.fromJson assigns group 1 when group_id is absent/null; group 1 enables user administration menu items. Cached User data is restored without server revalidation at startup.

**Source.** [lib/features/auth/model/login.dart:24](/Users/alimegahed/power_saving/lib/features/auth/model/login.dart:24); [lib/features/home/view/widgets/enterprise_sidebar.dart:123](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:123)

**Impact / scenario.** Malformed or stale user payloads receive administrator UI visibility. This does not establish backend privilege escalation; API role enforcement is unavailable for review.

**Recommended direction.** Use an explicit unknown/no-access role for missing data, validate login schema before caching, and resolve authorization from server policy.

**Validation to perform.** Parse a user without group_id and confirm no privileged menus/actions are enabled. Separately test server authorization with role-specific credentials in an authorized environment.

## SEC-06 — Session validity and authorization are not enforced at route boundaries

**Medium · Architectural weakness**

**Evidence.** Routes have no authentication/role middleware. Navigation checks rely on cached user presence and menu visibility. 401/403 handlers remove token but leave cached/in-memory user; 403 is treated as expired authentication. Password-change success navigates to login without clearing session.

**Source.** [lib/main.dart:115](/Users/alimegahed/power_saving/lib/main.dart:115); [lib/features/home/view/widgets/navigation_helper.dart:11](/Users/alimegahed/power_saving/lib/features/home/view/widgets/navigation_helper.dart:11); [lib/network/network.dart:30](/Users/alimegahed/power_saving/lib/network/network.dart:30)

**Impact / scenario.** Direct route navigation bypasses menu restrictions, and reload can restore /home with no valid token. Forbidden actions can unnecessarily log out otherwise valid users. Backend data access remains unverified.

**Recommended direction.** Centralize session invalidation and startup validation; add route guards for UX and explicit forbidden states. Retain server authorization as the real security boundary.

**Validation to perform.** Exercise absent/expired token, 403, password change, reload and direct navigation to every privileged route; verify coherent state and correct forbidden handling.

## DATA-01 — Meter rollover undercounts consumption by one reading unit

**High · Confirmed arithmetic defect**

**Evidence.** Bills._calculateReadingDifference subtracts 1 from the wrap modulus. For a four-digit meter changing 9999 to 0, it calculates 0 rather than 1; 9998 to 2 gives 3 rather than 4. Consumption is then multiplied by the reading factor. The modulus is inferred from the previous reading digit count rather than meter metadata.

**Source.** [lib/features/bill/controller/bills.dart:152](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:152); [lib/features/bill/controller/bills.dart:133](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:133)

**Impact / scenario.** Bills around rollover understate consumption by one unit times the factor. Incorrectly inferred meter width and treating all decreases as rollovers add a separate domain risk.

**Recommended direction.** Use the configured meter modulus, distinguish rollover/replacement/correction, and centralize the reviewed calculation as a pure function.

**Validation to perform.** Add boundary cases for maximum→0, maximum−1→2, unchanged reading, normal increment, factor >1 and invalid decreases. Confirm results with the billing domain owner.

## DATA-02 — Billing dialog replaces controllers that hold calculation listeners

**High · Confirmed lifecycle/data-flow defect**

**Evidence.** Opening a bill manually calls onInit on the GetX-managed controller. The dialog builder then replaces briefReadingController and readingFactorController after _setupListeners attached callbacks to their prior instances. It also creates controllers during build.

**Source.** [lib/features/Counter/view/screens/Counter.dart:329](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:329); [lib/features/Counter/view/screens/Counter.dart:390](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:390); [lib/features/Counter/view/screens/Counter.dart:409](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:409); [lib/features/bill/controller/bills.dart:88](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:88)

**Impact / scenario.** Editing the displayed previous reading or factor alone no longer triggers its intended recalculation; totals may remain stale until another watched field changes. Repeated dialog opens/rebuilds abandon controllers and can reset edits.

**Recommended direction.** Initialize the draft once, assign .text on existing controllers, and let GetX own lifecycle. Move billing form/draft ownership out of the meter card builder.

**Validation to perform.** Open a bill, change only factor and then only previous reading, verify consumption/total change immediately, and repeat open/close/rebuild while preserving draft edits.

## DATA-03 — Rounding and manual consumption edits do not recompute totals

**Medium · Confirmed missing dependency**

**Evidence.** _calculateTotal reads roundingController and powerConsumpController, but neither is listened to by _setupListeners. Both are editable form fields. Submission serializes their current values alongside billTotalController, which may reflect an older calculation.

**Source.** [lib/features/bill/controller/bills.dart:88](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:88); [lib/features/bill/controller/bills.dart:187](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:187); [lib/features/Counter/view/screens/Counter.dart:700](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:700)

**Impact / scenario.** A bill can contain a rounding/consumption value inconsistent with its submitted total. Whether the backend recomputes totals is unknown.

**Recommended direction.** Make derived fields read-only or include all permitted input dependencies in a single calculation, and recompute/validate the bill at submit time and on the server.

**Validation to perform.** Change rounding as the last field before submitting and compare displayed total, payload, and expected arithmetic; repeat for manually entered consumption.

## UX-01 — Add Bill action targets an unregistered route

**Medium · Confirmed navigation defect**

**Evidence.** The Bills screen exposes an Add Bill button pointing to /addBill. No matching GetPage, alternate route handler, or unknownRoute implementation appears in main.dart. The implemented new-bill journey lives in the meter card dialog.

**Source.** [lib/features/bill/view/screens/bills.dart:144](/Users/alimegahed/power_saving/lib/features/bill/view/screens/bills.dart:144); [lib/main.dart:116](/Users/alimegahed/power_saving/lib/main.dart:116)

**Impact / scenario.** Users starting from bill history reach an unresolved navigation destination instead of creating a bill. Exact GetX error/fallback presentation was not executed.

**Recommended direction.** Link the action to the existing meter-selection/billing flow or register a dedicated bill creation route with required arguments.

**Validation to perform.** Traverse every visible navigation action and compare static route names; then perform an offline widget navigation test for Add Bill.

## UX-02 — Technology-bill text search does not react to text edits

**Medium · Confirmed reactive wiring defect**

**Evidence.** The search worker observes an Rx wrapper around a TextEditingController instance. onSearchChanged mutates its .text rather than the observed Rx value; no text listener or direct applyFilters call is attached to the edit path.

**Source.** [lib/features/tech_bills/controller/techbills.dart:133](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:133); [lib/features/tech_bills/controller/techbills.dart:153](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:153); [lib/features/tech_bills/view/screens/tech_bills.dart:48](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:48)

**Impact / scenario.** Typing a query leaves results unchanged until another action invokes applyFilters, such as changing a branch filter.

**Recommended direction.** Observe an RxString query or register/dispose a text listener and debounce that query. Avoid rewriting the text value from its own onChanged callback.

**Validation to perform.** Type an unmatched term without changing another filter and verify an empty-result state after the debounce; clear it and verify restored records.

## UX-03 — Cached refresh can leave catalog spinners permanently active

**Medium · Confirmed loading-state defect**

**Evidence.** These refresh methods set a loading flag then invoke cache-first loading. With a warm cache, the loader returns before clearing that flag, and the background branch intentionally does not clear foreground loading. Chemical/relation refresh wrappers also return before their asynchronous loads finish.

**Source.** [lib/features/chemcails/controller/chemacial.dart:108](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:108); [lib/features/relations/controller/relations/relation.dart:111](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:111); [lib/features/technology/controller/technlogy.dart:175](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:175)

**Impact / scenario.** Refreshing a previously loaded catalog can leave its loading UI active even when new data arrives. StationsController has a finally covering its cache branch, so the same permanent-spinner claim is not made for stations.

**Recommended direction.** Separate force-refresh from cache-first load, await the real request, and guarantee loading reset in finally for the owner of the flag.

**Validation to perform.** Warm each cache, refresh successfully and with a failed response, and assert the refresh Future and spinner finish in both cases.

## UX-04 — Registration loading state never changes

**Medium · Confirmed assignment defect**

**Evidence.** NewUsercontroller.new_user uses equality comparisons instead of assignments for all loading changes. The form submit InkWell remains enabled; password-change submit likewise remains actionable while showing a spinner.

**Source.** [lib/features/auth/controller/new_user.dart:47](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:47); [lib/features/auth/view/screens/new_user.dart:193](/Users/alimegahed/power_saving/lib/features/auth/view/screens/new_user.dart:193)

**Impact / scenario.** No registration progress state is shown and repeated taps can send duplicate requests. Backend duplicate protection is unknown.

**Recommended direction.** Assign loading state correctly, reject reentrant submissions at controller level, and disable submit interaction while awaiting completion.

**Validation to perform.** Use a delayed fake registration/password request and tap repeatedly; expect one in-flight operation and an accurate completion/error state.

## REL-01 — Analysis and financial charts can remain in loading UI after failure

**Medium · Confirmed error-state gap**

**Evidence.** AnalysisView starts requests from build and represents null data as loading. Analysis.getAnalysis catches errors without a terminal error state/update. SunburstPage also uses null chart HTML as loading; financialAnalysis lacks a distinct error/empty state and does not update the GetBuilder on its catch path.

**Source.** [lib/features/analysis/view/screen/analysis.dart:35](/Users/alimegahed/power_saving/lib/features/analysis/view/screen/analysis.dart:35); [lib/features/analysis/controller/analysis.dart:14](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:14); [lib/features/Ploitly.dart:37](/Users/alimegahed/power_saving/lib/features/Ploitly.dart:37)

**Impact / scenario.** After an API or parsing failure the user sees an indefinite spinner; an ancestor rebuild can reissue analysis work. This is not a claim of a self-triggering infinite build loop.

**Recommended direction.** Fetch once from lifecycle/argument changes; model loading/data/empty/error explicitly and expose retry.

**Validation to perform.** Return timeout, malformed payload, missing chart and 500 fixtures; verify each exits loading and retry makes exactly one request.

## DATA-04 — Planning reference refresh discards active input controllers

**High · Confirmed destructive refresh behavior; timing-dependent**

**Evidence.** allvalues constructs blank text controllers from cache and then again when its background response returns. Existing entries are cleared without preserving draft values or disposing replaced controllers. Editing place types also refreshes the active balance controller.

**Source.** [lib/features/planning/controller/blance_chart/blance_chart.dart:127](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:127); [lib/features/planning/controller/blance_chart/blance_chart.dart:130](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:130); [lib/features/planning/controller/place/edit_place_type_controller.dart:89](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:89)

**Impact / scenario.** A user can enter ministry-method values after cached rendering and lose them when a slow reference refresh completes. Reference data ownership is coupled to mutable form state.

**Recommended direction.** Keep reference records separate from draft controllers; reconcile by stable placeTypeId, preserve dirty inputs, and dispose only removed entries.

**Validation to perform.** Warm the cache, delay place-types response, enter values, then complete it and verify the draft is preserved. Repeat while updating a place type in another view.

## DATA-05 — Technology-bill drafts are keyed by mutable list position

**High · Potential data-association defect**

**Evidence.** All row form keys and input-controller maps use integer indexes. Cards recover originalIndex using indexOf. A successful save refreshes the full data list without remapping/discarding other draft maps by bill ID.

**Source.** [lib/features/tech_bills/controller/techbills.dart:55](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:55); [lib/features/tech_bills/view/screens/tech_bills.dart:164](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:164); [lib/features/tech_bills/controller/techbills.dart:248](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:248)

**Impact / scenario.** If the server removes/reorders rows on refresh, another row can inherit unsaved chemical/water values. A later save may submit that draft against a different techBillId. Server ordering stability was not specified.

**Recommended direction.** Key draft controllers and widget identity by immutable techBillId; merge refreshed records without moving dirty drafts between records.

**Validation to perform.** Enter values for two bill IDs, complete a refresh that reorders/removes one record, and verify each draft remains attached to its original ID.

## DATA-06 — Older requests can overwrite newer bill filters and pages

**Medium · Potential asynchronous race**

**Evidence.** Each search/filter/page request updates shared lists and pagination when it completes. Neither controller uses cancellation, request generation, or a response-versus-active-query check. Cache background loads can overlap user-selected filters.

**Source.** [lib/features/bill/controller/all_bills.dart:84](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:84); [lib/features/bill/controller/tech_bills.dart:40](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:40)

**Impact / scenario.** A slower old search response can replace a newer result, including page metadata. Debounce reduces requests but cannot order their completion.

**Recommended direction.** Snapshot query identity and commit only the latest response; cancel obsolete reads where possible and scope cache entries by query/account.

**Validation to perform.** Hold response A, issue and finish B, then finish A; displayed rows and page metadata must remain B.

## DATA-07 — Malformed report rows are omitted without a persistent completeness warning

**Medium · Confirmed partial-report behavior**

**Evidence.** getReports catches individual row parse failures, shows dialogs, and continues with remaining rows. It then computes totals and allows normal report rendering/printing. Several model fields require numeric values and other missing values silently default to zero.

**Source.** [lib/features/reports/controller/reports_controller.dart:224](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:224); [lib/features/reports/model/report.dart:71](/Users/alimegahed/power_saving/lib/features/reports/model/report.dart:71)

**Impact / scenario.** A report with omitted or defaulted data can look complete after dialogs are dismissed and understate totals. The frequency of malformed payloads is not known.

**Recommended direction.** Validate response schema, count and surface rejected records, retain an incomplete-data flag in UI/export, and distinguish missing values from actual zero.

**Validation to perform.** Use one valid and one malformed row; verify the report cannot be mistaken for a complete dataset and its export includes the warning.

## UX-05 — Printed record count ignores active report filters

**Low · Confirmed reporting inconsistency**

**Evidence.** Print rows come from filteredBranchs while the printed total-record header uses branchs.length.

**Source.** [lib/features/reports/view/screens/report.dart:836](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:836); [lib/features/reports/view/screens/report.dart:890](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:890)

**Impact / scenario.** A filtered export states the unfiltered record count, undermining auditability and reconciliation.

**Recommended direction.** Show displayed count and optional source count separately, and include active filters in the print header.

**Validation to perform.** Load ten rows, filter to two, print locally and confirm the record count and filter description match the two exported rows.

## ARCH-01 — Transport and repository layers own navigation and dialogs

**Medium · Architectural weakness**

**Evidence.** There are two HTTP implementations. Only authentication uses ApiClient/BaseRepository/Result. Both infrastructure layers import presentation helpers; BaseRepository imports the login view. A failure may trigger a dialog in transport, another in repository, and another in the calling controller. Static import analysis confirms an auth cycle.

**Source.** [lib/core/network/api_client.dart:67](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:67); [lib/core/repositories/base_repository.dart:24](/Users/alimegahed/power_saving/lib/core/repositories/base_repository.dart:24); [lib/network/network.dart:31](/Users/alimegahed/power_saving/lib/network/network.dart:31)

**Impact / scenario.** Network policy and user feedback diverge across features; unit tests need UI setup, retries can stack dialogs, and changes to login presentation affect data-layer dependencies.

**Recommended direction.** Consolidate behind an injected transport boundary incrementally; return typed errors and let a session coordinator/presentation layer own navigation and one user notification.

**Validation to perform.** With an injected failing client, verify no UI side effects occur below controllers and exactly one user message is emitted per final failed operation.

## NET-01 — Most feature requests have no application timeout or cancellation

**Medium · Confirmed missing control**

**Evidence.** fetchData/postData await top-level http calls without a deadline. Most feature controllers use this legacy path. The authentication-only ApiClient has a 15-second per-attempt timeout, so its safeguards do not cover catalogs, bills, reports and forecasts.

**Source.** [lib/network/network.dart:22](/Users/alimegahed/power_saving/lib/network/network.dart:22); [lib/network/network.dart:49](/Users/alimegahed/power_saving/lib/network/network.dart:49); [lib/core/network/api_client.dart:11](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:11)

**Impact / scenario.** A stalled response can leave business forms/read screens pending until transport-level behavior resolves it. Navigation does not cancel requests or prevent stale completion side effects.

**Recommended direction.** Use bounded, operation-specific deadlines and stale-result rejection in the shared transport. Retry only safe operations; surface retryable read failures without losing drafts.

**Validation to perform.** Use a fake client that never resolves; each operation should reach a bounded recoverable state and leaving the screen should prevent later UI mutations.

## NET-02 — Authentication client retries POSTs after ambiguous failures

**Medium · Potential mutation replay**

**Evidence.** ApiClient routes POST through the same three-attempt retry wrapper as GET. A timeout falls into the generic catch and is retried. The server may have committed a password change before a response was lost. No idempotency key appears.

**Source.** [lib/core/network/api_client.dart:31](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:31); [lib/core/network/api_client.dart:68](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:68); [lib/features/auth/data/repositories/auth_repository_impl.dart:45](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:45)

**Impact / scenario.** Repeated mutation requests can create misleading failure after success or other replay effects. Current usage is login/password change; this is not claimed for all legacy business POSTs.

**Recommended direction.** Make retries method/operation-aware and never blindly replay non-idempotent mutations after ambiguous completion; use server idempotency contracts when appropriate.

**Validation to perform.** Simulate server-side commit followed by lost response; verify the client does not blindly repeat a password mutation and offers a coherent recovery path.

## PERF-01 — Reports eagerly render and print whole result sets

**Medium · Static performance opportunity**

**Evidence.** Report API loads the full date-range result; filtering and totals run locally. DataTable builds every row inside nested SingleChildScrollViews. Printing joins all rows into one HTML string. The controller builds _index but applyFilters does not use it.

**Source.** [lib/features/reports/controller/reports_controller.dart:201](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:201); [lib/features/reports/view/screens/report.dart:741](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:741); [lib/features/reports/view/widgets/branch_report.dart:26](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:26)

**Impact / scenario.** Large date ranges increase main-isolate parsing/filtering/layout work and retained objects. No observed frame times or latency measurements exist. Bill-history endpoints already use pagination and should not be described as globally unpaginated.

**Recommended direction.** Introduce bounded/server-paginated interactive reports and separate full export. Compute indexes only if used; prefer lazy row rendering for large screens.

**Validation to perform.** Measure frame build/raster timing, heap, decode/filter duration and payload bytes with synthetic 100/1,000/10,000-row fixtures in a disposable test environment.

## LIFE-01 — Several controllers and subscriptions lack a complete disposal path

**Medium · Confirmed cleanup omissions; runtime impact unmeasured**

**Evidence.** EditTechController omits disposal of its five text controllers. NewTechBillsController omits calculated/measured controllers and their listeners. Reports creates ScrollControllers per table build without disposal. TechBillscontroller discards its debounce Worker; ReportsController discards everAll Worker. Billing ratio controllers and replaced tariff controllers have similar ownership gaps.

**Source.** [lib/features/technology/controller/edit_tech_controller.dart:30](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:30); [lib/features/tech_bills/controller/new_tech_bills.dart:99](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:99); [lib/features/reports/view/screens/report.dart:630](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:630); [lib/features/bill/controller/tech_bills.dart:32](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:32)

**Impact / scenario.** Repeated visits can retain listeners/resources and reset scroll position; exact retained heap and whether garbage collection recovers each instance are unmeasured. These are lifecycle omissions, not proof of a measured leak size.

**Recommended direction.** Assign each resource one lifecycle owner, retain/dispose workers, avoid new controllers in build, and dispose replaced collection entries.

**Validation to perform.** Repeat open/edit/close and filter actions under a heap profiler; confirm no accumulating controller/listener instances and preserved intended scroll state.

## BUILD-01 — Native release networking is not fully configured

**High · Confirmed source configuration gaps; release outcome unverified**

**Evidence.** Main Android manifest lacks INTERNET permission while debug/profile add it. Its network_security_config is not referenced by the application manifest and its public-host entry differs from ApiConfig. macOS release enables sandbox without network.client entitlement. iOS Info.plist has no HTTP exceptions while client URLs are HTTP.

**Source.** [android/app/src/main/AndroidManifest.xml:2](/Users/alimegahed/power_saving/android/app/src/main/AndroidManifest.xml:2); [android/app/src/debug/AndroidManifest.xml:6](/Users/alimegahed/power_saving/android/app/src/debug/AndroidManifest.xml:6); [macos/Runner/Release.entitlements:5](/Users/alimegahed/power_saving/macos/Runner/Release.entitlements:5); [android/app/src/main/res/xml/network_security_config.xml:4](/Users/alimegahed/power_saving/android/app/src/main/res/xml/network_security_config.xml:4)

**Impact / scenario.** Native builds can fail to access APIs even when web/debug appears to work. Final merged Android manifest, signed entitlements and iOS transport behavior were not tested, so platform failures are not presented as observed runtime results.

**Recommended direction.** Adopt HTTPS, declare required release network permission/entitlements deliberately, and verify merged/signed artifacts for each supported platform.

**Validation to perform.** Build in an authorized disposable environment and inspect the merged release manifest and signed entitlements; smoke-test authenticated networking on supported devices.

## BUILD-02 — Android release build uses debug signing

**Medium · Confirmed release configuration weakness**

**Evidence.** The release build type explicitly selects the debug signing configuration; namespace/application ID also remain com.example.power_saving.

**Source.** [android/app/build.gradle.kts:37](/Users/alimegahed/power_saving/android/app/build.gradle.kts:37)

**Impact / scenario.** The configuration is unsuitable as a controlled production signing/distribution process. No actual distributed APK or signing certificate was inspected.

**Recommended direction.** Define a protected release signing workflow, deployment identity and CI secret handling; preserve signing continuity for any already distributed app.

**Validation to perform.** Inspect a release artifact certificate and identifiers in a safe build environment; verify production keys never enter source control.

## QA-01 — Automated tests do not cover business workflows

**High · Confirmed assurance gap**

**Evidence.** The two active Dart tests exercise Result success/failure only; despite its filename, auth_repository_test does not test repository I/O. widget_test is entirely commented out. No tracked CI workflow or integration-test suite was found. Native RunnerTests are template shells.

**Source.** [test/auth_repository_test.dart:7](/Users/alimegahed/power_saving/test/auth_repository_test.dart:7); [test/widget_test.dart:12](/Users/alimegahed/power_saving/test/widget_test.dart:12)

**Impact / scenario.** Billing arithmetic, session transitions, report accuracy, navigation and asynchronous races lack a regression safety net. No test execution or coverage measurement was performed.

**Recommended direction.** Prioritize pure billing tests, fake-client contract/session tests, navigation/form widget tests and a small isolated end-to-end suite before broader refactoring.

**Validation to perform.** Run the proposed cases in a disposable environment with network denied and explicit fixtures; publish real test results/coverage only when measured.

## UX-06 — Native print action has no implementation

**Medium · Confirmed platform feature gap**

**Evidence.** Non-web openHtmlReport is a no-op and the chart platform stub returns an empty widget. Print/chart screens are registered without platform capability gates.

**Source.** [lib/global/html_stub.dart:5](/Users/alimegahed/power_saving/lib/global/html_stub.dart:5); [lib/global/iframe_stub.dart:8](/Users/alimegahed/power_saving/lib/global/iframe_stub.dart:8); [lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:168](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:168)

**Impact / scenario.** Users on native targets can invoke print with no result, or see blank financial charts after loading. Whether native platforms are officially supported is undocumented.

**Recommended direction.** Either implement native export/chart rendering or make web-only capability explicit and hide/disable unsupported actions with a useful alternative.

**Validation to perform.** On each claimed supported platform, verify chart rendering and print/export success or a clear unsupported-capability state.

## UX-07 — Shared text field ignores its custom validator parameter

**Low · Confirmed unused extension hook**

**Evidence.** CustomTextFormField accepts validator but its build method always uses a hardcoded required-only validator when useValidator is true. No caller-supplied validation is invoked.

**Source.** [lib/my_widget/sharable.dart:19](/Users/alimegahed/power_saving/lib/my_widget/sharable.dart:19); [lib/my_widget/sharable.dart:96](/Users/alimegahed/power_saving/lib/my_widget/sharable.dart:96)

**Impact / scenario.** Future/existing callers relying on that API cannot enforce domain validation. Concrete form paths often perform separate checks, so universal validation failure is not claimed.

**Recommended direction.** Use a typed String? Function(String?) validator and combine required/domain validation explicitly; validate numeric ranges and relationships at submission as well.

**Validation to perform.** Create a widget test with a custom rejecting validator and verify its error appears; audit numeric/date/range fields independently.

## BUILD-03 — Launcher and browser icons point to absent files

**Low · Confirmed asset reference defects**

**Evidence.** Launcher configuration points at images/710.jpg but tracked images contains 710.png. Browser favicon references a generated-image filename absent at the web root; a similarly named image exists under images/.

**Source.** [pubspec.yaml:37](/Users/alimegahed/power_saving/pubspec.yaml:37); [web/index.html:33](/Users/alimegahed/power_saving/web/index.html:33)

**Impact / scenario.** Icon generation or favicon loading can fail. No generator was executed and deployed rewrites were not inspected.

**Recommended direction.** Align configuration with intended tracked assets and document the icon generation step. Verify browser asset resolution in the built artifact.

**Validation to perform.** Check configured paths statically and inspect a disposable built site for missing icon requests.
