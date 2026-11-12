# Application inventory and audit method

Audit date: 11 November 2026 (Africa/Cairo). Root: `/Users/alimegahed/power_saving`. Baseline commit: `bf78471b7b4ef8c0254d8e5eba4f79595ca45e2c`.

## Boundary and evidence

Read-only inspection of application files. Only audit deliverables were written under `audit_reports/`. The pre-existing change is `pubspec.lock` (11 insertions and 11 deletions). Its working-copy contents, rather than HEAD, are the dependency baseline. SHA-256 hashes of all 343 tracked files were recorded before the substantive review; preservation is checked separately in `preservation.json`. No application commands, package installation, builds, formatters, migrations, tests, live API calls, or browser execution were performed. Existing generated build outputs are not evidence of a current successful build.

The supplied request ends mid-sentence after “Do not claim test coverage percentages unless”. No missing requirements were invented. No coverage percentages are claimed.

Inventory scope is all tracked project paths and all 198 Dart files under lib (31,881 lines). Every Dart file received structural inventory (imports, classes, size); all 35 feature-screen files received navigation/form/state/layout pattern inspection. Detailed implementation review concentrates on shared infrastructure, feature controllers, models used in traced flows, billing, report/export, and planning interactions. This is not a claim that every line, platform boilerplate, or rendered screen was manually verified. No screenshots or runtime visual results were available.

The security-scan and UI/UX skills informed review. The security plugin managed workflow was not launched because its state/artifact writes outside this directory conflict with the explicit user boundary. No managed security scan, independent security worker result, exploit validation, or advisory database check is claimed.

## Stack

| Component | Working-copy evidence |
|---|---|
| Application | Flutter / Dart, version 1.0.0+1 |
| SDK constraints | pubspec: Dart ^3.7.2; resolved lock: Dart >=3.10.0-0 <4.0.0, Flutter >=3.35.0 |
| State/navigation/DI | GetX 4.7.2; GetMaterialApp, bindings, Obx, GetBuilder |
| Transport/storage | http 1.4.0; shared_preferences 2.5.3 |
| UI/chart/localization | fl_chart 0.69.2; google_fonts 6.3.3; dropdown_search 6.0.2; intl 0.20.2; flutter_localizations |
| Tooling | flutter_lints 5.0.0; flutter_test; Android Gradle plugin 8.7.0; Kotlin 1.8.22 |
| Platform shells | web, Android, iOS, macOS, Linux, Windows |

Exact installed Flutter version and production runtime versions were not verified. SDK metadata is not a release pin. Do not infer a dependency vulnerability from age or a newer available version.

## Modules and responsibilities

| Module | Features and current responsibility |
|---|---|
| auth | Login, password change, user creation and administration; repository abstraction for login/password only |
| home | Consumption KPIs, anomalies, drawer/sidebar role visibility, tariff dialog |
| stations | Station catalog/add/edit, station–technology selection and analysis entry |
| Counter | Meter catalog/add/edit and meter billing dialog |
| technology | Technology reference data/add/edit |
| relations | Station–meter–technology links, activation/status changes |
| chemcails | Seasonal chemical reference ranges/add/edit/search |
| bill | Paginated meter bills and technology-bill history |
| tech_bills | Operational technology bill forms, bulk-style per-card updates, historical edit |
| planning | Places, place-type ranges, area balance, future capacities, ML forecast display and print |
| predaction / analysis | Predictions and station/technology analysis charts |
| reports | 15 report type mappings, filters, tabular displays, HTML print strategies |
| core/global/shared | Theme/tokens, scaffolds/forms, error/result types, two transport systems, session/preferences and platform shims |

No backend, SQL schema, migration, database engine configuration, server authorization middleware, or API specification is present in the tracked source inventory. Database internals are outside available evidence.

## Named routes

| Route | Widget | Binding |
|---|---|---|
| `/Charts` | `SunburstPage` | `ChartsBinding` |
| `/home` | `HomeScreen` | `HomeBinding` |
| `/change_password` | `ChangePassword` | `none in route definition` |
| `/editPlaces` | `EditPlacesScreen` | `none in route definition` |
| `/Stations` | `StationsScreen` | `StationsBinding` |
| `/Login` | `Login` | `none in route definition` |
| `/editMeter` | `EditCounterScreen` | `none in route definition` |
| `/editStations` | `EditStationsScreen` | `none in route definition` |
| `/NewUser` | `NewUser` | `none in route definition` |
| `/addstations` | `AddStationScreen` | `none in route definition` |
| `/Technology` | `Technology` | `TechnologyBinding` |
| `/all_users` | `AllUserScreen` | `AllUserBinding` |
| `/EditTechBills` | `EditTechBills` | `none in route definition` |
| `/Places` | `PlacesScreen` | `PlacesBinding` |
| `/placeTypes` | `PlaceTypesListScreen` | `PlaceTypesBinding` |
| `/AddPlaces` | `AddPlacesScreen` | `none in route definition` |
| `/BlanceCart` | `BlanceCart` | `BalanceChartBinding` |
| `/BalanceChartPrintScreen` | `BalanceChartPrintScreen` | `none in route definition` |
| `/Edittech` | `EditTechScreen` | `none in route definition` |
| `/Reports` | `Reports` | `ReportsBinding` |
| `/Predictions` | `Predaction` | `PredictionBinding` |
| `/analysis` | `AnalysisView` | `none in route definition` |
| `/addTech` | `AddTechScreen` | `none in route definition` |
| `/bills` | `Bills` | `BillsBinding` |
| `/techBill` | `TechBill` | `TechBillsBinding` |
| `/Countrts` | `Counterscreen` | `CounterBinding` |
| `/addCounter` | `AddElectricMeterScreen` | `none in route definition` |
| `/NewTechBills` | `NewTechBillsScreen` | `NewTechBillsBinding` |
| `/FollowingStations` | `FollowingStationsScreen` | `FollowingStationsBinding` |
| `/Relations` | `RelationsScreen` | `RelationsBinding` |
| `/Addrelation` | `AddRelationScreen` | `none in route definition` |
| `/Chemicals` | `Chemicals` | `ChemicalsBinding` |
| `/AddChemicalScreen` | `AddChemicalScreen` | `none in route definition` |
| `/techbills` | `TechBills` | `TechbillsBinding` |
| `/EditChemcials` | `EditChemcials` | `none in route definition` |
| `/AnimatedGauge` | `AnimatedGauge` | `none in route definition` |

