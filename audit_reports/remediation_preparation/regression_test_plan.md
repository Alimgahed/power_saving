# Regression test matrix

**Status of every proposed application test: NOT EXECUTED.** Phase 0 only documents tests. The only executable checks in this phase are repository/file diagnostics, direct Dart version output and document validation. No build, Flutter test, analyzer, security exploit, browser launch or production API call occurred.

## Fixture and harness policy

Use existing flutter_test and http facilities, fake clients/recording adapters, SharedPreferences mock state, GetX reset between tests and synthetic model fixtures. A recording transport must fail on any unregistered URL and never fall through to real network. Preserve intentional differences between legacy and ApiClient headers/attempt policies. Proposed test seams must be reviewed as future implementation changes; none were added now. Fake timers/completers provide deterministic debounce and completion ordering. Fix clock/date in tests to avoid hardcoded current-year assumptions.

Each API fixture snapshots method, complete URL/query encoding, headers, decoded body including omitted/null distinctions, expected status handling, model result, cache invalidation and navigation side effects. Cover all 59 call sites in api_contract_snapshot.json, including duplicate/legacy paths; identify reachability before excluding a path. Do not replace production endpoints or methods in application code to run tests—inject the fake transport.

## Test cases and acceptance

| Test ID | Coverage / findings | Synthetic scenario | Required assertion / oracle | Gate |
|---|---|---|---|---|
| T-BILL-01 | Rollover DATA-01 | 9999→0, 9998→2, equal/increasing/decreasing readings and factors | Characterize exact existing formula/results; no conventional-wrap correction asserted as product truth. | Frozen billing; any corrected target BLOCKED. |
| T-BILL-02 | Formula/rounding DATA-02/03 | Decimal amounts, fee/settlement/stamp/payment/rounding changes, last-edited factor | Capture exact calculation order, toStringAsFixed(2), input defaults and event-trigger timing. | Preserve current code rules; changes blocked. |
| T-BILL-03 | Replacement/allocation | Negative/reset-like readings; showPercent arrays and blank entries | Characterize current rollover/default/serialization, never invent replacement or ratio rules. | Domain changes blocked. |
| T-LIFE-01 | LIFE-01 | Repeated open/rebuild/close; delayed callback after disposal | Owned controllers/workers disposed once; no callback on disposed view; no draft/value reset. | Baseline ownership map; exclude blocked financial rewiring. |
| T-SESSION-01 | SEC-04 | A loads all caches→logout→B, A response completes late | No prior-account cache data rendered or repopulated; unchanged bearer requests and preference protocol. | Session fixtures, no role policy changes. |
| T-AUTH-01 | Approved public registration | Login→register→submit via existing flow | Public entry remains visible/reachable/functionally equivalent; exact existing request/status handling. | Approved policy. |
| T-AUTH-02 | Approved valid groups | Synthetic valid users for source-represented groups 1–7 | Existing menu/role behavior preserved, including distinct drawer/sidebar Reports rules. No newly invented roles. | Source role matrix. |
| T-AUTH-03 | SEC-05 | Login response group_id missing/null/noninteger/unrecognized; inactive/other fields separate | Reject invalid group info before creating/persisting usable session; no privileged fallback; user-friendly message. Do not silently change unrelated isActive policy. | Approved group validation; supported set from existing source. |
| T-AUTH-04 | SEC-05/06 startup | Invalid cached user with token; partially saved state; valid cached session | Invalid session cleared and routed to Login after navigator is available; valid role mapping preserved. No new server validation request. | Approved policy. |
| T-AUTH-05 | Protected navigation | Invalid session directly navigates named protected screens | No protected screen/data access from invalid local state; login/registration remain public. Do not impose new group-based route restrictions on valid users. | Approved invalid-session guard. |
| T-AUTH-06 | Password success | Existing success status with current token; later existing auth error | Successful change retains current authenticated state/navigation. No assumed token rotation; later auth failure follows existing handling gracefully. | Approved policy; retry count not changed. |
| T-HTML-01 | SEC-03 | Arabic, &, <, >, quotes, inert tags in all text fields | Same visible text/rows/order/totals with correctly encoded HTML; static print controls intact. | Local browser fixture only after authorization. |
| T-HTML-02 | SEC-02 | Representative executable chart, links/export/interactions | Approved isolation without feature loss, no parent/storage access where contract forbids it. | BLOCKED chart capability contract. |
| T-API-01 | All contracts | Each request plus 200/201/204, 401/403/422/500, malformed data | Exact current per-call status/parser/header/payload behavior; approved local auth-session outcomes are explicitly separate assertions. | API freeze. |
| T-ORDER-01 | DATA-06 | Issue A, issue B, finish B then A | B rows/page/query state retained; obsolete A cannot commit. No cancellation endpoint or write replay. | Fake completers. |
| T-NET-01 | NET-01 | Never-completing read/forecast; timed-out write | Recoverable bounded state under approved deadline; timeout does not imply server rollback. | Deadline/recovery investigation. |
| T-NET-02 | NET-02 | Simulated commit then lost password response | Characterize existing attempts/delays; new retry behavior requires explicit contract decision. | BLOCKED replay policy. |
| T-PLAN-01 | DATA-04 | Warm reference cache→type assumptions→late reference response/type edit | Values remain associated with placeTypeId; removed entries handled deliberately without inventing values; same request body. | Stable reference identity. |
| T-TECH-01 | DATA-05 | Edit two rows; reorder/remove rows on refresh | Draft follows techBillId; no values transferred to another ID; same payload for saved bill. | Stable ID assumption verified by supplied contract/fixtures. |
| T-TECH-02 | Water calculation | Measured/calculated changes and immediate submit before edit debounce | Characterize current sum/debounce/default behavior; no altered water calculation in identity/cleanup changes. | Protected business rule. |
| T-SEARCH-01 | UX-02 | Type unmatched query, wait debounce, clear | Results/no-result state reflect text without another filter action; original records/order retained. | READY after baseline. |
| T-REFRESH-01 | UX-03 | Warm cache refresh success/failure and navigation away | Refresh future/loading finishes; no double update or stale response side effect; preserve documented filter-reset policy. | READY after baseline. |
| T-SUBMIT-01 | UX-04 | Rapid repeated registration clicks, delayed response/error | One in-flight submit; correct loading reset; unchanged public registration and request. | READY after baseline. |
| T-NAV-01 | UX-01 and routes | All 36 named routes, missing arguments, back/reload and Add Bill | Existing journeys remain reachable with approved arguments/stack; no button/route removal. | Add Bill flow investigation. |
| T-REPORT-01 | DATA-07 | Valid+malformed rows; absent numeric/year fields | Current row omissions/defaults/sums frozen; proposed warning does not change export availability. | Completeness policy blocks changed behavior. |
| T-REPORT-02 | UX-05 / SEC-03 | Ten rows filtered to two and print each report type | Two rows/count; same filtered sums/order/unit labels/precision; literal text preserved. | READY after baseline. |
| T-RESP-01 | UI narrative | 320/375/600/750/1200 widths, landscape, large text, RTL | No hidden task controls or clipped essential data; keyboard/focus/semantics checked; record screenshots and actual outcomes. | Supported targets; NOT VERIFIED today. |
| T-NATIVE-01 | BUILD-01/02, UX-06 | Merged manifests/entitlements, device networking, print/chart and signing | Required declared platform capabilities work with frozen URLs; verified artifact evidence. | Platform/signing decisions; no production writes. |
| T-PERF-01 | PERF-01/LIFE-01 | Synthetic 100/1,000/10,000 rows, repeated visits | Measure device/build-specific CPU/frame/heap and output parity before/after; no invented targets or improvements. | Profiling environment and feature parity. |

## Release evidence requirements

For each later executed test run, record commit/worktree/source hashes, Flutter/Dart versions, OS/device/browser, fixture version, command, exit code, pass/fail/skip counts and limitations. Native builds must use an authorized isolated environment and signing controls. CI should reject accidental live network and request snapshot drift. Any unexpected change to API/business fixtures is a review blocker, not an automatic snapshot update.

Characterization tests may intentionally assert surprising current behavior; associate them with blocked finding IDs so they are not confused with approved correct formulas. New behavior expectations for public registration, invalid group rejection and password-session retention are specifically approved by the user and must be separate, explicit tests. No dependency upgrade, test file or CI configuration has been created in Phase 0.
