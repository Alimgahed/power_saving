import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';
import 'package:power_saving/features/bill/controller/tech_bills.dart';
import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'session-A'});
    await Cache.init();
  });
  tearDown(() {
    Get.reset();
  });

  test(
    'planning network refresh preserves dirty controllers, selection and payload',
    () async {
      final c = BalanceChartController();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        final initial = c.allvalues();
        await net.started(1);
        net.finish(0, [placeType(4)]);
        await initial;
        final refresh = c.allvalues();
        await net.started(2);
        final field = c.textControllers[4]!;
        field.value = const TextEditingValue(
          text: '42',
          selection: TextSelection.collapsed(offset: 1),
        );
        c.areaid = 7;
        c.yearController.text = '2035';
        c.incresableController.text = '3';
        c.selectedMethod.value = 'ministry';
        net.finish(1, [placeType(9), placeType(4, name: 'Updated')]);
        await refresh;
        expect(identical(field, c.textControllers[4]), isTrue);
        expect(field.text, '42');
        expect(field.selection.baseOffset, 1);
        expect(c.textControllers[9]!.text, isEmpty);
        expect(c.allTypes.last.placeTypeName, 'Updated');
        expect(c.areaid, 7);
        expect(c.yearController.text, '2035');
        expect(c.buildRequestBody(), {
          'calc_type': 'ministry',
          'is_modified': true,
          'increasable': 3,
          'goal_year': 2035,
          'is_future': false,
          '4': 42,
        });
      }, () => net.client);
    },
  );
  test(
    'removed planning reference retains draft for restoration but is not submitted',
    () async {
      final c = BalanceChartController();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        var task = c.allvalues(isBackground: true);
        await net.started(1);
        net.finish(0, [placeType(4)]);
        await task;
        final field = c.textControllers[4]!;
        field.text = '31';
        task = c.allvalues(isBackground: true);
        await net.started(2);
        net.finish(1, [placeType(9)]);
        await task;
        expect(c.allTypes.single.placeTypeId, 9);
        expect(c.buildRequestBody().containsKey('4'), isFalse);
        task = c.allvalues(isBackground: true);
        await net.started(3);
        net.finish(2, [placeType(4)]);
        await task;
        expect(identical(field, c.textControllers[4]), isTrue);
        expect(field.text, '31');
      }, () => net.client);
    },
  );
  test(
    'planning area refresh retains selected removed area and dirty increase',
    () async {
      final c = BalanceChartController();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        var task = c.allareas();
        await net.started(1);
        net.finish(0, [
          {'area_id': 7, 'area_name': 'Original', 'increasable': true},
        ]);
        await task;
        c.onAreaChanged(7);
        c.incresableController.text = '9';
        task = c.allareas(isBackground: true);
        await net.started(2);
        net.finish(1, [
          {'area_id': 8, 'area_name': 'New', 'increasable': false},
        ]);
        await task;
        expect(c.areaid, 7);
        expect(c.selectedArea!.areaId, 7);
        expect(c.areas.single.areaId, 8);
        expect(c.incresableController.text, '9');
        expect(c.isIncreasableArea.value, isTrue);
      }, () => net.client);
    },
  );
  for (final channel in ['types', 'areas']) {
    test('planning $channel ignores older response independently', () async {
      final c = BalanceChartController();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        Future<void> load() =>
            channel == 'types'
                ? c.allvalues(isBackground: true)
                : c.allareas(isBackground: true);
        Object data(int id) =>
            channel == 'types'
                ? [placeType(id)]
                : [
                  {'area_id': id, 'area_name': 'Area $id'},
                ];
        final a = load();
        final b = load();
        await net.started(2);
        net.finish(1, data(2));
        await b;
        net.finish(0, data(1));
        await a;
        expect(
          channel == 'types'
              ? c.allTypes.single.placeTypeId
              : c.areas.single.areaId,
          2,
        );
        expect(net.requests, hasLength(2));
      }, () => net.client);
    });
  }
  test('planning independent area/type requests both commit', () async {
    final c = BalanceChartController();
    addTearDown(c.onClose);
    final net = PendingHttp();
    await http.runWithClient(() async {
      final a = c.allareas();
      final b = c.allvalues();
      await net.started(2);
      net.finish(1, [placeType(4)]);
      await b;
      net.finish(0, [
        {'area_id': 7, 'area_name': 'Area'},
      ]);
      await a;
      expect(c.areas.single.areaId, 7);
      expect(c.allTypes.single.placeTypeId, 4);
    }, () => net.client);
  });
  test('planning submit keeps POST/body and ignores prior result', () async {
    final c = BalanceChartController();
    addTearDown(c.onClose);
    final net = PendingHttp();
    c.yearController.text = '2035';
    final expected = c.buildRequestBody();
    await http.runWithClient(() async {
      final a = c.submitData(7);
      final b = c.submitData(7);
      await net.started(2);
      for (final request in net.requests) {
        expect(request.method, 'POST');
        expect(request.url.path, '/balance-plot-calc/7');
        expect(jsonDecode(request.body), expected);
        expect(request.headers['Authorization'], 'Bearer session-A');
      }
      net.finish(1, {}, status: 204);
      await b;
      net.finish(0, {'best_model': 'old invalid response'});
      await a;
      expect(c.isloading.value, isFalse);
      expect(c.balanceData.value, isNull);
    }, () => net.client);
  });

  test(
    'technology drafts follow IDs through filter, reorder and removal',
    () async {
      final c = Techbills();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        var task = c.fetchTechBills();
        await net.started(1);
        net.finish(0, [techBill(11), techBill(22, branch: 'South')]);
        await task;
        final a = c.getChlorineController(11);
        final b = c.getChlorineController(22);
        a.text = '1.5';
        b.text = '2.5';
        final key = c.getFormKey(22);
        c.filterByBranch('South');
        expect(c.filteredTechBills.single.techBillId, 22);
        c.clearFilters();
        c.techBills.sort((a, b) => b.techBillId.compareTo(a.techBillId));
        c.applyFilters();
        expect(
          c.getChlorineController(c.filteredTechBills.first.techBillId).text,
          '2.5',
        );
        task = c.fetchTechBills(isBackground: true);
        await net.started(2);
        net.finish(1, [techBill(22), techBill(11)]);
        await task;
        expect(identical(c.getChlorineController(22), b), isTrue);
        expect(identical(c.getFormKey(22), key), isTrue);
        expect(a.text, '1.5');
        // Populate every owned field before removing the record.
        final removed = [
          a,
          c.getLiquidAlumController(11),
          c.getSolidAlumController(11),
          c.getWaterProducedController(11),
          c.getcalculatedWaterControllers(11),
          c.getmeasuredWaterControllers(11),
        ];
        c.getFormKey(11);
        task = c.fetchTechBills(isBackground: true);
        await net.started(3);
        net.finish(2, [techBill(22)]);
        await task;
        expect(c.formKeys.containsKey(11), isFalse);
        expect(c.chlorineControllers.containsKey(11), isFalse);
        for (final field in removed) {
          expect(() => field.addListener(() {}), throwsFlutterError);
        }
        expect(b.text, '2.5');
        task = c.fetchTechBills(isBackground: true);
        await net.started(4);
        net.finish(3, [techBill(11), techBill(22)]);
        await task;
        expect(c.getChlorineController(11).text, isEmpty);
        expect(identical(c.getChlorineController(11), a), isFalse);
        expect(c.getChlorineController(22).text, '2.5');
      }, () => net.client);
    },
  );
  test(
    'all six technology fields share stable bill ownership without duplicate controllers',
    () {
      final c = Techbills();
      addTearDown(c.onClose);
      final getters = [
        c.getChlorineController,
        c.getLiquidAlumController,
        c.getSolidAlumController,
        c.getWaterProducedController,
        c.getcalculatedWaterControllers,
        c.getmeasuredWaterControllers,
      ];
      for (final getter in getters) {
        final a = getter(11);
        a.text = '3.25';
        expect(identical(a, getter(11)), isTrue);
        expect(getter(22).text, isEmpty);
        expect(getter(11).text, '3.25');
      }
    },
  );
  test(
    'operational read rejects old response overwrite and reapplies active filters',
    () async {
      final c = Techbills();
      addTearDown(c.onClose);
      final net = PendingHttp();
      await http.runWithClient(() async {
        final a = c.fetchTechBills();
        final b = c.fetchTechBills();
        await net.started(2);
        c.filterByBranch('South');
        net.finish(1, [techBill(22, branch: 'South')]);
        await b;
        net.finish(0, [techBill(11)]);
        await a;
        expect(c.filteredTechBills.single.techBillId, 22);
        expect(net.requests, hasLength(2));
        expect(c.loading.value, isFalse);
      }, () => net.client);
    },
  );

  for (final technology in [false, true]) {
    test(
      '${technology ? 'technology' : 'meter'} history latest page wins, without cache',
      () async {
        final meter = AllBills();
        final tech = TechBillscontroller();
        addTearDown(meter.onClose);
        addTearDown(tech.onClose);
        final net = PendingHttp();
        await http.runWithClient(() async {
          Future<void> load() =>
              technology ? tech.allbills() : meter.allbills();
          final a = load();
          tech.currentPage = 2;
          meter.currentPage.value = 2;
          final b = load();
          await net.started(2);
          net.finish(1, page([technology ? techBill(22) : meterBill(22)], 2));
          await b;
          net.finish(0, page([technology ? techBill(11) : meterBill(11)], 1));
          await a;
          expect(
            technology
                ? tech.bills.single.techBillId
                : meter.bills.single.guageBillId,
            22,
          );
          expect(technology ? tech.currentPage : meter.currentPage.value, 2);
          expect(net.requests, hasLength(2));
          expect(
            technology ? tech.isLoading.value : meter.isLoading.value,
            isFalse,
          );
        }, () => net.client);
      },
    );
    test(
      '${technology ? 'technology' : 'meter'} old completion cannot stop latest loading',
      () async {
        final m = AllBills();
        final t = TechBillscontroller();
        addTearDown(m.onClose);
        addTearDown(t.onClose);
        final net = PendingHttp();
        await http.runWithClient(() async {
          final a = technology ? t.allbills() : m.allbills();
          final b = technology ? t.allbills() : m.allbills();
          await net.started(2);
          net.finish(0, page([], 1));
          await a;
          expect(technology ? t.isLoading.value : m.isLoading.value, isTrue);
          net.finish(1, page([], 1));
          await b;
          expect(technology ? t.isLoading.value : m.isLoading.value, isFalse);
        }, () => net.client);
      },
    );
    test(
      '${technology ? 'technology' : 'meter'} history suppresses stale 401 side effects',
      () async {
        final m = AllBills();
        final t = TechBillscontroller();
        addTearDown(m.onClose);
        addTearDown(t.onClose);
        final net = PendingHttp();
        await http.runWithClient(() async {
          final a = technology ? t.allbills() : m.allbills();
          final b = technology ? t.allbills() : m.allbills();
          await net.started(2);
          net.finish(1, page([], 1));
          await b;
          net.finish(0, {'error': 'old'}, status: 401);
          await a;
          expect(Cache.getdata(key: 'token'), 'session-A');
          expect(Get.isDialogOpen, isNot(true));
        }, () => net.client);
      },
    );
    test(
      '${technology ? 'technology' : 'meter'} network refresh obeys new filters',
      () async {
        final m = AllBills();
        final t = TechBillscontroller();
        addTearDown(m.onClose);
        addTearDown(t.onClose);
        final net = PendingHttp();
        await http.runWithClient(() async {
          final a = technology ? t.allbills() : m.allbills();
          await net.started(1);
          t.selectedYear = '2025';
          m.selectedYear = '2025';
          final b = technology ? t.allbills() : m.allbills();
          await net.started(2);
          net.finish(1, page([technology ? techBill(2) : meterBill(2)], 1));
          await b;
          net.finish(0, page([technology ? techBill(3) : meterBill(3)], 1));
          await a;
          expect(
            technology ? t.bills.single.techBillId : m.bills.single.guageBillId,
            2,
          );
          expect(technology ? t.selectedYear : m.selectedYear, '2025');
        }, () => net.client);
      },
    );
  }
  for (final kind in ['planning', 'operational', 'meter', 'history']) {
    for (final disposed in [true, false]) {
      test(
        '$kind ignores ${disposed ? 'disposed' : 'previous-session'} response and auth error',
        () async {
          final p = BalanceChartController();
          final o = Techbills();
          final m = AllBills();
          final t = TechBillscontroller();
          final close = <String, void Function()>{
            'planning': p.onClose,
            'operational': o.onClose,
            'meter': m.onClose,
            'history': t.onClose,
          };
          for (final entry in close.entries) {
            if (entry.key != kind || !disposed) addTearDown(entry.value);
          }
          final net = PendingHttp();
          await http.runWithClient(() async {
            final a = switch (kind) {
              'planning' => p.allvalues(),
              'operational' => o.fetchTechBills(),
              'meter' => m.allbills(),
              _ => t.allbills(),
            };
            await net.started(1);
            if (disposed) {
              close[kind]!();
            } else {
              await Cache.saveData(key: 'token', value: 'session-B');
            }
            net.finish(0, {'error': 'old session'}, status: 401);
            await a;
            expect(
              Cache.getdata(key: 'token'),
              disposed ? 'session-A' : 'session-B',
            );
            expect(p.allTypes, isEmpty);
            expect(o.techBills, isEmpty);
            expect(m.bills, isEmpty);
            expect(t.bills, isEmpty);
            expect(Get.isDialogOpen, isNot(true));
          }, () => net.client);
        },
      );
    }
  }
  test(
    'session service replacement invalidates a read even if token has not changed yet',
    () async {
      final session = Get.put(SessionService());
      final c = AllBills();
      addTearDown(c.onClose);
      final net = PendingHttp();
      // Replacing the session container itself must also invalidate pending work.
      await http.runWithClient(() async {
        final a = c.allbills();
        await net.started(1);
        await Get.delete<SessionService>(force: true);
        Get.put(SessionService());
        net.finish(0, page([meterBill(1)], 1));
        await a;
        expect(c.bills, isEmpty);
        expect(identical(Get.find<SessionService>(), session), isFalse);
      }, () => net.client);
    },
  );
  testWidgets(
    'technology save preserves payload, clears submitted fields only, and refreshes',
    (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(home: const Scaffold(body: SizedBox())),
      );
      final c = Techbills();
      final net = PendingHttp();
      final chlorine = c.getChlorineController(11)..text = '1.25';
      final liquid = c.getLiquidAlumController(11)..text = '2.5';
      await tester.runAsync(
        () => http.runWithClient(() async {
          final save = c.addTechBills(
            id: 11,
            chlorine: 1.25,
            liquid: 2.5,
            solid: 3.75,
            water: 4.5,
            calculatedWater: 5.25,
            measuredWater: 6.5,
          );
          await net.started(1);
          final request = net.requests.single;
          expect(request.method, 'POST');
          expect(request.url.path, '/edit-tech-bill/11');
          expect(request.headers['Authorization'], 'Bearer session-A');
          expect(
            request.headers['Content-Type'],
            'application/json; charset=utf-8',
          );
          expect(jsonDecode(request.body), {
            'technology_chlorine_consump': 1.25,
            'technology_liquid_alum_consump': 2.5,
            'technology_solid_alum_consump': 3.75,
            'technology_water_amount': 4.5,
            'calculated_water': 5.25,
            'measured_water': 6.5,
          });
          chlorine.text = '9.5';
          net.finish(0, {});
          await save;
          await net.started(2);
          expect(chlorine.text, '9.5');
          expect(liquid.text, isEmpty);
          expect(c.loadingBillId.value, isNull);
          expect(net.requests[1].url.path, '/tech-bills');
          net.finish(1, [techBill(11)]);
          await Future<void>.delayed(Duration.zero);
        }, () => net.client),
      );
      await tester.pumpAndSettle();
      expect(Get.isDialogOpen, isTrue);
      Get.back();
      await tester.pumpAndSettle();
      c.onClose();
    },
  );
  for (final disposed in [false, true]) {
    test(
      'technology pending save ignores ${disposed ? 'disposal' : 'session change'}',
      () async {
        final c = Techbills();
        final net = PendingHttp();
        final field = c.getChlorineController(11)..text = '1.25';
        await http.runWithClient(() async {
          final task = c.addTechBills(
            id: 11,
            chlorine: 1.25,
            liquid: 2,
            solid: 3,
            water: 4,
            calculatedWater: 5,
            measuredWater: 6,
          );
          await net.started(1);
          if (disposed) {
            c.onClose();
          } else {
            await Cache.saveData(key: 'token', value: 'session-B');
          }
          net.finish(0, {});
          await task;
          expect(net.requests, hasLength(1));
          expect(Get.isDialogOpen, isNot(true));
          if (!disposed) {
            expect(field.text, '1.25');
            c.onClose();
          }
        }, () => net.client);
      },
    );
  }
}
