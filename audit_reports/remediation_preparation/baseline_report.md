# Phase 0 baseline report

Date: 11 November 2026, Africa/Cairo. Documentation preparation only. No fixes, test additions, dependency/configuration changes, Git operations that change history/worktree, builds or production API requests were performed.

## Current repository state

- Root: /Users/alimegahed/power_saving. Branch: master. HEAD: bf78471b7b4ef8c0254d8e5eba4f79595ca45e2c.
- Existing tracked modification: pubspec.lock, 11 insertions/11 deletions. Existing audit_reports files were untracked and are preserved.
- All 343 tracked file hashes matched the previous audit baseline at the start of Phase 0. Current source therefore supports the original findings; status decisions were revised for the new constraints and user clarification.
- Recent commits: bf78471 finail; fa17119 optmizie; 7589861 update reports; e125626 update reports; e4d9e11 redesgien. Commit subjects are context, not evidence of validation.

## Existing changes protected

The lockfile already changes characters 1.4.0→1.4.1, matcher 0.12.17→0.12.19, material_color_utilities 0.11.1→0.13.0, meta 1.17.0→1.18.0, test_api 0.7.7→0.7.11 and related hashes. Dart lock constraint changes >=3.9.0 to >=3.10.0-0; Flutter remains >=3.35.0. No dependency change is attributed to this phase.

The Phase 0 snapshot hashes 610 pre-existing regular files (202,738,242 bytes), excluding .git and this new preparation directory. It includes all original audit deliverables, 193 .dart_tool files, 35 build files and platform-generated files. Symlinks are excluded from content hashing. Tracked generated registrants/CMake plugin files match the original baseline. Ignored generated files had no historical Git baseline; their current bytes are now protected, not falsely claimed to match a previous build. See baseline_snapshot.json and final preservation.json.

## Safely observed toolchain

PATH resolves flutter/dart under /Users/alimegahed/Documents/SDK/flutter/bin. The existing bin/cache/flutter.version.json reports Flutter 3.44.2 stable, revision c9a6c484230f8b5e408ec57be1ef71dee1e77020, engine 77e2e94772b6eb43759e34ed1ad7da4674e19cab, bundled Dart 3.12.2. Direct cached Dart binary --version actually executed and reported Dart 3.12.2 stable on macos_arm64. The Flutter launcher was not executed because it can refresh cache/metadata. .dart_tool/version also says 3.44.2. These are installed/cache observations, not build verification.

## Current architecture inventory

198 Dart files, 31,881 physical lines, 36 named routes, 35 feature-screen files. All source hashes were checked; current files were scanned for API call sites, mappings, state and critical behavior. No backend/schema/server source found.

| Feature | Files | Scope |
|---|---:|---|
| Counter | 9 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| analysis | 3 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| auth | 13 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| bill | 8 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| chemcails | 10 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| home | 16 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| planning | 30 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| predaction | 5 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| relations | 10 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| reports | 15 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| stations | 13 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| tech_bills | 10 | Controllers/models/views/bindings where present; exact class/path inventory below. |
| technology | 9 | Controllers/models/views/bindings where present; exact class/path inventory below. |

The app uses GetX bindings/Obx/GetBuilder, a permanent SessionService, legacy fetchData/postData and an authentication-only ApiClient/AuthRepositoryImpl/BaseRepository stack. Static per-controller caches, preferences, local draft controllers and platform HTML shims are inventoried. No background server synchronization/SQL layer is inferred.

## Routes and bindings

