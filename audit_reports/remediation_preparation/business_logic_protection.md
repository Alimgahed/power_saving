# Business-logic protection ledger

**Current implementation is the compatibility baseline, not an authoritative definition of correct domain behavior.** No formula, rounding, unit, financial result, forecasting request or domain workflow may change in this phase or a later batch without the required authorization. A failing characterization test is evidence to investigate, not permission to “fix” a business rule.

## Meter billing

Source: [Bills._setupListeners / _calculateConsumption / _calculateReadingDifference / _calculateTotal](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:89), [meter billing dialog](/Users/alimegahed/power_saving/lib/features/Counter/view/screens/Counter.dart:328), [GuageBill mappings](/Users/alimegahed/power_saving/lib/features/bill/model/bills_model.dart:1).

| Item | Exact current behavior to preserve | Unresolved expectation |
|---|---|---|
| Reading defaults | Previous/current parse with double.tryParse, default 0; calculation factor defaults 1. Submission separately parses factor with fallback 0. | Approved invalid/missing-input policy; do not reconcile defaults silently. |
| Normal difference | current − previous. | Negative corrections/replacement versus wrap handling. |
| Rollover | For negative difference, digit count comes from previous.toString().split('.')[0].length; modulus=10^digits; difference=(modulus−1−previous)+current. | Physical meter width, replacement/reset readings, correction rule. DATA-01 is BLOCKED. |
| Examples | Current 9999→0 computes 0; 9998→2 computes 3; 100→110 computes 10 before factor. | Mathematical conventional wrap differs, but audit arithmetic is not owner approval to change financial results. |
| Consumption | difference×factor, stored as numeric reactive state and text via toString. Negative-consumption flag checks final consumption <0. | Sign/range policy and units. |
| High consumption | _validateConsumption compares to 80% of modulus but currently has no operative action. | Do not add new rejection/warning criteria as presumed domain policy. |
| Energy price/fixed fee | Dialog obtains meter.price and meter.fixedprice; assigns calculatedEnergyCost and fixed. | Tariff effective date, tier rules and server source of truth. No new pricing tiers. |
| Total | consumption×calculatedEnergyCost + fixed + fixedInstallment + settlements + stamp + rounding − prevPayments. | Exact rounding/precision contract, units, inclusion of settlement quantity. |
| Rounding | Total text uses toStringAsFixed(2); calculations use double. Rounding is also a separately entered adjustment. | Do not substitute decimal arithmetic, a new rounding mode or change formatting precision. |
| Settlement quantity | settlementsControllerratio is watched and sent as settlement_qty but not added directly in _calculateTotal. | Do not infer additional arithmetic from the name. |
| Event timing | Listeners on previous/current/factor/fixed-installment/stamp/settlements/settlement-quantity/previous-payments. Rounding and manual consumption are not watched. Dialog replaces previous/factor controllers. | Rewiring changes financial behavior; DATA-02/03 require owner-approved expected interaction results. |
| Allocation | When showPercent is true, ratio controller arrays are created; dialog ratio fields are commented out; blank entries can parse to zero. No active sum-to-100 check. | Required allocation semantics and backend validation; no invented ratio distribution. |
| Date/payment | Submit validates month 1–12 and year 2000 through current year; unpaid bills carry nullable delay month/year. | Due-date validation and historic/future-period policy. |
| Replacement readings | No separate replacement/reset workflow was established in this client. A decrease enters the rollover branch. | Explicit owner clarification required; never invent a replacement algorithm. |

GuageBill.toJson emits delay_year, delay_month, notes, settlement_qty, percent_money, percent_power, guage_bill_id, account_number, bill_month, bill_year, prev_reading, current_reading, reading_factor, power_consump, fixed_installment, settlements, stamp, prev_payments, rounding, bill_total, is_paid, voltage_type, branch_name, station_names and station_names_list. Preserve spelling, null versus omitted values, numeric/string representation and list order. The exact serializer is frozen in api_contract_inventory.md.

## Technology billing

[NewTechBillsController.onInit / addTechBills](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:47): produced water text becomes parsed measured water + parsed calculated water (defaults 0). The edit controller uses a 300 ms debounce before updating produced water; immediate submit timing must be characterized before any change. Operational Techbills cards also own measured/calculated/total inputs; do not assume all paths recalculate identically.

Insert/update request keys: technology_chlorine_consump, technology_liquid_alum_consump, technology_solid_alum_consump, technology_water_amount, measured_water, calculated_water, station_id, technology_id, bill_month, bill_year. Historical edit and operational edit use their existing subsets and distinct endpoints. Do not unify them by adding/removing fields. Values are generally parsed with double.tryParse fallback 0; month/year use integer parsing fallback 0 in the controller. No automatic unit conversion or recomputed chemical dose is authorized.

