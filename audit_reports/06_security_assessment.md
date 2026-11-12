# Defensive security assessment

This is a local, source-based assessment. It is not a completed managed Codex Security scan, penetration test, dependency-advisory certification, or production access-control verification. No application API, exploit, production resource, or credential was used. No actual secrets are reproduced.

## Assets and trust boundaries

Protected assets include login credentials, bearer tokens, employee/user records, billing and operational readings, reference ranges, and report/forecast outputs used in operational decisions.

The important boundaries are:

1. User input and locally cached identity → trusted application/session state.
2. Application → API over configured HTTP endpoints.
3. API JSON → typed business models and financial calculations.
4. API-provided chart HTML and report data → executable browser documents.
5. One account/session → another account in the same long-lived client process.
6. Role-based UI visibility → direct navigation and server authorization.

No backend source or security policy file was found in the tracked repository. Roles and endpoint names are evidence of intended UI behavior, not evidence of server policy.

## Source-backed findings and attack prerequisites

| Finding | Control failure | Prerequisite / validated limit |
|---|---|---|
| SEC-01, High | HTTP transports passwords, bearer tokens and business data. | Network observer/active attacker on a reachable path. No live interception performed. |
| SEC-02, High | API water_chart becomes unsandboxed iframe srcdoc. | Ability to influence API HTML or transit response. Sink and path confirmed; browser exploitation untested. |
| SEC-03, High | Data fields enter report HTML without output encoding. | Ability to influence returned names/text; otherwise malformed data still corrupts layout. Backend write permissions/sanitization unknown. |
| SEC-04, High | Static caches survive account logout. | Two accounts share one process and have different data entitlements. Source flow confirmed; role-specific runtime exposure untested. |
| SEC-05, Medium | Missing group defaults to administrator UI role. | Missing/null role or modified local identity. Does not establish backend authorization bypass. |
| SEC-06, Medium | No route-boundary policy and incomplete session invalidation. | Direct navigation, stale cache, 401/403 or password-change transition. Server access checks unknown. |
| BUILD-02, Medium | Release selects debug signing. | Relevant to production packaging/distribution; no shipped artifact inspected. |

Exact paths, function/line anchors, root causes, impacts and remediation/validation steps are in `02_findings.md` and `findings.json`. High severity indicates the potential confidentiality/integrity consequence with stated prerequisites, not proof of an attack in production. No critical severity is assigned without evidence of such impact.

## Token and local storage

AuthRepositoryImpl stores token and serialized user through SharedPreferences. The code does not introduce secure native key storage or browser HttpOnly cookie isolation. On web, client-readable token persistence increases the impact of same-origin script execution; on native, storage guarantees depend on the plugin/platform implementation and device protections. This is an architectural exposure and threat-model choice, not proof that an unauthenticated remote party can directly read preferences.

Choose a platform-specific session model deliberately: secure native storage where a durable bearer token is required, or a backend-supported cookie/session design on web with CSRF controls as needed. Do not simply move a token between JavaScript-readable stores and call it protected. Token lifetime, rotation, revocation and logout server semantics require backend review.

## Authorization and input handling

Group checks hide menu entries, but no GetMiddleware protects named routes. New-user navigation is also exposed from the login screen, so self-registration versus administrator-only registration must be clarified with the backend owner. Do not classify that link alone as a vulnerability. User mutation endpoints must enforce permissions independently of client role fields.

JSON parsing and domain validation are inconsistent. Several forms accept required-only numeric text and later default invalid parsing to zero; ministry planning fields and place-type range forms have stronger validators. The user edit payload includes group/isActive/reset fields, but their server authorization cannot be determined here. The unused client toggle/delete user methods contain commented-out network operations; no active view call sites were found, so they are not reported as broken live account actions.

No file-upload path or SQL query construction is present in reviewed client code. SQL injection, IDOR, password hashing quality, rate limits, CORS, CSRF posture, server logging, tenant isolation and transaction safety are **not verified**.

## Error disclosure and observability

Transport/repository/controller layers display raw exception/server text in modal dialogs and print some errors. This can expose internal endpoint/error details if returned by the server. No verified secret-bearing log statement is asserted. Prefer sanitized actionable messages, structured diagnostics with request IDs, and redaction at the server and client logging boundaries.

The source review did not find a hardcoded credential that warranted reporting its value/location. This is not a complete secret-history certification: Git history was inspected at a summary level only, not exhaustively scanned for historical secrets. Hostnames in configuration are deployment identifiers rather than credentials; the audit does not contact them.

## Dependencies and deployment

Resolved dependency versions are inventoried from the existing modified lockfile. Vulnerability/advisory status is **not verified** because no advisory query, package-manager audit, or online security scan was performed under the offline/read-only boundary. No CVE is invented and no package is labeled safe based solely on version age.

Production response headers, CSP, TLS termination, reverse-proxy configuration and actual deployed assets are unavailable. A server CSP could constrain a browser exploit but does not remove the source-level HTML encoding/isolation defect. Android/macOS release networking and signing issues require artifact inspection in a separate authorized environment (BUILD-01/02).

## Prioritized security work

First address HTTPS transport and executable HTML trust boundaries; then centralize account-scoped cache/session invalidation. Next make client role handling fail closed, provide route guards for correct UX, and independently test backend permissions. Finally verify package advisories, release signing/entitlements, production headers and sensitive logging with the actual deployment owners. These are recommended follow-up actions only; no fixes were made.