The ML forecast screen is pushed as a widget from BalanceChartController rather than a named route. `/Charts` and `/AnimatedGauge` are outside the conventional feature-screen directory. Some legacy/demo files are not part of a verified production journey. Naming and case differences are inventoried, not assumed to be defects.

## API call-site inventory

These are source references only; no endpoints were called. A GET named “edit” is not assumed safe. The endpoint expressions retain placeholders rather than disclosing runtime data.

| File/line | Expression |
|---|---|
| [lib/controller/voltage/financial.dart:24](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:24) | `final res = await fetchData("${ApiConfig.baseUrl}/financial-analysis");` |
| [lib/controller/voltage/voltage.dart:43](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:43) | `"${ApiConfig.baseUrl}/voltage-costs",` |
| [lib/controller/voltage/voltage.dart:79](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:79) | `"${ApiConfig.baseUrl}/edit-v-cost/$voltid",` |
| [lib/features/Counter/controller/add_counter_controller.dart:49](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:49) | `"${ApiConfig.baseUrl}/new-gauge",` |
| [lib/features/Counter/controller/add_counter_controller.dart:73](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:73) | `"${ApiConfig.baseUrl}/new-gauge",` |
| [lib/features/Counter/controller/counter.dart:152](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:152) | `final response = await fetchData("${ApiConfig.baseUrl}/gauges");` |
| [lib/features/Counter/controller/counter.dart:196](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:196) | `"${ApiConfig.baseUrl}/new-station",` |
| [lib/features/Counter/controller/edit_counter_controller.dart:51](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:51) | `"${ApiConfig.baseUrl}/edit-gauge",` |
| [lib/features/Counter/controller/edit_counter_controller.dart:79](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:79) | `"${ApiConfig.baseUrl}/new-gauge",` |
| [lib/features/analysis/controller/analysis.dart:16](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:16) | `"${ApiConfig.baseUrl}/analysis-single/$station/$tech"` |
| [lib/features/auth/controller/all_user.dart:36](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:36) | `final res = await fetchData("${ApiConfig.baseUrl}/all-users");` |
| [lib/features/auth/controller/all_user.dart:129](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:129) | `"${ApiConfig.baseUrl}/edit-user/${editedUser.empCode}",` |
| [lib/features/auth/controller/new_user.dart:50](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:50) | `"${ApiConfig.baseUrl}/register",` |
| [lib/features/auth/data/repositories/auth_repository_impl.dart:20](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:20) | `"${ApiConfig.baseUrl}/login",` |
| [lib/features/auth/data/repositories/auth_repository_impl.dart:45](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:45) | `"${ApiConfig.baseUrl}/change-password",` |
| [lib/features/bill/controller/all_bills.dart:152](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:152) | `Uri uri = Uri.parse("${ApiConfig.baseUrl}/view-bills").replace(queryParameters: queryParams);` |
| [lib/features/bill/controller/bills.dart:262](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:262) | `final res = await fetchData("${ApiConfig.baseUrl}/new-bill/$accountNumber");` |
| [lib/features/bill/controller/bills.dart:304](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:304) | `"${ApiConfig.baseUrl}/new-bill/$number",` |
| [lib/features/bill/controller/tech_bills.dart:83](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:83) | `final uri = Uri.parse("${ApiConfig.baseUrl}/view-tech-bills").replace(queryParameters: queryParams);` |
| [lib/features/chemcails/controller/add_chemacial.dart:57](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:57) | `"${ApiConfig.baseUrl}/new-chemical",` |
| [lib/features/chemcails/controller/add_chemacial.dart:91](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:91) | `"${ApiConfig.baseUrl}/edit-chemical/$id",` |
| [lib/features/chemcails/controller/add_chemacial.dart:119](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:119) | `"${ApiConfig.baseUrl}/new-chemical"` |
| [lib/features/chemcails/controller/chemacial.dart:78](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:78) | `final res = await fetchData("${ApiConfig.baseUrl}/chemicals");` |
| [lib/features/planning/controller/blance_chart/blance_chart.dart:107](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:107) | `final response = await fetchData("${ApiConfig.baseUrl}/all-areas");` |
| [lib/features/planning/controller/blance_chart/blance_chart.dart:140](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:140) | `final response = await fetchData("${ApiConfig.baseUrl}/place-types");` |
| [lib/features/planning/controller/blance_chart/blance_chart.dart:202](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:202) | `"${ApiConfig.baseUrl}/balance-plot-calc/$id",` |
| [lib/features/planning/controller/place/add_places_controller.dart:49](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:49) | `"${ApiConfig.baseUrl}/new-place",` |
| [lib/features/planning/controller/place/add_places_controller.dart:74](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:74) | `"${ApiConfig.baseUrl}/new-place",` |
| [lib/features/planning/controller/place/edit_place_type_controller.dart:44](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:44) | `final response = await fetchData("${ApiConfig.baseUrl}/place-types");` |
| [lib/features/planning/controller/place/edit_place_type_controller.dart:76](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:76) | `"${ApiConfig.baseUrl}/edit-place-type/$placeTypeId",` |
| [lib/features/planning/controller/place/edit_places_controller.dart:49](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:49) | `"${ApiConfig.baseUrl}/edit-place/${place.placeId}",` |
| [lib/features/planning/controller/place/edit_places_controller.dart:74](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:74) | `"${ApiConfig.baseUrl}/new-place",` |
| [lib/features/planning/controller/place/places_controller.dart:81](/Users/alimegahed/power_saving/lib/features/planning/controller/place/places_controller.dart:81) | `final response = await fetchData("${ApiConfig.baseUrl}/places");` |
| [lib/features/predaction/controller/prediaction.dart:17](/Users/alimegahed/power_saving/lib/features/predaction/controller/prediaction.dart:17) | `final res = await postData("${ApiConfig.baseUrl}/prediction/$stationId", {});` |
| [lib/features/relations/controller/add_relations_controller.dart:41](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:41) | `"${ApiConfig.baseUrl}/new-relation",` |
| [lib/features/relations/controller/add_relations_controller.dart:80](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:80) | `"${ApiConfig.baseUrl}/new-relation",` |
| [lib/features/relations/controller/relations/relation.dart:80](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:80) | `final response = await fetchData("${ApiConfig.baseUrl}/stg-relations");` |
| [lib/features/relations/controller/relations/relation.dart:123](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:123) | `final response = await fetchData("${ApiConfig.baseUrl}/edit-relation/$id");` |
| [lib/features/reports/controller/reports_controller.dart:202](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:202) | `"${ApiConfig.baseUrl}/reports",` |
| [lib/features/stations/controller/add_stations_controller.dart:56](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:56) | `"${ApiConfig.baseUrl}/new-station",` |
| [lib/features/stations/controller/add_stations_controller.dart:88](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:88) | `final response = await fetchData("${ApiConfig.baseUrl}/all-areas");` |
| [lib/features/stations/controller/add_stations_controller.dart:106](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:106) | `"${ApiConfig.baseUrl}/new-station",` |
| [lib/features/stations/controller/all_stations_controller.dart:78](/Users/alimegahed/power_saving/lib/features/stations/controller/all_stations_controller.dart:78) | `final response = await fetchData("${ApiConfig.baseUrl}/stations");` |
| [lib/features/stations/controller/edit_stations_controller.dart:52](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:52) | `"${ApiConfig.baseUrl}/new-station",` |
| [lib/features/stations/controller/edit_stations_controller.dart:70](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:70) | `final response = await fetchData("${ApiConfig.baseUrl}/all-areas");` |
| [lib/features/stations/controller/edit_stations_controller.dart:98](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:98) | `"${ApiConfig.baseUrl}/edit-station/$Stations_id",` |
| [lib/features/stations/controller/following_stations_controller.dart:67](/Users/alimegahed/power_saving/lib/features/stations/controller/following_stations_controller.dart:67) | `final res = await fetchData("${ApiConfig.baseUrl}/station-techs");` |
| [lib/features/tech_bills/controller/new_tech_bills.dart:121](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:121) | `final res = await fetchData("${ApiConfig.baseUrl}/station-techs");` |
| [lib/features/tech_bills/controller/new_tech_bills.dart:181](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:181) | `await postData("${ApiConfig.baseUrl}/insert-or-edit-tech-bill", {` |
| [lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:74](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:74) | `"${ApiConfig.baseUrl}/edit-old-tech-bills/$id",` |
| [lib/features/tech_bills/controller/tech_bills/techbills.dart:133](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:133) | `final res = await fetchData("${ApiConfig.baseUrl}/tech-bills");` |
| [lib/features/tech_bills/controller/tech_bills/techbills.dart:166](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:166) | `"${ApiConfig.baseUrl}/edit-tech-bill/$id",` |
| [lib/features/tech_bills/controller/techbills.dart:223](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:223) | `final res = await fetchData("${ApiConfig.baseUrl}/tech-bills");` |
| [lib/features/tech_bills/controller/techbills.dart:275](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:275) | `"${ApiConfig.baseUrl}/edit-tech-bill/$id",` |
| [lib/features/technology/controller/add_tech_controller.dart:54](/Users/alimegahed/power_saving/lib/features/technology/controller/add_tech_controller.dart:54) | `"${ApiConfig.baseUrl}/new-tech",` |
| [lib/features/technology/controller/edit_tech_controller.dart:42](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:42) | `"${ApiConfig.baseUrl}/edit-tech/$id",` |
| [lib/features/technology/controller/technlogy.dart:132](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:132) | `final res = await fetchData("${ApiConfig.baseUrl}/technologies");` |
| [lib/features/technology/controller/technlogy.dart:185](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:185) | `"${ApiConfig.baseUrl}/new-tech",` |

