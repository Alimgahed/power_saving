# Remaining ownership and asynchronous completion assessment

Scope: current lib tree screened for explicit resource allocations, timers, workers, listeners, subscriptions, deferred callbacks, disposal and GetX bindings. ownership_inventory.json records exact source lines in 45 matching files; resource_inventory.txt and async_inventory.txt retain searches. This is source evidence plus targeted tests, not a heap-leak proof or live verification of every route.

## Resource families

| Family / locations | Evidence and disposition |
|---|---|
| Eight catalog/history search controllers | Existing ownedDebounce owns timer and stream subscription; onClose disposes worker. Prior 16 regressions retained and passing. |
| ReportsController | Search timer cancelled, both workers disposed, text listener removed, three fields disposed. Report widget disposes both scroll controllers. Existing lifecycle/output tests passing. |
| PlacesController | Worker and alternative manual-search timer cancelled, search field disposed. No new reproduced leak. |
| Technology billing list and edit/new bill controllers | Search timer cancelled, named search listener removed; dynamic bill draft fields disposed. Edit timer cancelled; owned notifying fields disposed, which also clears their listeners. New-bill named listeners explicitly removed. No change to calculations or draft maps. |
| BalanceChartController | Dynamic draft resources and controller maps disposed in existing onClose/replace paths; prior tests retained. No new fix. |
| Shared dropdown | Focus node and search field owned by its GetX controller and disposed. Existing deferred callback has ownership guard. Shared/tag identity behavior not changed. |
| Auth forms and user dialog | Existing field disposal and recent dialog-subtree ownership retained. SessionService intentionally shared; no new disposal. |
| Meter/station/place/technology/chemical forms | Current fields have onClose disposal. Six missing-argument callback routes fixed in batch 14; valid field initialization preserved. |
| Home and shimmer animation States | Animation controllers disposed by State; DefaultTabController owns its framework controller. |
| Voltage and BillsController / Counter screen field replacement | Old fields can be replaced while attached to calculation listeners or inputs. Known financial-ownership gate remains BLOCKED: replacement/text-setting/disposal timing can affect recalculation, focus and values. No fix or new financial behavior assumed. |
| Legacy OverConsumptionSection / OverWaterStationsSection | ScrollControllers allocated inside build helpers without disposal, but source search finds no instantiation outside definitions. Runtime reachability unconfirmed; no architecture rewrite or speculative deletion. |
| Legacy nested tech_bills/controller/tech_bills/techbills.dart | Per-bill maps dispose values in a loop; allocation/disposal call counts alone are not evidence of leaks. No import from active binding; active binding uses sibling controller/techbills.dart. |

No additional explicit StreamController or StreamSubscription fields were found. ownedDebounce is the explicit subscription owner found by this scan. Framework/GetX internals are not claimed exhaustively audited. Bills' stamp field disposal clears its listeners even without a separate removeListener call; do not report that alone as a leak.

## Mutation boundary — reproduced, NOT changed

In-memory PendingHttp captures the exact POST /new-chemical body and Bearer fixture header, with no network fallback. After the addchemical controller is deleted, a simulated 200 response still redirects the unrelated current route to /Chemicals. A simulated 400 still opens an error dialog; loading is updated after closure. Both characterization tests pass because they assert the observed current behavior, not a desired fix.

Files: test/investigation/mutation_completion_test.dart and mutation_characterization.log. These two investigation tests are run separately from the 233-test approved regression suite. They are evidence for a pending policy decision, not acceptance of late navigation.

Potential sibling call sites include chemical edit, station/meter/place edits and adds, user-edit completion and other submit flows in async_inventory.txt. Source patterns are not asserted as runtime reproductions. Generic cancellation/suppression would change completion feedback, refresh or navigation workflows. Proposed boundary: allow the dispatched request to finish unchanged; only suppress disposed-owner UI writes/dialogs/navigation. Approval requested; implementation remains unchanged pending the user's decision. Existing protected transport/session ownership checks remain intact.

## Navigation and remaining limitations

Missing argument fallback routes retain their exact existing names and offAll/back behavior while current. They no longer build null-dependent forms or act from a replaced/covered route. Analysis back callback receives the same current-route check. The main routingCallback is part of authentication/session policy and remains unchanged. Wrong argument types, root-stack analysis navigation with no previous route, repeated same-feature/shared GetX ownership and untested mutation flows require separate evidence; no new fallback routes invented.

Protected-screen live verification remains BLOCKED without an authorized test session. No personal credentials, auth bypass, backend mutations, data caches or dependencies used. UX-05 remains DEFERRED.
