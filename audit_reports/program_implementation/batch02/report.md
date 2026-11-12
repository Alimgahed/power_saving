# Program batch 02 — responsive shared headers

P-UI-01 / N19: runtime characterization promoted the shared-header subset to READY. Long Arabic titles were unconstrained Row children. They overflowed despite available vertical space, particularly at 375px and 2x text scale. `SectionHeader` now gives text a Flexible constraint; `EnterpriseCard` uses Expanded for its title, retaining trailing controls. `CustomAppBar` exposes the existing back action through the platform-localized tooltip. No title is removed/truncated and no navigation callback changed.

Exact source files: `lib/core/widgets/section_header.dart`, `lib/core/widgets/enterprise_card.dart`, `lib/core/widgets/custom_app_bar.dart`. Test added: `test/program/responsive_headers_test.dart`. Full batch diff reviewed in `batch.diff`.

Before: 2 tests passed / 11 failed. After: 13 focused tests passed; 146 combined tests passed. Widths 375/768/1440, text scales 1/2, RTL, full label retention, trailing action taps and back label covered. Analyzer: 59 existing findings, no new diagnostics. Web build passed (65.6s), wasm dry run passed. `git diff --check` passed.

No API, model, calculation, data/storage, validation or business workflow code changed. Performance timing not applicable; confirmed RenderFlex overflow eliminated in the tested cases. These are rendered widget tests, not visual inspection of every launched application screen. Remaining feature-specific layouts, dialogs and real-browser accessibility need further evidence. Next batch: six confirmed read-response ownership defects, keeping HTTP requests and response interpretation unchanged.
