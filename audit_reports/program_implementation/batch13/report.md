# Batch 13 — user card/dialog responsive reliability

Root causes: unconstrained user name/info label and edit-dialog title in Rows; active/reset controls wider than their dialog row. Normal-scale widget tests reproduced overflow at 375/768/1440 (3 failed before). A first correction left a 3px mobile name overflow; constraining the name fixed the remaining failure.

Exact files: lib/features/auth/view/screens/all_user.dart; new test/program/user_dialog_layout_test.dart; test/program/user_dialog_lifecycle_test.dart restored from lifecycle-isolation reduced text scale to normal scale. Full source changes in batch.diff. User name/info label/title now receive bounded width without ellipsis or omitted text. Status/reset controls wrap; all labels, three fields, group options, switch, checkbox and save/cancel actions remain. Submission method, User construction and reset flag ownership remain unchanged.

Focused layout+lifecycle: 6/6 passed. Combined: 221/221 passed (baseline before this continuation: 211). Analyzer completed with 53 existing diagnostics, no errors (exit 1). Web build passed in 220.6s; wasm dry run succeeded. git diff --check passed. Frozen contract hash comparison: all 30 unchanged, including financial/network/models/session/dependencies. No business cache, report edits, backend changes, API changes or business mutations. No performance claim.

These are automated widget tests using Flutter's test font. They establish layout containment and control preservation; they are not protected-screen live visual verification. Protected live checks remain blocked by unavailable authorized session. Public screens were actually inspected separately in batch 11. No existing warnings automatically treated as safe changes.
