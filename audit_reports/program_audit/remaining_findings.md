# Remaining application assessment — living register

This register supersedes Phase 0 execution status, not its historical evidence. Program scope now authorizes independent safe frontend batches. Inventory: all 202 lib Dart files scanned for ownership, async, route, storage, build and presentation patterns (`source_inventory.json`); this is static screening, not a claim that all screens have been visually verified. Targeted code review and runtime evidence are recorded per batch.

## Previous work preserved

Phase 1: DATA-04/05/06 selected draft/read races; UX-01 existing navigation workflow, UX-02, UX-03, UX-04, REL-01 selected flows. Phase 2: SEC-04/05/06 session/no-cache subset. Phase 3: LIFE-01 selected owners, report output baseline. QA-01 ongoing. These findings are not globally closed when other callers remain untested.

## Prioritized remaining register

| ID | Finding / scope | Current classification |
| --- | --- | --- |
| P-LIFE-01 / LIFE-01 | Eight GetX search workers leave queued debounce timers alive after disposal: Counter, Stations, Places, Chemicals, Relations, Technology, meter history, technology history | FIXED in batch 01; callback bodies/delays preserved |
| P-LIFE-02 / LIFE-01 | Technology list allocates five additional text controllers but omits disposal; dropdown/post-frame references may outlive owners | Confirmed exclusive fields and dropdown callback FIXED in batch 04; other ownership cases remain INVESTIGATE |
| P-READ-01 / DATA-06 | Dashboard, stations, meters, places, user list, prediction and lookups lack screen request ownership | INVESTIGATE each read flow, then implement confirmed closed/latest response defects; mutation semantics frozen |
| P-UI-01 / N19 | Shared SectionHeader uses unconstrained text alongside icon/divider; fixed rows and dialogs may overflow | INVESTIGATE widget sizes at 375/768/1440, RTL/text scaling; retain every label/action |
| P-PERF-01 / PERF-01 / N13 | Report index is populated but never consumed; eager rows and full HTML rendering remain | N13 eligible only after exact parity and allocation evidence. General lazy/isolate changes remain INVESTIGATE |
| P-REL-01 / N22 | Following-station lookup unhandled failure; station-add branch lookup silently catches | FIXED in batch 05; selection/response contracts preserved |
| SEC-03 | Raw HTML interpolation in report and planning exports | FIXED in batch 09 under explicit approval; literal text/structure/calculations/API preserved |
| UX-05 | Printed count differs from filtered rows | DEFER: report-content preservation prohibits changing displayed count without exception |
| DATA-01/02/03/07, N04/05/18 | Calculations, input ownership affecting recalculation, partial parsing, status interpretation, units | BLOCKED by business/response preservation |
| SEC-01/02, NET-02, N01/02/20/23 | TLS, executable chart capabilities, mutation replay, wrong/mutating endpoints, token architecture, role-menu differences | BLOCKED; no wire/policy guesses |
| ARCH-01, NET-01 | Transport consolidation/deadlines | INVESTIGATE, no architecture rewrite or changed submission semantics |
| BUILD-01/02/03, UX-06/07, N15/16/17/21 | Platform/signing/assets/validation, unused layout hooks/theme/localization, modal policy/toolchain | INVESTIGATE or existing blocker; no speculative product/validation/dependency changes |

## Coverage and constraints

- Auth/session/routes/network: prior 117-test suite plus current source inventory; approved public registration and group-role rules remain unchanged. Client guards are not server authorization.
- Catalogs/forms: resource/search/async call-site inventory across all controllers and bindings. Repeated Get.put and form ownership require reachability checks before changes.
- Billing/planning: preserve arithmetic/model code and prior drafts; no ratio/reading/tariff lifecycle cleanup that could change calculations.
- Dashboard/analysis/prediction: chart models and iframe contract frozen; read ownership investigated separately.
- Reports/export: 15-strategy output fixture retained; no omitted records/pagination changes.
- Shared UI/screens: targeted shared-header/dropdown responsive/semantics tests passed; no blanket claim of visual quality or accessibility compliance.
- Web/storage: no new business-data storage/caching; existing session mechanism retained. Model/serializer source remains a frozen comparison boundary.

Update this register after each tested batch. Audit evidence stays here; implementation logs/reports stay under `audit_reports/program_implementation/`.

## Progress after batches 01–03

