# Program batch 06 — dropdown constraints

P-UI-01 / N19. Reproduced DropdownButtonFormField overflow at widths 160/240/375 (up to 316px overflow), and in the add-station tablet form. Added only `isExpanded: true` to shared `CustomDropdownFormField<T>` in `lib/my_widget/sharable.dart`; no selection, label, items, validator, initial value or callback changes.

Test `test/program/dropdown_layout_test.dart`: three pre-fix failures; three focused width cases pass after fix with real selection and validation. Added full add-station form tests at 375/768/1440 retaining all four dropdowns and input fields. Combined 184 passed (includes three report-load characterization cases for upcoming batch07). Analyzer 59 existing findings. Web build passed (198.6s); diff check passed. Full reviewed one-line diff in `batch.diff`.

No API/business/model/storage changes. Verified rendered widget layouts, not every application screen in a live browser. Next: parity-proven removal of the report controller's unused private index; general lazy report rendering remains unproven/deferred.
