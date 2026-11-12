# Program batch 07 — remove unused report index

N13 / PERF-01 narrow READY subset: whole-repository search proved `_index`, `_BranchIndex` and `_buildSearchIndex` have no consumers beyond construction/clear in ReportsController. Exact filter/totals methods and printer strategies are unchanged. Removed the private index, its clear/build calls and class from `lib/features/reports/controller/reports_controller.dart`; no lazy rendering/isolate/pagination changes.

New characterization `test/program/report_loading_test.dart`: full POST /reports pipeline at 100/1,000/10,000 rows, same payload/order/totals/loading completion. Before 3 passed; focused after 7 passed including existing 15-strategy × 8-filter export golden. Combined 184 passed. Analyzer 59 existing findings. Web build passed 78.8s; diff check passed. Reviewed exact diff in `batch.diff`.

Deterministic work eliminated: one `_BranchIndex` allocation per report row, one generated list and four string-conversion calls per row; at 10,000 rows, 10,000 unused wrapper objects are no longer constructed/retained. No alternative cache introduced. Debug VM median full-load microseconds: before 2,201 / 11,394 / 108,175; after 4,400 / 16,995 / 172,521 for 100/1,000/10,000 rows. Runs overlapped different workload, so timings do not establish speedup or regression. Only removal of demonstrably unused work is claimed; no heap bytes/frame-rate improvement measured.

General PERF-01 eager DataTable/full-export work remains investigation. Printed record count (UX-05) unchanged. Next: remaining confirmed form lookup lifecycle defects, followed by explicitly authorized SEC-03 encoding.
