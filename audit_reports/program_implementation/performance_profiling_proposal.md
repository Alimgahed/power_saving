# Proposed next phase — performance measurement only

Status: PROPOSED, NOT STARTED. No performance implementation authorized by this proposal. Resolve or explicitly defer the mutation-completion decision independently. Protected live profiling requires an authorized development session or an approved isolated fixture harness; never bypass authentication.

## Scope

1. Report screen: initial render, filter/search updates, scroll frame timing, HTML generation/export time and peak memory at 100 / 1,000 / 10,000 representative rows.
2. Dashboard: repeated model conversion and chart creation during parent rebuilds; count conversions/requests without changing responses or introducing caches.
3. Navigation/lifecycle: heap retained after 20 open/close cycles for selected report and edit routes; timer/listener/controller counts before/after collection.

Measure first. No lazy rendering, isolate migration, pagination, calculations, filtering, export encoding/count or report structure changes unless separately justified and output parity proven. No data caching, dependencies, API changes or production mutations.

## Baseline status (actual evidence)

- Correctness baseline after batch 14: 233 approved regression tests passed, plus two separate mutation-characterization tests.
- Static/build baseline: analyzer 53 existing findings/no errors; Web build 62.4s and Wasm dry run successful. Build time is not UI runtime performance.
- Prior unused report-index benchmark samples were noisy and were not evidence of elapsed-time improvement. Existing deterministic elimination of unused per-row work remains documented in batch 07.
- Current representative production frame time, long-task duration, heap/retained-object counts, conversion counts and export latency: NOT MEASURED. Do not invent values or call the runtime baseline complete.

## Required measurement protocol before optimization

Document commit/working-tree hashes, SDK/browser versions, build mode/renderer, hardware, viewport, data fixture hashes and route. Use a release/profile build with fixed local fixtures through the existing contract seam (no production writes). Record cold and warmed runs separately; five repeats per dataset after one initialization run. Capture median/p95 frame durations, frames over budget, elapsed filter/export time, peak/retained memory and backend request counts. Preserve trace files, raw results and screenshots. Distinguish browser startup/font/shader effects from steady state; never infer CPU speedup from widget-test duration.

Before any optimization, publish that measured baseline and identify one demonstrated bottleneck with a defined success metric and exact output/API parity checks. Stop if representative fixtures/session access are unavailable. Compare the same build settings/data and rerun correctness/security/no-cache guards after any later approved implementation.

## Proposed deliverables and gate

performance_baseline.json, raw traces, environment/fixture manifest, findings ranked by measured impact, and a one-change experiment plan. The next step is agreement on this measurement scope and availability of authorized fixtures/session access. This document proposes the phase; it does not start profiling or claim completed baseline measurements.
