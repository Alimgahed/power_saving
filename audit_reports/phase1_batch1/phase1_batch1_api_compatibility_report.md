# Phase 1 — Batch 1 API compatibility

Existing base URL configuration, endpoint literals, methods, headers, query assembly, body values and model/parsing contracts remain unchanged. No backend or server configuration edits. All model files and pubspec files match the pre-batch snapshot. Review covered the complete source diff against HEAD and Phase 0 hashes; see compatibility_checks.json.

| Affected call | Preserved wire contract |
| --- | --- |
| GET /all-areas | Same URL and shared fetchData headers; same AreaOfService parsing. |
| GET /place-types | Same URL and PlaceType parsing. |
| POST /balance-plot-calc/{id} | Same buildRequestBody, byte-for-byte unchanged, including optional dynamic place IDs and future capacities. Same response/result parsing. |
| GET /tech-bills | Same URL and TechnologyBill parsing. |
| POST /edit-tech-bill/{id} | Same domain ID and six numeric keys: technology_chlorine_consump, technology_liquid_alum_consump, technology_solid_alum_consump, technology_water_amount, measured_water, calculated_water. Exact synthetic payload tested. |
| GET /view-bills | Same page/per_page, search trimming, optional year/month/is_paid/account_number and response pagination mapping. |
| GET /view-tech-bills | Same page/per_page, untrimmed search and optional year/month, response pagination mapping. |

fetchData/postData still perform the same HTTP GET/POST with JSON Content-Type and existing Bearer token behavior, encoding and status handling. The new optional isCurrent callback is never serialized or sent. It only gates local unauthorized-response side effects for these guarded callers. Non-guarded callers retain previous behavior. Obsolete requests cannot clear a newer token or navigate after their owner has been superseded/disposed. Current authentication protocol, registration, valid roles, routes and login/session implementation are untouched.

Requests are not retried or cancelled by the guard. Existing successful save-triggered refresh remains. Awaiting background refresh completion changes local future completion timing, not endpoint or request count. No server behavior or token-rotation assumption was introduced. No real credentials or live API compatibility requests were used.