## Import cycles

A static import/export graph found three multi-file strongly connected components. Dart permits cycles; these are coupling evidence, not compiler failures. Conditional imports were not exhaustively modeled.

- [lib/core/repositories/base_repository.dart:1](/Users/alimegahed/power_saving/lib/core/repositories/base_repository.dart:1); [lib/features/auth/controller/login.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/login.dart:1); [lib/features/auth/data/repositories/auth_repository_impl.dart:1](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:1); [lib/features/auth/view/screens/login.dart:1](/Users/alimegahed/power_saving/lib/features/auth/view/screens/login.dart:1)

- [lib/features/planning/controller/blance_chart/blance_chart.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:1); [lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:1); [lib/features/planning/view/widgets/balance_widgets/area_station.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/area_station.dart:1); [lib/features/planning/view/widgets/balance_widgets/chart_sctions.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/chart_sctions.dart:1); [lib/features/planning/view/widgets/balance_widgets/places_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/places_table.dart:1); [lib/features/planning/view/widgets/balance_widgets/station_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/station_table.dart:1); [lib/features/planning/view/widgets/balance_widgets/summery.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/summery.dart:1); [lib/features/planning/view/widgets/balance_widgets/water_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/water_table.dart:1)

- [lib/features/reports/view/screens/report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:1); [lib/features/reports/view/widgets/bills_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/bills_report.dart:1); [lib/features/reports/view/widgets/branch_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:1); [lib/features/reports/view/widgets/over_chlorine_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_chlorine_report.dart:1); [lib/features/reports/view/widgets/over_liquid_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_liquid_report.dart:1); [lib/features/reports/view/widgets/over_powe_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_powe_report.dart:1); [lib/features/reports/view/widgets/over_soild_alum.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_soild_alum.dart:1); [lib/features/reports/view/widgets/power_zero_water.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/power_zero_water.dart:1); [lib/features/reports/view/widgets/station_total.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/station_total.dart:1); [lib/features/reports/view/widgets/stations_bills_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/stations_bills_report.dart:1); [lib/features/reports/view/widgets/tech3_mont_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/tech3_mont_report.dart:1); [lib/features/reports/view/widgets/technology_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/technology_report.dart:1)