- P-LIFE-01: fixed all eight remaining GetX debounce sites; 16 focused tests.
- P-UI-01: shared SectionHeader / EnterpriseCard overflow and CustomAppBar label fixed; 13 tests at 375/768/1440 and text scales 1/2. Additional CustomDropdownFormField overflow reproduced at 800px add-station form; queued for isolated fix.
- P-READ-01: dashboard, meters, stations, places, users, prediction reads fixed; 22 ownership/loading tests. Lookups and mutation-specific sequencing remain separately scoped.
- Storage scan: only `SessionManager` persists user/session metadata and token through Cache; no business response persistence, static response cache or browser data store found by current lib scan. Existing live model/list state is not cross-screen memoization.
- Routes/bindings: inspected all binding files and main GetPage declarations; prior 34 protected / 2 public routes retained. No route/permission edits.
- User-management status/delete actions currently have commented-out transport and optimistic local effects. They are business/backend workflow findings, not safe cleanup; do not implement missing backend actions or change those local semantics.

## Progress through batch 08

P-LIFE-02 exclusive technology fields/deferred dropdown use fixed; N22 station branch/source and following-station error/retry states fixed; shared dropdown sizing fixed, including full add-station viewport checks. N13 unused report index removed with unchanged 15-strategy output fixture; deterministic unused allocations removed, no frame-rate claim. Nine further form owners reproduced post-close lookup dialogs and now use separate request guards (all mutations frozen). General PERF-01, UX-05, billing/permissions/transport gates remain as above.

User decision: SEC-03 HTML output encoding explicitly approved on Flutter client only, including literal Arabic/special-character rendering, no report structure/count/calculation/API changes. UX-05 explicitly remains DEFERRED. Security boundary investigation independently reviewed both print builders and all eleven concrete printer classes.

## Progress through batches 09–10

SEC-03 fixed with 18 new encoding tests and unchanged legacy output fixtures; UX-05 explicitly remains deferred. Six analyzer-confirmed unused imports removed in batch 10. Combined suite: 211 passed. See the program implementation summary for verification and the managed security report link. Remaining investigations are not authorized guesses: live screen coverage, mutation ownership, report profiling and ambiguous shared ownership still need evidence. No claim of complete production readiness.

## Continuation: batches 11–13

- LIFE-01: station/place deferred edit initialization reproduced writes to disposed fields; mounted/closed checks fixed it (4 tests).
- LIFE-01: user-edit dialog's three text controllers and active-state notifier leaked on cancel/barrier/back; now owned by the dialog subtree and disposed after exit/unmount (3 dismissal tests, save payload characterization retained).
- UI responsive: user card label/name and dialog heading/control-row overflow reproduced in widget tests; constrained text and wrapped controls fix it at 375/768/1440 without dropping controls (3 tests).
- Public live screens: login/registration inspected in the actual built app at mobile/tablet/desktop and short landscape; navigation/back/scroll reachability verified. No public-screen defect confirmed, so no public UI change.
- Protected live verification: **BLOCKED**, user explicitly confirms no authorized test account/session. Continue source/automated evidence only; do not bypass auth, use personal credentials, or submit business changes.
- UX-05 stays DEFERRED. Missing-argument redirect callbacks, shared resources outside these owners, mutation response/navigation races and broad protected-screen visual coverage remain investigation; these were not silently fixed or declared verified.

Public live observation: existing favicon root image returns 404; normal in-app asset loads. Web asset reference is a separate BUILD/asset finding, unchanged here.

## Batch 14 lifecycle/navigation audit

Five edit missing-argument routes and Analysis deferred-back callback reproduced/fixed (12 regressions). Final approved suite 233 passed, analyzer 53 existing/no errors, Web/Wasm dry run passed. Resource inventory covers 45 files with explicit lifecycle evidence; see batch14/ownership_assessment.md. Late chemical mutation success redirect/error dialog after controller disposal reproduced using mock-only transport; behavior unchanged pending explicit workflow approval. Financial replacement ownership remains gated, unused legacy scroll helpers have no confirmed live caller, protected live checks remain blocked, UX-05 deferred. Performance measurement phase proposed in program_implementation/performance_profiling_proposal.md, not started; runtime baseline metrics are explicitly unmeasured.

## Batch 15 — chemical completion decision resolved

User explicitly approved disposed-owner UI-side-effect suppression while the dispatched request finishes unchanged. Add/edit both reproduced and fixed with existing transport ownership callback plus completion/catch guards. 28 acceptance regressions pass; combined suite 261 passed. Prior chemical pending-decision notes are superseded. Other mutations remain outside this approval. UX-05 remains deferred and performance phase remains proposed/not started.
