# Batch 12 — user-edit dialog resource ownership

Confirmed LIFE-01: AllUserScreen allocated three TextEditingControllers and one ValueNotifier per edit dialog without disposal. Their lifetime belongs to the dialog subtree, not AllUserController or the enclosing page. Disposing when showDialog's Future completes could be too early during exit animation, so a private StatefulWidget now owns these resources and disposes them when that subtree unmounts.

Exact changes: lib/features/auth/view/screens/all_user.dart; test/program/user_dialog_lifecycle_test.dart. Full candidate diff: batch.diff. Dialog markup, field values, valid group choices, reset-password flag ownership, actions and editUser calls are unchanged. No API/network/controller/model or business rules changed. No shared resource disposed, request cancelled, dependency added or data cache introduced.

Before: all three dismissal cases (cancel, barrier, route back) fail the resource-disposal assertion. After: 3/3 pass, including original field values and unchanged submitted User.toJson content; save continues to leave the dialog open. Combined suite 218/218 passed. Analyzer 53 existing diagnostics, no errors (exit 1). Web build passed in 52.6s (build.log). git diff --check passed.

Tests initially exposed independent Ahem-font layout overflows. Resource tests isolate lifecycle at reduced text scale; batch 13 characterizes/fixes the separate layout problem at normal scale. Protected live-screen verification remains blocked by unavailable authorized test session, per user instruction. No production mutations were submitted. Next batch: confirmed user-card/dialog constrained text and control wrapping.