## Source inventory

JSON companion: `source_inventory.json` includes all paths, classes, imports, routes, API locations, and cycles. Lines count physical source lines, including comments and blanks.

| Path | Lines | Declared classes |
|---|---:|---|
| [lib/controller/binding/charts_binding.dart:1](/Users/alimegahed/power_saving/lib/controller/binding/charts_binding.dart:1) | 9 | ChartsBinding |
| [lib/controller/voltage/financial.dart:1](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:1) | 43 | FinancialController |
| [lib/controller/voltage/voltage.dart:1](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:1) | 92 | Voltage |
| [lib/core/constant/AppDimensions.dart:1](/Users/alimegahed/power_saving/lib/core/constant/AppDimensions.dart:1) | 127 | AppColors, AppTextStyles, AppDimensions |
| [lib/core/constant/colors.dart:1](/Users/alimegahed/power_saving/lib/core/constant/colors.dart:1) | 149 | AppColors, AppGradients |
| [lib/core/constant/styles.dart:1](/Users/alimegahed/power_saving/lib/core/constant/styles.dart:1) | 75 | AppTextStyles |
| [lib/core/errors/exceptions.dart:1](/Users/alimegahed/power_saving/lib/core/errors/exceptions.dart:1) | 58 | AppException, NetworkException, ValidationException, AuthenticationException, ParsingException, ServerException, ExceptionMapper |
| [lib/core/errors/failures.dart:1](/Users/alimegahed/power_saving/lib/core/errors/failures.dart:1) | 49 | Failure, NetworkFailure, ValidationFailure, AuthenticationFailure, ParsingFailure, ServerFailure |
| [lib/core/helpers/extensions.dart:1](/Users/alimegahed/power_saving/lib/core/helpers/extensions.dart:1) | 16 | — |
| [lib/core/network/api_client.dart:1](/Users/alimegahed/power_saving/lib/core/network/api_client.dart:1) | 121 | ApiClient |
| [lib/core/repositories/base_repository.dart:1](/Users/alimegahed/power_saving/lib/core/repositories/base_repository.dart:1) | 72 | providing, BaseRepository |
| [lib/core/utils/result.dart:1](/Users/alimegahed/power_saving/lib/core/utils/result.dart:1) | 54 | Result, Success, FailureResult |
| [lib/core/widgets/accessible_focus_wrapper.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/accessible_focus_wrapper.dart:1) | 66 | AccessibleFocusWrapper, _AccessibleFocusWrapperState |
| [lib/core/widgets/app_scaffold.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/app_scaffold.dart:1) | 52 | AppScaffold |
| [lib/core/widgets/breadcrumbs.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/breadcrumbs.dart:1) | 50 | Breadcrumbs |
| [lib/core/widgets/buttons.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/buttons.dart:1) | 168 | PrimaryButton, ReusableActionButton, ReusableFooter |
| [lib/core/widgets/custom_app_bar.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/custom_app_bar.dart:1) | 63 | CustomAppBar |
| [lib/core/widgets/empty_widget.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/empty_widget.dart:1) | 73 | ReusableEmptyView |
| [lib/core/widgets/enterprise_card.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/enterprise_card.dart:1) | 71 | EnterpriseCard |
| [lib/core/widgets/form_card.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/form_card.dart:1) | 32 | FormCard |
| [lib/core/widgets/main_screen/body_widget.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/main_screen/body_widget.dart:1) | 1 | — |
| [lib/core/widgets/main_screen/main_card_widgets.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/main_screen/main_card_widgets.dart:1) | 84 | CardHeader, InfoCard |
| [lib/core/widgets/main_screen/reuseable_appbar.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/main_screen/reuseable_appbar.dart:1) | 118 | ReusableAppBar, _IconAction |
| [lib/core/widgets/main_screen/totl_header.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/main_screen/totl_header.dart:1) | 78 | TotalHeader |
| [lib/core/widgets/offline_banner.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/offline_banner.dart:1) | 74 | OfflineBanner |
| [lib/core/widgets/responsive_wrapper.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/responsive_wrapper.dart:1) | 44 | ResponsiveWrapper |
| [lib/core/widgets/rtl_scafold.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/rtl_scafold.dart:1) | 27 | RTLScaffold |
| [lib/core/widgets/section_header.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/section_header.dart:1) | 49 | SectionHeader |
| [lib/core/widgets/shimmer_loading.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/shimmer_loading.dart:1) | 92 | ShimmerLoading, _ShimmerLoadingState, ShimmerStatCard |
| [lib/core/widgets/widget.dart:1](/Users/alimegahed/power_saving/lib/core/widgets/widget.dart:1) | 1 | — |
| [lib/features/Counter/binding/counter_binding.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/binding/counter_binding.dart:1) | 9 | CounterBinding |
| [lib/features/Counter/controller/add_counter_controller.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:1) | 92 | addcounter |
| [lib/features/Counter/controller/counter.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:1) | 232 | CounterController |
| [lib/features/Counter/controller/edit_counter_controller.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:1) | 102 | EditCounter |
| [lib/features/Counter/model/Counter_model.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/model/Counter_model.dart:1) | 82 | ElectricMeter, VoltageType |
| [lib/features/Counter/view/screens/Counter.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:1) | 1289 | Counterscreen, _CounterCard |
| [lib/features/Counter/view/screens/add_Counter.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/add_Counter.dart:1) | 166 | AddElectricMeterScreen |
| [lib/features/Counter/view/screens/edit_counter.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/edit_counter.dart:1) | 161 | EditCounterScreen |
| [lib/features/Counter/view/widgets/counter_branch_list.dart:1](/Users/alimegahed/power_saving/lib/features/Counter/view/widgets/counter_branch_list.dart:1) | 54 | CounterBranchStats |
| [lib/features/Ploitly.dart:1](/Users/alimegahed/power_saving/lib/features/Ploitly.dart:1) | 50 | SunburstPage |
| [lib/features/analysis/controller/analysis.dart:1](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:1) | 32 | Analysis |
| [lib/features/analysis/model/analysis.dart:1](/Users/alimegahed/power_saving/lib/features/analysis/model/analysis.dart:1) | 24 | AnalysisModel |
| [lib/features/analysis/view/screen/analysis.dart:1](/Users/alimegahed/power_saving/lib/features/analysis/view/screen/analysis.dart:1) | 502 | AnalysisView |
| [lib/features/auth/binding/all_user_binding.dart:1](/Users/alimegahed/power_saving/lib/features/auth/binding/all_user_binding.dart:1) | 9 | AllUserBinding |
| [lib/features/auth/controller/all_user.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:1) | 268 | AllUserController |
| [lib/features/auth/controller/chang_password.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/chang_password.dart:1) | 52 | ChangePasswordController |
| [lib/features/auth/controller/login.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/login.dart:1) | 56 | LoginController |
| [lib/features/auth/controller/logout.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/logout.dart:1) | 0 | — |
| [lib/features/auth/controller/new_user.dart:1](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:1) | 79 | NewUsercontroller |
| [lib/features/auth/data/repositories/auth_repository_impl.dart:1](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:1) | 55 | AuthRepositoryImpl |
| [lib/features/auth/domain/repositories/auth_repository.dart:1](/Users/alimegahed/power_saving/lib/features/auth/domain/repositories/auth_repository.dart:1) | 11 | AuthRepository |
| [lib/features/auth/model/login.dart:1](/Users/alimegahed/power_saving/lib/features/auth/model/login.dart:1) | 42 | User |
| [lib/features/auth/view/screens/all_user.dart:1](/Users/alimegahed/power_saving/lib/features/auth/view/screens/all_user.dart:1) | 695 | AllUserScreen |
| [lib/features/auth/view/screens/change_password.dart:1](/Users/alimegahed/power_saving/lib/features/auth/view/screens/change_password.dart:1) | 227 | ChangePassword |
| [lib/features/auth/view/screens/login.dart:1](/Users/alimegahed/power_saving/lib/features/auth/view/screens/login.dart:1) | 372 | Login |
| [lib/features/auth/view/screens/new_user.dart:1](/Users/alimegahed/power_saving/lib/features/auth/view/screens/new_user.dart:1) | 274 | NewUser |
| [lib/features/bill/binding/bills_binding.dart:1](/Users/alimegahed/power_saving/lib/features/bill/binding/bills_binding.dart:1) | 9 | BillsBinding |
| [lib/features/bill/binding/techbills_binding.dart:1](/Users/alimegahed/power_saving/lib/features/bill/binding/techbills_binding.dart:1) | 9 | TechBillsBinding |
| [lib/features/bill/controller/all_bills.dart:1](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:1) | 313 | AllBills |
| [lib/features/bill/controller/bills.dart:1](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:1) | 347 | Bills, PricingTier |
| [lib/features/bill/controller/tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:1) | 282 | TechBillscontroller |
| [lib/features/bill/model/bills_model.dart:1](/Users/alimegahed/power_saving/lib/features/bill/model/bills_model.dart:1) | 117 | GuageBill |
| [lib/features/bill/view/screens/Tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/bill/view/screens/Tech_bills.dart:1) | 667 | TechBill |
| [lib/features/bill/view/screens/bills.dart:1](/Users/alimegahed/power_saving/lib/features/bill/view/screens/bills.dart:1) | 415 | Bills |
| [lib/features/chemcails/binding/chemicals_binding.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/binding/chemicals_binding.dart:1) | 9 | ChemicalsBinding |
| [lib/features/chemcails/controller/add_chemacial.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:1) | 140 | addchemical |
| [lib/features/chemcails/controller/chemacial.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:1) | 174 | Chemacialcontroller |
| [lib/features/chemcails/model/chemacial.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/model/chemacial.dart:1) | 64 | AlumChlorineReference |
| [lib/features/chemcails/view/screens/add_cemicals.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/screens/add_cemicals.dart:1) | 294 | AddChemicalScreen |
| [lib/features/chemcails/view/screens/chemicals.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/screens/chemicals.dart:1) | 56 | Chemicals |
| [lib/features/chemcails/view/screens/edit_chemcials.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/screens/edit_chemcials.dart:1) | 511 | EditChemcials |
| [lib/features/chemcails/view/widgets/chemical_body.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/widgets/chemical_body.dart:1) | 197 | ChemicalsBody |
| [lib/features/chemcails/view/widgets/chemical_card.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/widgets/chemical_card.dart:1) | 347 | ChemicalCard |
| [lib/features/chemcails/view/widgets/range.dart:1](/Users/alimegahed/power_saving/lib/features/chemcails/view/widgets/range.dart:1) | 0 | — |
| [lib/features/home/binding/home_binding.dart:1](/Users/alimegahed/power_saving/lib/features/home/binding/home_binding.dart:1) | 9 | HomeBinding |
| [lib/features/home/controller/home.dart:1](/Users/alimegahed/power_saving/lib/features/home/controller/home.dart:1) | 72 | HomeController |
| [lib/features/home/home_constant/constant.dart:1](/Users/alimegahed/power_saving/lib/features/home/home_constant/constant.dart:1) | 139 | AppConstants, HomeTypography, UserRoleHelper |
| [lib/features/home/model/home.dart:1](/Users/alimegahed/power_saving/lib/features/home/model/home.dart:1) | 279 | TopStationEntry, Max5Data, OverWaterStation, ConsumptionModel, OverConsump |
| [lib/features/home/view/screens/home.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/screens/home.dart:1) | 1715 | _T, HomeScreen, _DashCard, _SkeletonContainer, _SkeletonContainerState, _TabConfig, _HoverStatCard, _HoverStatCardState |
| [lib/features/home/view/widgets/consumpation_card.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/consumpation_card.dart:1) | 288 | ConsumptionCard, _ConsumptionCardState, _DetailItem |
| [lib/features/home/view/widgets/empaty.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/empaty.dart:1) | 66 | EmptyStateWidget |
| [lib/features/home/view/widgets/enterprise_sidebar.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:1) | 177 | EnterpriseSidebar |
| [lib/features/home/view/widgets/home_app_bar.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/home_app_bar.dart:1) | 45 | HomeAppBar |
| [lib/features/home/view/widgets/home_drawer.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/home_drawer.dart:1) | 328 | HomeDrawer |
| [lib/features/home/view/widgets/home_header_state.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/home_header_state.dart:1) | 162 | HomeHeaderStats |
| [lib/features/home/view/widgets/navigation_helper.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/navigation_helper.dart:1) | 38 | NavigationHelper |
| [lib/features/home/view/widgets/over_consampation.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/over_consampation.dart:1) | 148 | OverConsumptionSection |
| [lib/features/home/view/widgets/over_water_stations.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/over_water_stations.dart:1) | 147 | OverWaterStationsSection |
| [lib/features/home/view/widgets/voltaige.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/voltaige.dart:1) | 170 | VoltageDialogHelper, _VoltageDialog |
| [lib/features/home/view/widgets/water_stations_card.dart:1](/Users/alimegahed/power_saving/lib/features/home/view/widgets/water_stations_card.dart:1) | 318 | WaterStationCard, _WaterDetailItem, _StatusIndicator, _ActionButton |
| [lib/features/planning/binding/blance_binding.dart:1](/Users/alimegahed/power_saving/lib/features/planning/binding/blance_binding.dart:1) | 9 | BalanceChartBinding |
| [lib/features/planning/binding/place_types_binding.dart:1](/Users/alimegahed/power_saving/lib/features/planning/binding/place_types_binding.dart:1) | 9 | PlaceTypesBinding |
| [lib/features/planning/binding/places_binding.dart:1](/Users/alimegahed/power_saving/lib/features/planning/binding/places_binding.dart:1) | 9 | PlacesBinding |
| [lib/features/planning/controller/blance_chart/blance_chart.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:1) | 262 | FutureCapacityEntry, BalanceChartController |
| [lib/features/planning/controller/blance_chart/get_blance_cart.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/get_blance_cart.dart:1) | 0 | — |
| [lib/features/planning/controller/place/add_places_controller.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:1) | 97 | AddPlacesController |
| [lib/features/planning/controller/place/edit_place_type_controller.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:1) | 107 | EditPlaceTypeController |
| [lib/features/planning/controller/place/edit_places_controller.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:1) | 97 | EditPlacesController |
| [lib/features/planning/controller/place/places_controller.dart:1](/Users/alimegahed/power_saving/lib/features/planning/controller/place/places_controller.dart:1) | 176 | PlacesController |
| [lib/features/planning/model/all_places_model.dart:1](/Users/alimegahed/power_saving/lib/features/planning/model/all_places_model.dart:1) | 136 | Place, PopulationsModel, PlaceType |
| [lib/features/planning/model/area_model.dart:1](/Users/alimegahed/power_saving/lib/features/planning/model/area_model.dart:1) | 28 | AreaOfService |
| [lib/features/planning/model/blance_model.dart:1](/Users/alimegahed/power_saving/lib/features/planning/model/blance_model.dart:1) | 199 | WaterData, WaterDataResponse, AreaData, Place, Population |
| [lib/features/planning/model/ml_forecast_model.dart:1](/Users/alimegahed/power_saving/lib/features/planning/model/ml_forecast_model.dart:1) | 134 | MLDataQuality, MLSaturationResult, MLForecastResponse |
| [lib/features/planning/model/populations_model.dart:1](/Users/alimegahed/power_saving/lib/features/planning/model/populations_model.dart:1) | 43 | PopulationsModel |
| [lib/features/planning/view/screens/blance_chart/blance.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/blance.dart:1) | 817 | BlanceCart |
| [lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart:1) | 675 | BalanceChartPrintScreen, _BalanceChartPrintScreenState |
| [lib/features/planning/view/screens/blance_chart/ml_forecast_result_screen.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/blance_chart/ml_forecast_result_screen.dart:1) | 1097 | MLForecastResultScreen, _MLForecastResultScreenState |
| [lib/features/planning/view/screens/places/add_places.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/places/add_places.dart:1) | 146 | AddPlacesScreen |
| [lib/features/planning/view/screens/places/edit_places.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/places/edit_places.dart:1) | 219 | EditPlacesScreen |
| [lib/features/planning/view/screens/places/place_types_list_screen.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/places/place_types_list_screen.dart:1) | 561 | PlaceTypesListScreen |
| [lib/features/planning/view/screens/places/places.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/screens/places/places.dart:1) | 128 | PlacesScreen |
| [lib/features/planning/view/widgets/balance_widgets/area_station.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/area_station.dart:1) | 113 | AreaSection, _SectionHeader, InfoItem |
| [lib/features/planning/view/widgets/balance_widgets/chart_sctions.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/chart_sctions.dart:1) | 94 | ChartSection, _ChartImage, _EmptyChart |
| [lib/features/planning/view/widgets/balance_widgets/header_cell.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/header_cell.dart:1) | 41 | TableHeader, TableCells |
| [lib/features/planning/view/widgets/balance_widgets/places_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/places_table.dart:1) | 89 | PlacesTable |
| [lib/features/planning/view/widgets/balance_widgets/report_header.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/report_header.dart:1) | 43 | ReportHeader |
| [lib/features/planning/view/widgets/balance_widgets/station_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/station_table.dart:1) | 76 | StationsTable |
| [lib/features/planning/view/widgets/balance_widgets/summery.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/summery.dart:1) | 127 | SummarySection, SummaryCard |
| [lib/features/planning/view/widgets/balance_widgets/water_table.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/balance_widgets/water_table.dart:1) | 81 | WaterDataTable |
| [lib/features/planning/view/widgets/place_widget/place_card.dart:1](/Users/alimegahed/power_saving/lib/features/planning/view/widgets/place_widget/place_card.dart:1) | 111 | PlaceCard |
| [lib/features/predaction/binding/prediction_binding.dart:1](/Users/alimegahed/power_saving/lib/features/predaction/binding/prediction_binding.dart:1) | 11 | PredictionBinding |
| [lib/features/predaction/controller/prediaction.dart:1](/Users/alimegahed/power_saving/lib/features/predaction/controller/prediaction.dart:1) | 34 | Prediactioncontroller |
| [lib/features/predaction/model/predication.dart:1](/Users/alimegahed/power_saving/lib/features/predaction/model/predication.dart:1) | 33 | PredictionModel |
| [lib/features/predaction/predaction.dart:1](/Users/alimegahed/power_saving/lib/features/predaction/predaction.dart:1) | 264 | Predaction |
| [lib/features/predaction/view/screens/predaction.dart:1](/Users/alimegahed/power_saving/lib/features/predaction/view/screens/predaction.dart:1) | 425 | Predaction |
| [lib/features/relations/binding/relations_binding.dart:1](/Users/alimegahed/power_saving/lib/features/relations/binding/relations_binding.dart:1) | 9 | RelationsBinding |
| [lib/features/relations/controller/add_relations_controller.dart:1](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:1) | 111 | addrelationcontroller |
| [lib/features/relations/controller/relations/relation.dart:1](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:1) | 205 | RelationsController |
| [lib/features/relations/model/relations.dart:1](/Users/alimegahed/power_saving/lib/features/relations/model/relations.dart:1) | 51 | StationGaugeTechnologyRelation |
| [lib/features/relations/view/screens/add_relation.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/screens/add_relation.dart:1) | 153 | AddRelationScreen |
| [lib/features/relations/view/screens/relatiuons.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/screens/relatiuons.dart:1) | 39 | RelationsScreen |
| [lib/features/relations/view/widgets/body.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/widgets/body.dart:1) | 192 | RelationsBody |
| [lib/features/relations/view/widgets/grid.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/widgets/grid.dart:1) | 41 | RelationsGrid |
| [lib/features/relations/view/widgets/header.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/widgets/header.dart:1) | 74 | HeaderCard |
| [lib/features/relations/view/widgets/relations_card.dart:1](/Users/alimegahed/power_saving/lib/features/relations/view/widgets/relations_card.dart:1) | 291 | RelationsCard, _RelationsCardState, _DetailRow |
| [lib/features/reports/binding/reports_binding.dart:1](/Users/alimegahed/power_saving/lib/features/reports/binding/reports_binding.dart:1) | 9 | ReportsBinding |
| [lib/features/reports/controller/reports_controller.dart:1](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:1) | 279 | ReportsController, _BranchIndex |
| [lib/features/reports/model/report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/model/report.dart:1) | 125 | ReportBranch |
| [lib/features/reports/view/screens/report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/screens/report.dart:1) | 949 | Reports, BaseReportTable, ReportTableFactory, BaseReportPrinter, ReportPrinterFactory |
| [lib/features/reports/view/widgets/bills_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/bills_report.dart:1) | 58 | BillsReportTable, BillsReportPrinter |
| [lib/features/reports/view/widgets/branch_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/branch_report.dart:1) | 70 | BranchReportTable, BranchReportPrinter |
| [lib/features/reports/view/widgets/over_chlorine_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_chlorine_report.dart:1) | 75 | OverChlorineReport, OverChlorineReportPrinter |
| [lib/features/reports/view/widgets/over_liquid_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_liquid_report.dart:1) | 75 | OverLiquidAlumReport, OverLiquidAlumReportPrinter |
| [lib/features/reports/view/widgets/over_powe_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_powe_report.dart:1) | 70 | OverPoweReport, OverPowerReportPrinter |
| [lib/features/reports/view/widgets/over_soild_alum.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/over_soild_alum.dart:1) | 75 | OverSolidAlumReport, OverSolidAlumReportPrinter |
| [lib/features/reports/view/widgets/power_zero_water.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/power_zero_water.dart:1) | 62 | PowerZeroWaterReport, PowerZeroWaterReportPrinter |
| [lib/features/reports/view/widgets/station_total.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/station_total.dart:1) | 72 | StationTotalReportTable, StationTotalReportPrinter |
| [lib/features/reports/view/widgets/stations_bills_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/stations_bills_report.dart:1) | 41 | StationBillsReportTable, StationBillsReportPrinter |
| [lib/features/reports/view/widgets/tech3_mont_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/tech3_mont_report.dart:1) | 71 | Techs3MonthReportTable, Techs3MonthReportPrinter |
| [lib/features/reports/view/widgets/technology_report.dart:1](/Users/alimegahed/power_saving/lib/features/reports/view/widgets/technology_report.dart:1) | 72 | TechnologyReportTable, TechnologyReportPrinter |
| [lib/features/stations/binding/following_stations_binding.dart:1](/Users/alimegahed/power_saving/lib/features/stations/binding/following_stations_binding.dart:1) | 9 | FollowingStationsBinding |
| [lib/features/stations/binding/stations_binding.dart:1](/Users/alimegahed/power_saving/lib/features/stations/binding/stations_binding.dart:1) | 9 | StationsBinding |
| [lib/features/stations/controller/add_stations_controller.dart:1](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:1) | 120 | AddStationController |
| [lib/features/stations/controller/all_stations_controller.dart:1](/Users/alimegahed/power_saving/lib/features/stations/controller/all_stations_controller.dart:1) | 162 | StationsController |
| [lib/features/stations/controller/edit_stations_controller.dart:1](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:1) | 134 | EditStationsController |
| [lib/features/stations/controller/following_stations_controller.dart:1](/Users/alimegahed/power_saving/lib/features/stations/controller/following_stations_controller.dart:1) | 116 | Station, FollowingStationsController |
| [lib/features/stations/model/station_model.dart:1](/Users/alimegahed/power_saving/lib/features/stations/model/station_model.dart:1) | 125 | Station, Branch, allstations, WaterSource, AddStationData |
| [lib/features/stations/view/screens/add_station.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/screens/add_station.dart:1) | 187 | AddStationScreen |
| [lib/features/stations/view/screens/edit_staion.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/screens/edit_staion.dart:1) | 258 | EditStationsScreen |
| [lib/features/stations/view/screens/following_stations.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/screens/following_stations.dart:1) | 476 | FollowingStationsScreen |
| [lib/features/stations/view/screens/stations.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/screens/stations.dart:1) | 50 | StationsScreen |
| [lib/features/stations/view/widgets/branch_list.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/widgets/branch_list.dart:1) | 54 | BranchStats |
| [lib/features/stations/view/widgets/stations_body.dart:1](/Users/alimegahed/power_saving/lib/features/stations/view/widgets/stations_body.dart:1) | 199 | StationsBody, _StationCard, _StationInfoGrid |
| [lib/features/tech_bills/binding/new_tech_bills_binding.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/binding/new_tech_bills_binding.dart:1) | 9 | NewTechBillsBinding |
| [lib/features/tech_bills/binding/techbills_binding.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/binding/techbills_binding.dart:1) | 9 | TechbillsBinding |
| [lib/features/tech_bills/controller/new_tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:1) | 251 | Station, NewTechBillsController |
| [lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:1) | 109 | EditTechbillsController |
| [lib/features/tech_bills/controller/tech_bills/techbills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:1) | 199 | Techbills, RxBool |
| [lib/features/tech_bills/controller/techbills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:1) | 313 | Techbills |
| [lib/features/tech_bills/model/tech_bill.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/model/tech_bill.dart:1) | 110 | TechnologyBill |
| [lib/features/tech_bills/view/screens/edit_tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/edit_tech_bills.dart:1) | 452 | EditTechBills |
| [lib/features/tech_bills/view/screens/new_tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/new_tech_bills.dart:1) | 456 | NewTechBillsScreen |
| [lib/features/tech_bills/view/screens/tech_bills.dart:1](/Users/alimegahed/power_saving/lib/features/tech_bills/view/screens/tech_bills.dart:1) | 761 | TechBills, _TechBillCard |
| [lib/features/technology/binding/technology_binding.dart:1](/Users/alimegahed/power_saving/lib/features/technology/binding/technology_binding.dart:1) | 9 | TechnologyBinding |
| [lib/features/technology/controller/add_tech_controller.dart:1](/Users/alimegahed/power_saving/lib/features/technology/controller/add_tech_controller.dart:1) | 79 | AddTechController |
| [lib/features/technology/controller/edit_tech_controller.dart:1](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:1) | 65 | EditTechController |
| [lib/features/technology/controller/technlogy.dart:1](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:1) | 204 | TechnlogyController |
| [lib/features/technology/model/tech_model.dart:1](/Users/alimegahed/power_saving/lib/features/technology/model/tech_model.dart:1) | 31 | TechnologyModel |
| [lib/features/technology/view/screens/add_tech.dart:1](/Users/alimegahed/power_saving/lib/features/technology/view/screens/add_tech.dart:1) | 114 | AddTechScreen |
| [lib/features/technology/view/screens/edittech.dart:1](/Users/alimegahed/power_saving/lib/features/technology/view/screens/edittech.dart:1) | 191 | EditTechScreen |
| [lib/features/technology/view/screens/technology.dart:1](/Users/alimegahed/power_saving/lib/features/technology/view/screens/technology.dart:1) | 43 | Technology |
| [lib/features/technology/view/widgets/technology_body.dart:1](/Users/alimegahed/power_saving/lib/features/technology/view/widgets/technology_body.dart:1) | 421 | TechnologyBody, _TechnologyCard |
| [lib/global/app_theme.dart:1](/Users/alimegahed/power_saving/lib/global/app_theme.dart:1) | 173 | AppTheme |
| [lib/global/data.dart:1](/Users/alimegahed/power_saving/lib/global/data.dart:1) | 43 | SessionService |
| [lib/global/html_platform.dart:1](/Users/alimegahed/power_saving/lib/global/html_platform.dart:1) | 9 | — |
| [lib/global/html_stub.dart:1](/Users/alimegahed/power_saving/lib/global/html_stub.dart:1) | 7 | — |
| [lib/global/html_web.dart:1](/Users/alimegahed/power_saving/lib/global/html_web.dart:1) | 20 | — |
| [lib/global/iframe_platform.dart:1](/Users/alimegahed/power_saving/lib/global/iframe_platform.dart:1) | 1 | — |
| [lib/global/iframe_stub.dart:1](/Users/alimegahed/power_saving/lib/global/iframe_stub.dart:1) | 9 | — |
| [lib/global/iframe_web.dart:1](/Users/alimegahed/power_saving/lib/global/iframe_web.dart:1) | 26 | — |
| [lib/global/ip_config.dart:1](/Users/alimegahed/power_saving/lib/global/ip_config.dart:1) | 77 | ApiConfig |
| [lib/main.dart:1](/Users/alimegahed/power_saving/lib/main.dart:1) | 190 | MyApp, ScreenUtils, ScreenController |
| [lib/model/vlotage.dart:1](/Users/alimegahed/power_saving/lib/model/vlotage.dart:1) | 33 | VoltagePlan |
| [lib/my_widget/home.dart:1](/Users/alimegahed/power_saving/lib/my_widget/home.dart:1) | 16 | — |
| [lib/my_widget/sharable.dart:1](/Users/alimegahed/power_saving/lib/my_widget/sharable.dart:1) | 593 | CustomTextFormField, SearchableDropdownController, SearchableDropdown, CustomDropdownFormField, CustomSearchableDropdown |
| [lib/network/network.dart:1](/Users/alimegahed/power_saving/lib/network/network.dart:1) | 69 | ApiException |
| [lib/shared_pref/cache.dart:1](/Users/alimegahed/power_saving/lib/shared_pref/cache.dart:1) | 32 | Cache |
| [lib/test.dart:1](/Users/alimegahed/power_saving/lib/test.dart:1) | 103 | GaugeController, AnimatedGauge, GaugePainter |