| Route | Screen | Binding |
|---|---|---|
| /Charts | SunburstPage | ChartsBinding |
| /home | HomeScreen | HomeBinding |
| /change_password | ChangePassword | none in route registration |
| /editPlaces | EditPlacesScreen | none in route registration |
| /Stations | StationsScreen | StationsBinding |
| /Login | Login | none in route registration |
| /editMeter | EditCounterScreen | none in route registration |
| /editStations | EditStationsScreen | none in route registration |
| /NewUser | NewUser | none in route registration |
| /addstations | AddStationScreen | none in route registration |
| /Technology | Technology | TechnologyBinding |
| /all_users | AllUserScreen | AllUserBinding |
| /EditTechBills | EditTechBills | none in route registration |
| /Places | PlacesScreen | PlacesBinding |
| /placeTypes | PlaceTypesListScreen | PlaceTypesBinding |
| /AddPlaces | AddPlacesScreen | none in route registration |
| /BlanceCart | BlanceCart | BalanceChartBinding |
| /BalanceChartPrintScreen | BalanceChartPrintScreen | none in route registration |
| /Edittech | EditTechScreen | none in route registration |
| /Reports | Reports | ReportsBinding |
| /Predictions | Predaction | PredictionBinding |
| /analysis | AnalysisView | none in route registration |
| /addTech | AddTechScreen | none in route registration |
| /bills | Bills | BillsBinding |
| /techBill | TechBill | TechBillsBinding |
| /Countrts | Counterscreen | CounterBinding |
| /addCounter | AddElectricMeterScreen | none in route registration |
| /NewTechBills | NewTechBillsScreen | NewTechBillsBinding |
| /FollowingStations | FollowingStationsScreen | FollowingStationsBinding |
| /Relations | RelationsScreen | RelationsBinding |
| /Addrelation | AddRelationScreen | none in route registration |
| /Chemicals | Chemicals | ChemicalsBinding |
| /AddChemicalScreen | AddChemicalScreen | none in route registration |
| /techbills | TechBills | TechbillsBinding |
| /EditChemcials | EditChemcials | none in route registration |
| /AnimatedGauge | AnimatedGauge | none in route registration |

## Controllers, bindings, repositories, clients and caches