DATA-05 can change only draft identity ownership to stable techBillId while preserving these values and outgoing request mappings. DATA-04 can preserve planning inputs without changing reference defaults or numerical meaning. Both require fixtures proving value identity before/after reordered or refreshed data.

## Planning and forecasts

[BalanceChartController.buildRequestBody](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:163): calc_type comes from selectedMethod (initially machine_learning); is_modified from edited (initially true); increasable/goal_year parse integer with fallback 0; is_future is boolean. Future mode adds future_years_capacity containing entries with parsed future_year and future_production, skipping entries that fail parsing. Nonempty place-type entries become top-level stringified placeTypeId keys with int.parse values.

POST remains `/balance-plot-calc/{id}`. Response with non-null best_model follows MLForecastResponse and ML result screen; otherwise table List follows WaterDataResponse and balance print screen. Do not change model selection, forecast horizon, training rules, server parameters, branch selection or payload keys. The backend forecasting algorithm is not available. Ministry field validators currently use place-type bounds; those values and checks remain unchanged. Prediction remains POST `/prediction/{stationId}` with `{}` and PredictionModel mapping.

## Reports and totals

[ReportsController.getReports / applyFilters / sumvalueofreport](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:10): POST report_name/from_date/to_date unchanged. Accept a top-level list or data list; parse each row, omit rejected rows after an error dialog, and compute sums of totalWater, totalPower and totalBill over the selected filtered rows. Preserve exact case normalization, comma-separated station matching, month/year string comparison, technology matching and paid-filter treatment of null as not true. Search uses branch/station/month/year/technology fields.

Printing uses filtered rows, currently with unfiltered count; UX-05 may correct the displayed exported-count metadata only, without changing filtered membership or totals. SEC-03 may escape dynamic text while preserving intended template markup and visible textual content. Parser defaults, row rejection and export availability remain blocked pending Q-REPORT. Bill-history summary helpers sum the current page's rows; do not silently change them to aggregate the entire query or introduce a totals endpoint.

Report values have inconsistent unit labels across home/report screens. The client is not authoritative for kg versus grams or power versus energy units; no conversion or label correction is approved without Q-BILL/Q-REPORT.

## Roles and permissions represented in source

These are existing UI visibility rules, not proven server entitlements. Source: [EnterpriseSidebar._buildMenuItems](/Users/alimegahed/power_saving/lib/features/home/view/widgets/enterprise_sidebar.dart:70), [HomeDrawer](/Users/alimegahed/power_saving/lib/features/home/view/widgets/home_drawer.dart:1), [NavigationHelper](/Users/alimegahed/power_saving/lib/features/home/view/widgets/navigation_helper.dart:8), [User.fromJson](/Users/alimegahed/power_saving/lib/features/auth/model/login.dart:24).

| Menu feature | Existing groups |
|---|---|
| Stations; predictions | 1,2,6,7 |
| Meters; tariffs; meter bills | 1,3 |
| Technology; technology-bill history | 1,2,3,7 |
| Relations | 1,3,7 |
| Chemicals | 1,4,6,7 |
| Operational technology bills; new technology bills | 1,2 |
| Places; balance planning | 1,5 |
| Reports — sidebar | 1,2,3,6,7 |
| Reports — drawer | 1,2,4,3,6,7 (includes group 4, unlike sidebar) |
| User creation/administration | 1 |
| Follow-up, financial chart, password change | No group-specific check at those menu entries; navigation helper checks user != null. |

The reports-role discrepancy must not be “standardized” without owner policy. User.fromJson defaults absent/null group_id to 1; cached user controls initial route; routes lack centralized guards. Login also exposes registration navigation. These remain characterized baseline facts, but the user has now explicitly approved rejection of invalid group sessions at login/startup and password-change session retention. SEC-05/06 are READY for those client-only changes; valid-user menu mappings, including the Reports discrepancy, remain unchanged. Public registration is expressly approved. Explicit logout already clears preferences and SessionService; extending cleanup to account-owned static caches is eligible SEC-04 work without changing protocol.

## Compatibility lock

All 59 executable business API call sites, their enclosing request/response methods and all model definitions are snapshotted in api_contract_inventory.md/api_contract_snapshot.json. HTTP methods, base URL branches, endpoints, query names, headers, authentication, payload keys/types/defaults, status interpretation, parsing aliases and invalidation relationships must remain unchanged unless a specifically authorized future exception is granted. Characterization fixtures must expose differences rather than normalize them.

Decisions are recorded in blocked_items.md. The user instructed preserving current billing rules, approved the three local authentication policies, and identified internal deployment. Report completeness, chart capabilities and platform support remain unresolved. No Phase 1 source change is authorized.
