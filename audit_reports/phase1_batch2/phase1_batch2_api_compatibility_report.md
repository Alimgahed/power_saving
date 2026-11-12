# Phase 1 — Batch 2 API compatibility report

Preserved: base URL configuration, HTTP methods, headers, query parameters, request bodies, response models, authentication protocol and valid-user role mappings. No backend, infrastructure, database or dependency change. Existing network.dart and Batch 1 RequestGuard are byte-for-byte unchanged from the captured Batch 2 baseline.

| Flow | Unchanged contract / evidence |
| --- | --- |
| Operational Technology Bills search | Purely local filtering; no new request. /tech-bills and /edit-tech-bill/{id}, save values and draft ownership remain unchanged; Batch 1 tests pass. |
| Chemical catalog | GET /chemicals, same headers and AlumChlorineReference.fromJson mapping. |
| Relations catalog | GET /stg-relations, same StationGaugeTechnologyRelation.fromJson mapping. GET /edit-relation/{id} mutation remains unchanged; no new retry or method conversion. |
| Technology catalog | GET /technologies, same TechnologyModel.fromJson and global list assignment. Existing POST /new-tech unchanged. |
| Registration | POST /register; username, password, emp_code, emp_name unchanged. Tests assert exact synthetic body, endpoint and method. Public login link and /NewUser route unchanged. Success remains status 200 with existing dialog; error handling retains existing server message handling. |
| Station analysis | GET /analysis-single/{station}/{tech}, no added params. Same AnalysisModel parser and chlorine/liquid/solid/power chart mapping. Route-argument and same-request retry tests pass. |
| Financial chart | GET /financial-analysis; same water_chart nullable String mapping, same iframe HTML function. New local view identifiers are not sent over HTTP. |

Successful expected 200 responses retain parsing. Other successful transport statuses, malformed payloads and exceptions now end in an explicit local error rather than indefinite loading; no new server success schema was invented. Missing chart fields retain model defaults/null and render empty state. Caches update only after valid parsing, so failed parsing does not replace good cached data.

Refresh ownership uses Batch 1's optional local callback to suppress obsolete commits and stale auth side effects. The callback/force flag are not serialized. Manual retry repeats only the existing read operation; there is no automatic mutation retry. Cache-first loads still perform one network refresh; duplicate registration taps are deliberately suppressed while pending. These request timing/count changes are the authorized reliability changes.

preservation_checks.json verifies unchanged model files, routes/bindings, dependencies, guard, transport, Planning/history source and Batch 1 tests, plus matching API URL literal sequences. batch2_only.diff is reconstructed against baseline hashes and excludes Batch 1 work for review. Complete Git diff was also inspected. Endpoint tests are synthetic, not live-server certification.