| Path | Classes | Cache/state declarations |
|---|---|---|
| [lib/controller/binding/charts_binding.dart](/Users/alimegahed/power_saving/lib/controller/binding/charts_binding.dart) | ChartsBinding | See source ownership; no static cache declaration in this file. |
| [lib/controller/voltage/financial.dart](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart) | FinancialController | See source ownership; no static cache declaration in this file. |
| [lib/controller/voltage/voltage.dart](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart) | Voltage | See source ownership; no static cache declaration in this file. |
| [lib/core/network/api_client.dart](/Users/alimegahed/power_saving/lib/core/network/api_client.dart) | ApiClient | See source ownership; no static cache declaration in this file. |
| [lib/core/repositories/base_repository.dart](/Users/alimegahed/power_saving/lib/core/repositories/base_repository.dart) | providing, BaseRepository | See source ownership; no static cache declaration in this file. |
| [lib/features/Counter/binding/counter_binding.dart](/Users/alimegahed/power_saving/lib/features/Counter/binding/counter_binding.dart) | CounterBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/Counter/controller/add_counter_controller.dart](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart) | addcounter | See source ownership; no static cache declaration in this file. |
| [lib/features/Counter/controller/counter.dart](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart) | CounterController | static List<dynamic>? sessionCache; |
| [lib/features/Counter/controller/edit_counter_controller.dart](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart) | EditCounter | See source ownership; no static cache declaration in this file. |
| [lib/features/analysis/controller/analysis.dart](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart) | Analysis | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/binding/all_user_binding.dart](/Users/alimegahed/power_saving/lib/features/auth/binding/all_user_binding.dart) | AllUserBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/controller/all_user.dart](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart) | AllUserController | static List<dynamic>? sessionCache; |
| [lib/features/auth/controller/chang_password.dart](/Users/alimegahed/power_saving/lib/features/auth/controller/chang_password.dart) | ChangePasswordController | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/controller/login.dart](/Users/alimegahed/power_saving/lib/features/auth/controller/login.dart) | LoginController | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/controller/logout.dart](/Users/alimegahed/power_saving/lib/features/auth/controller/logout.dart) | functions only / empty file | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/controller/new_user.dart](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart) | NewUsercontroller | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/data/repositories/auth_repository_impl.dart](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart) | AuthRepositoryImpl | See source ownership; no static cache declaration in this file. |
| [lib/features/auth/domain/repositories/auth_repository.dart](/Users/alimegahed/power_saving/lib/features/auth/domain/repositories/auth_repository.dart) | AuthRepository | See source ownership; no static cache declaration in this file. |
| [lib/features/bill/binding/bills_binding.dart](/Users/alimegahed/power_saving/lib/features/bill/binding/bills_binding.dart) | BillsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/bill/binding/techbills_binding.dart](/Users/alimegahed/power_saving/lib/features/bill/binding/techbills_binding.dart) | TechBillsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/bill/controller/all_bills.dart](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart) | AllBills | static Map<String, dynamic>? sessionCache; |
| [lib/features/bill/controller/bills.dart](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart) | Bills, PricingTier | See source ownership; no static cache declaration in this file. |
| [lib/features/bill/controller/tech_bills.dart](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart) | TechBillscontroller | static Map<String, dynamic>? sessionCache; |
| [lib/features/chemcails/binding/chemicals_binding.dart](/Users/alimegahed/power_saving/lib/features/chemcails/binding/chemicals_binding.dart) | ChemicalsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/chemcails/controller/add_chemacial.dart](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart) | addchemical | See source ownership; no static cache declaration in this file. |
| [lib/features/chemcails/controller/chemacial.dart](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart) | Chemacialcontroller | static List<dynamic>? sessionCache; |
| [lib/features/home/binding/home_binding.dart](/Users/alimegahed/power_saving/lib/features/home/binding/home_binding.dart) | HomeBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/home/controller/home.dart](/Users/alimegahed/power_saving/lib/features/home/controller/home.dart) | HomeController | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/binding/blance_binding.dart](/Users/alimegahed/power_saving/lib/features/planning/binding/blance_binding.dart) | BalanceChartBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/binding/place_types_binding.dart](/Users/alimegahed/power_saving/lib/features/planning/binding/place_types_binding.dart) | PlaceTypesBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/binding/places_binding.dart](/Users/alimegahed/power_saving/lib/features/planning/binding/places_binding.dart) | PlacesBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/controller/blance_chart/blance_chart.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart) | FutureCapacityEntry, BalanceChartController | static List<dynamic>? areasCache;; static List<dynamic>? valuesCache; |
| [lib/features/planning/controller/blance_chart/get_blance_cart.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/get_blance_cart.dart) | functions only / empty file | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/controller/place/add_places_controller.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart) | AddPlacesController | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/controller/place/edit_place_type_controller.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart) | EditPlaceTypeController | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/controller/place/edit_places_controller.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart) | EditPlacesController | See source ownership; no static cache declaration in this file. |
| [lib/features/planning/controller/place/places_controller.dart](/Users/alimegahed/power_saving/lib/features/planning/controller/place/places_controller.dart) | PlacesController | static List<dynamic>? sessionCache; |
| [lib/features/predaction/binding/prediction_binding.dart](/Users/alimegahed/power_saving/lib/features/predaction/binding/prediction_binding.dart) | PredictionBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/predaction/controller/prediaction.dart](/Users/alimegahed/power_saving/lib/features/predaction/controller/prediaction.dart) | Prediactioncontroller | See source ownership; no static cache declaration in this file. |
| [lib/features/relations/binding/relations_binding.dart](/Users/alimegahed/power_saving/lib/features/relations/binding/relations_binding.dart) | RelationsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/relations/controller/add_relations_controller.dart](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart) | addrelationcontroller | See source ownership; no static cache declaration in this file. |
| [lib/features/relations/controller/relations/relation.dart](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart) | RelationsController | static List<dynamic>? sessionCache; |
| [lib/features/reports/binding/reports_binding.dart](/Users/alimegahed/power_saving/lib/features/reports/binding/reports_binding.dart) | ReportsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/reports/controller/reports_controller.dart](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart) | ReportsController, _BranchIndex | See source ownership; no static cache declaration in this file. |
| [lib/features/stations/binding/following_stations_binding.dart](/Users/alimegahed/power_saving/lib/features/stations/binding/following_stations_binding.dart) | FollowingStationsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/stations/binding/stations_binding.dart](/Users/alimegahed/power_saving/lib/features/stations/binding/stations_binding.dart) | StationsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/stations/controller/add_stations_controller.dart](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart) | AddStationController | See source ownership; no static cache declaration in this file. |
| [lib/features/stations/controller/all_stations_controller.dart](/Users/alimegahed/power_saving/lib/features/stations/controller/all_stations_controller.dart) | StationsController | static List<dynamic>? sessionCache; |
| [lib/features/stations/controller/edit_stations_controller.dart](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart) | EditStationsController | See source ownership; no static cache declaration in this file. |
| [lib/features/stations/controller/following_stations_controller.dart](/Users/alimegahed/power_saving/lib/features/stations/controller/following_stations_controller.dart) | Station, FollowingStationsController | static List<dynamic>? sessionCache; |
| [lib/features/tech_bills/binding/new_tech_bills_binding.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/binding/new_tech_bills_binding.dart) | NewTechBillsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/tech_bills/binding/techbills_binding.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/binding/techbills_binding.dart) | TechbillsBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/tech_bills/controller/new_tech_bills.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart) | Station, NewTechBillsController | static List<dynamic>? sessionCache; |
| [lib/features/tech_bills/controller/tech_bills/edit_techbills.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/edit_techbills.dart) | EditTechbillsController | See source ownership; no static cache declaration in this file. |
| [lib/features/tech_bills/controller/tech_bills/techbills.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart) | Techbills, RxBool | See source ownership; no static cache declaration in this file. |
| [lib/features/tech_bills/controller/techbills.dart](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart) | Techbills | static List<dynamic>? sessionCache; |
| [lib/features/technology/binding/technology_binding.dart](/Users/alimegahed/power_saving/lib/features/technology/binding/technology_binding.dart) | TechnologyBinding | See source ownership; no static cache declaration in this file. |
| [lib/features/technology/controller/add_tech_controller.dart](/Users/alimegahed/power_saving/lib/features/technology/controller/add_tech_controller.dart) | AddTechController | See source ownership; no static cache declaration in this file. |
| [lib/features/technology/controller/edit_tech_controller.dart](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart) | EditTechController | See source ownership; no static cache declaration in this file. |
| [lib/features/technology/controller/technlogy.dart](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart) | TechnlogyController | static List<dynamic>? sessionCache;; // Update static cache |
| [lib/global/data.dart](/Users/alimegahed/power_saving/lib/global/data.dart) | SessionService | See source ownership; no static cache declaration in this file. |
| [lib/network/network.dart](/Users/alimegahed/power_saving/lib/network/network.dart) | ApiException | See source ownership; no static cache declaration in this file. |
| [lib/shared_pref/cache.dart](/Users/alimegahed/power_saving/lib/shared_pref/cache.dart) | Cache | static late SharedPreferences sharedPreferences; |

