# Quality assurance, reliability, and prioritized plan

## Current evidence

The Dart test suite contains two active tests of the Result value container. The file named auth_repository_test.dart does not invoke AuthRepositoryImpl, mock HTTP, verify authentication persistence, or exercise API failures. widget_test.dart is entirely commented out. iOS/macOS RunnerTests are template-level shells. No tracked CI workflow, integration_test suite, API schema fixture suite or measured coverage artifact was found.

`analysis_options.yaml` enables flutter_lints and globally ignores deprecated_member_use. Source contains additional local lint suppressions. Those suppressions are maintenance signals, not proof of runtime defects. The current lockfile was already modified before this audit; SDK constraints differ between pubspec's minimum Dart range and the resolved lock's effective Dart/Flutter requirements. There is no verified build-toolchain pin or documented deployment procedure. README remains the default Flutter starter text.

No tests, analyzer, compiler, package manager, build, icon generator or application script was run: those can write caches/generated artifacts or touch external systems, prohibited by the request. No pass/fail result or test coverage percentage is inferred. Existing build/ and .dart_tool/ contents are stale-state possibilities and were not treated as validation of current source.

## Safe diagnostics actually performed

- Read-only Git root/status, diff statistics and five recent commit subjects; no checkout, reset, commit or history rewrite.
- File/import/class/route/API-reference inventory and static dependency-cycle analysis using standard-library scripts. All authored outputs remained in audit_reports.
- Direct source tracing across UI, controllers, models, caches and HTTP clients.
- Asset existence/size checks and platform configuration inspection.
- Arithmetic evaluation of the implemented rollover expression: 9999→0 gives 0 versus expected 1 for a four-digit wrap; 9998→2 gives 3 versus expected 4; a normal 100→110 gives 10. This is a mathematical diagnostic, not execution of the Dart application or a committed test.
- SHA-256 comparison of tracked source files to the pre-review snapshot; see preservation.json for the actual result.

## Regression cases to add after authorization

| Priority | Target | Test / acceptance condition |
|---|---|---|
| P1 | Bill arithmetic | Meter wrap boundaries, configured digit width, multiplier, corrections/replacements; exact rounding rules and total consistency. |
| P1 | Billing form lifecycle | Editing factor/previous reading/rounding last updates totals; reopen/rebuild retains correct state; no manual onInit side effects. |
| P1 | Session/cache isolation | A→logout→B, expired/absent token, stale responses after logout, missing role and direct protected-route navigation. No prior account data appears. |
| P1 | HTML boundary | Escape all text fields and isolate chart content; confirm controlled HTML fixtures cannot become executable application-origin content. |
| P1 | Draft identity/preservation | Planning reference refresh preserves dirty fields; reordered tech-bill responses do not move drafts between IDs. |
| P1 | API contracts | Numeric/string/null variants, missing fields, malformed JSON, 401 versus 403, 200/201/204 success cases and partial-report rules. |
| P2 | Async ordering | Slow response A after newer B cannot overwrite query B; cancelled/disposed views receive no stale UI side effects. |
| P2 | Refresh and search | Warm-cache refresh always finishes, errors are recoverable, filter policy is consistent, operational search reacts to typing. |
| P2 | Navigation | Every visible action resolves; add-bill, edit argument absence, login/back/reload and print-result deep-link behavior. |
| P2 | Reports | Totals agree with fixtures; filtered export count and filter labels match; partial rows remain visibly incomplete. |
| P2 | Forms | Prevent double submit, enforce range relationships and dates, retain inputs on error; disabled state is real, not spinner-only. |
| P2 | Native releases | Inspect merged Android permissions, signing certificate and macOS entitlements; verify network, chart and export capability per supported target. |
| P3 | Accessibility/visual | Keyboard and assistive tech flow, enlarged text, responsive widths, actual contrast and reduced motion. |
| P3 | Performance | Synthetic data scaling, cold/warm startup, chart decode, report export, repeated navigation heap retention. |

Use fake HTTP and local data for unit/widget tests. Use a disposable checkout and isolated non-production backend for integration/device validation. External service tests need explicit authorization and must not use production write operations. Persist exact toolchain/build mode and fixture versions for reproducibility.

## Recommended sequencing

**Stage 1 — integrity and trust boundaries.** Product owner and billing/domain engineer validate rollover and totals; frontend engineer fixes draft/listener ownership; backend/platform owner establishes HTTPS and verifies authoritative calculations/permissions. Security work isolates executable HTML and sessions. Close DATA-01–05 and SEC-01–06 with targeted regression evidence. These are the highest-consequence paths and should precede broad visual polishing.

**Stage 2 — functional reliability.** Repair missing navigation, search, refresh and loading/error states (UX-01–04, REL-01), report completeness/counts (DATA-07, UX-05), stale response ordering and transport policy (DATA-06, NET-01/02). Consolidate transport incrementally while retaining API compatibility and one user-facing error owner. Regression tests should be added alongside these changes.

**Stage 3 — release readiness and support policy.** Decide whether native targets are actually supported. Verify release manifests, entitlements, signing and print/chart capabilities (BUILD-01/02, UX-06), pin/document a supported toolchain, correct asset references (BUILD-03) and add CI checks in a later authorized task. Audit dependency advisories and production configuration against actual deployed versions.

**Stage 4 — measured scale and usability.** Profile before optimizing report rendering, catalog cache copies, base64 image handling and animations; fix lifecycle omissions (LIFE-01). Standardize selected shared components and accessibility behavior based on rendered evidence, not aesthetic preference alone.

Effort estimates and delivery dates are intentionally omitted: backend ownership, data volumes, supported devices, test environment availability and release constraints are unknown. No rewrite, dependency upgrade or deployment is prescribed as an immediate audit action.

## Open verification questions

- Which platforms and minimum device/browser versions are supported in production?
- What are the authoritative billing units, precision, wrap modulus, allocation percentages, and server recalculation rules?
- Is self-registration allowed, and what data/operations may each group access?
- Are report/catalog results scoped by account or organizational unit?
- What are response schemas/status codes, ordering guarantees, date semantics and idempotency contracts?
- What are actual TLS/proxy/CSP settings, token lifetime/revocation rules and deployed dependency versions?
- Where are database schema, constraints, migrations, query plans, monitoring, backups and CI/CD maintained?

The repository can support a concrete remediation plan now, but answers to these questions are required before declaring production security, performance, data integrity or platform support verified.
