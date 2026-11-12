# Performance and lifecycle assessment

This is a static assessment. No runtime latency, startup duration, FPS, memory usage, CPU profile, database timing, or benchmark improvement is claimed. The numerical measurements available are source/asset sizes and arithmetic diagnostics; they are not runtime performance measurements.

## Startup

`main()` awaits SharedPreferences, registers a permanent SessionService, decodes cached user data, and runs GetMaterialApp. No bulk catalog preload is called directly by main; the initial home binding triggers its own data request. There is insufficient evidence to call startup inherently slow. Cached-user parsing loops while decoded data remains a string, and parsing errors call a dialog helper before an app navigator exists. A malformed-cache startup should be tested and recovered by invalidating that cache and rendering a login/error state after the app mounts.

The theme uses GoogleFonts.almaraiTextTheme and pubspec declares no bundled fonts. Measure cold-font behavior and fallback layout under an offline fixture before deciding to bundle. `images/` includes a generated PNG of **4,963,638 bytes**, home background of **450,226 bytes**, and logo of **89,792 bytes**. Pubspec includes the directory; source inclusion does not prove each asset is downloaded during startup. Optimize only assets confirmed on critical journeys and preserve image quality appropriate to display size.

## Opportunities and measurement plan

| Journey / mechanism | Expected impact and qualification | Measurement | Recommended direction |
|---|---|---|---|
| Large reports: eager DataTable, full JSON, full print string (PERF-01) | Parsing, layout, filtering and HTML construction grow with returned rows. No runtime jank measured. | Synthetic row-size sweep; frame build/raster times, heap, payload bytes, parse/filter/print durations. | Paginate interactive report data; lazy rows; dedicated export path for complete reports. |
| Catalog revisit: JSON cache plus parsed master/display/global lists | Cache hits parse all records again and immediately refresh. Retained JSON/maps and model lists increase memory; list copies do not necessarily clone model objects. | Heap snapshots and request counts across repeated visits, using realistic catalog sizes. | Store typed immutable cache data, account-scoped TTL/query keys and shared reference repositories. Preserve freshness explicitly. |
| Analysis rebuild (REL-01) | Parent/theme/layout rebuild can repeat expensive analysis requests. No self-sustaining build loop is asserted. | Count fake-client calls during resize/theme/parent rebuild. | Fetch from lifecycle or keyed request state, with deduplication. |
| Forecast/analysis base64 images | Base64 strings and decoded image bytes can coexist; repeated decoding in build adds allocations. | Profile retained decoded images and decode counts for multiple charts, including fullscreen. | Decode once per response, constrain image sizes and use cached immutable bytes. |
| Operational tech bills | Each visible card uses indexOf across full list; cumulative scrolling can perform repeated linear lookups. Draft controller maps grow as rows are visited. | CPU samples during long scroll/filter and controller count after refresh. | Stable ID-keyed rows/drafts; dispose removed drafts; server pagination if data size justifies it. |
| Home KPI animation | NumberFormat is constructed within the animation builder; shadows/gradients and skeleton controllers add rendering work. Existing lazy list rendering is a positive. | DevTools profile during initial KPI animation on target low-end hardware; reduced-motion check. | Hoist formatters/static child content if profile shows cost; honor reduced motion. No preemptive removal of all animation. |
| Repeated list additions | Several loaders call add/update inside loops; reactive notifications may increase work, though Flutter can coalesce frames. | Rebuild counters and timeline for a large reference response. | Parse once, assignAll once and issue one explicit update where appropriate. |
| Unused report search index | _buildSearchIndex allocates lowercase fields, while applyFilters rereads original fields. | Allocation/filter profiling after loading a large report. | Either use the index consistently or remove it in a later authorized change. |

Relevant source: [ReportsController](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:10), [report table](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:629), [analysis screen](/Users/alimegahed/power_saving/lib/features/analysis/view/screen/analysis.dart:12), [tech bill row builder](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:161), [home animation](/Users/alimegahed/power_saving/lib/features/home/view/screens/home.dart:1622).

## Resource ownership

LIFE-01 records specific disposal omissions; DATA-02 and DATA-04 also replace controller ownership while views are active. The affected resources include text controllers, dynamic ratio controller lists, report scroll controllers, debounce/everAll workers, and tariff controllers replaced after fetch. ApiClient owns an http.Client but exposes no close/disposal path. Whether a given object becomes collectible depends on its listeners and owner lifecycle; no retained-memory quantity was measured.

Positive patterns also exist: StationsController, CounterController, PlacesController and RelationsController retain and dispose their search workers/controllers. EditTechbillsController cancels its debounce timer and disposes its text controllers. FutureCapacityEntry disposes removed row controllers. Home skeleton animation controllers are disposed. These examples can guide consistent ownership without changing the state-management framework.

## Request state and responsiveness

NET-01 covers missing deadlines for most business requests. NET-02 covers ambiguous POST replay in the newer client. DATA-06 covers out-of-order result commits. Repeated background refresh is a deliberate stale-while-revalidate pattern, but it needs explicit ownership, error/freshness signaling, cache scope, and query identity. No polling timer or websocket/stream integration was found in the reviewed networking paths, so a polling optimization is not proposed.

Some Future<void> wrappers invoke async work without returning/awaiting it, including `_fetchLatestBackground()` in several controllers. Calling code that awaits the wrapper can therefore resume before data is refreshed. Distinguish intentionally fire-and-forget work from completion-bearing refresh operations, and propagate cancellation/error ownership accordingly.

## Safe profiling protocol for future work

Use an authorized disposable checkout, fake/local backend, synthetic data and non-production credentials. Profile cold/warm startup separately; use device-specific baselines instead of universal FPS promises. Record device, build mode, Flutter revision, dataset size, network conditions, and query identity. Measure before/after for each optimization and verify results/filters/drafts remain correct. None of these mutating runtime preparations were executed in the audited checkout.