## Native/web and assets

| Target | Current evidence / limitation |
|---|---|
| Android | Main manifest lacks INTERNET; debug/profile declare it. Network security XML not attached in main manifest and public IP entry differs from ApiConfig. Release uses debug signing; namespace/applicationId com.example.power_saving. Merged artifact not built/verified. |
| iOS | Runner Info.plist has no HTTP exception; actual transport behavior not executed. Podfile/Xcode files retained. |
| macOS | Release sandbox entitlement lacks network.client. Signed entitlements and networking unverified. |
| Web | HashUrlStrategy, existing flutter bootstrap; raw HTML Blob print and unsandboxed iframe. Favicon path does not match tracked web-root asset. |
| Assets | images/710.png 89,792 bytes; generated PNG 4,963,638 bytes; home_bg.png 450,226 bytes. Launcher points to absent images/710.jpg. Fonts not declared as bundled assets. |

The user identifies this as an internal system. Specific supported platforms/browser/device versions and deployment TLS/chart contracts remain unspecified. Internal deployment does not change the frozen API scope or establish network trust.

## Tests and CI

Two active Dart tests exercise Result success/failure, not AuthRepositoryImpl despite the filename. widget_test.dart is commented out; native RunnerTests are template shells. No tracked CI workflows/integration_test suite found. flutter_lints is enabled and deprecated_member_use ignored. No tests/builds/analyzer/security/visual checks were executed.

## Status and approved decisions

30 original findings: **14 READY, 9 BLOCKED, 7 REQUIRES INVESTIGATION**. 23 supplemental narrative observations are cross-referenced separately without invented original severity or inflating original counts.

User-approved local authentication targets: keep public registration; reject missing/null/invalid group_id at login/startup and deny invalid-session protected navigation; retain session/navigation after successful password change when current authentication permits. Preserve valid-user roles, API schemas and protocol. The existing source represents recognized groups 1–7; do not invent new IDs. Billing answer is interpreted as preserve current code rules/calculations. No formula correction is authorized.

## Deliverables

- [baseline_report.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/baseline_report.md)
- [finding_traceability.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/finding_traceability.md)
- [api_contract_inventory.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/api_contract_inventory.md)
- [business_logic_protection.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/business_logic_protection.md)
- [implementation_plan.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/implementation_plan.md)
- [regression_test_plan.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/regression_test_plan.md)
- [blocked_items.md](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/blocked_items.md)

Machine-readable evidence: baseline_snapshot.json, traceability.json, api_contract_snapshot.json and preservation.json. Source excerpts preserve current contracts; they are not new application code. Phase 1 requires explicit authorization after these documents.

## Final preservation check

All 610 pre-existing regular files matched their Phase 0 SHA-256 snapshots, including tracked source/configuration, ignored build/cache files and the prior audit reports. No new file appeared outside this preparation directory. Only these Phase 0 documents and machine-readable evidence were authored. All seven required documents exist; their absolute links were validated. Git remains master at bf78471, with the same pre-existing pubspec.lock modification and untracked audit_reports directory. See [preservation.json](/Users/alimegahed/power_saving/audit_reports/remediation_preparation/preservation.json).
