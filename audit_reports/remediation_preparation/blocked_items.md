# Blocked items and decision requests

Phase 0 is documentation only. READY is not authorization to implement. Owner answers can establish intended behavior, but a prohibited change still requires explicit scope authorization in a later phase. No response to pending questions is assumed.

## Original findings blocked: 9

| Decision | Findings | Missing authority / prohibited change | Required resolution |
|---|---|---|---|
| Q-HTTPS | SEC-01 | New HTTPS endpoint/TLS configuration conflicts with frozen URLs and server configuration. | Infrastructure owner identifies approved HTTPS contract and separately authorizes migration. |
| Q-CHART | SEC-02 | Sandboxing may disable required executable chart scripts/interaction/export. | Sanitized representative HTML, capability contract and compatible isolation design; no new server origin in current scope. |
| Q-BILL | DATA-01, DATA-02, DATA-03 | Rollover corrections and recalculation timing alter protected financial behavior. | Owner-approved numerical examples and interaction sequences plus explicit authorization for any formula/financial-behavior exception. |
| Q-REPORT | DATA-07 | Partial rows, parser defaults, totals and export availability have no authoritative completeness contract. | Approve semantics. Nonblocking warnings may be separately scoped; no changed sums/defaults or disabled exports. |
| Q-AUTH-RETRY | NET-02 | Ambiguous password mutation completion and replay semantics are unverified. | Approved recovery/retry contract. No new idempotency fields/headers. |
| Q-SIGNING | BUILD-02 | Production identity, key custody and distribution continuity unknown. | Release owner supplies secure signing plan. No credentials in chat, key generation or applicationId change. |
| Q-PLATFORM | UX-06 | Supported native platforms and chart/print fidelity unspecified. | Product declares parity contract. Existing buttons/routes must not be hidden; new dependencies require separate approval. |

## Original findings requiring investigation: 7

| Finding | Evidence required | Exit criterion |
|---|---|---|
| UX-01 | Existing meter selection→bill flow, arguments and back-stack expectations (Q-NAV). | Route repair preserves the intended domain journey and all actions. |
| ARCH-01 | Fake-client snapshots of both transports and affected 59 callers. | Boundary consolidation preserves per-operation headers/status/retries/serialization/session semantics. |
| NET-01 | Appropriate report/forecast deadlines and timeout recovery. | Client timeout cannot imply server rollback or trigger write replay; wire contract unchanged. |
| PERF-01 | Synthetic profiles and table/export parity. | Client-only improvement; API pagination/new export endpoints remain prohibited. |
| BUILD-01 | Supported targets, merged Android manifest, signed macOS entitlements and actual transport behavior. | Client configuration correction compatible with frozen URLs; server changes remain blocked. |
| UX-07 | Validator call-site audit and authoritative rules (Q-VALIDATION). | No accidental new input acceptance/rejection rules. |
| BUILD-03 | Intended icon asset and favicon built-path evidence (Q-ASSETS). | Approved existing asset identified; generator execution separately authorized. |

## Additional narrative observations requiring decisions

Relation status uses GET; changing its method is blocked. CounterController.addCounter points to new-station while dedicated meter creation uses new-gauge; preserve both until reachability/contract is resolved. Caller 200 versus 201/204 handling, List versus Map parsing, default years/zeros and units require authoritative schemas before changes. Public registration navigation is a policy question, not proof of unauthorized registration. Native feature/dependency needs, font bundling and SDK changes require separate approval where applicable. Startup failure, missing arguments, accessibility and modal behavior need isolated runtime evidence.

## Decisions received in this chat

- **Billing:** “use the same role in my code” is interpreted as preserve existing rules/calculations. No correction to formula or recalculation timing is approved; DATA-01/02/03 remain scope-BLOCKED. No need to invent or request a replacement formula for the currently authorized program.
- **Authentication — APPROVED:** public registration stays accessible and unchanged on the wire; missing/null/invalid group_id rejects the local session during login/startup; valid-user role behavior stays unchanged; successful password change keeps the session/navigation when existing authentication allows. SEC-05/06 are now READY for future implementation. These are the only approved local policy deviations from current behavior.
- **Deployment:** “this is internal system.” Internal context is recorded. It does not identify production platforms, an HTTPS endpoint, a chart security contract or signing identity; Q-HTTPS/Q-CHART/Q-PLATFORM remain unresolved.

Authentication policy does not authorize a new refresh/token-validation endpoint, changed server response parsing contract, new group IDs, revised valid-user menus, or changed retry behavior. Validate raw group data before constructing/persisting a usable session; current source represents groups 1–7. Preserve the drawer/sidebar difference for valid users unless separately approved. NET-02 remains blocked on replay semantics.

Q-REPORT, Q-SIGNING, Q-NAV, Q-VALIDATION and Q-ASSETS remain targeted follow-ups before their dependent batches. Policy approval is recorded but no explicit Phase 1 execution authorization has been given; stop after documentation.
