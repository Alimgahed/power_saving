// Regression coverage for the explicitly approved chemical completion boundary.
// PendingHttp is in-memory only: no backend request is possible.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/features/chemcails/controller/add_chemacial.dart';
import 'package:power_saving/features/chemcails/model/chemacial.dart';
import '../state_management/fixtures.dart';
import '../program/missing_argument_navigation_test.dart' show LocalChemical;

class DialogObserver extends NavigatorObserver {
  int dialogs = 0;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) dialogs++;
  }
}
void main() {
  tearDown(() => Get.reset());
  for (final edit in [false, true]) {
    for (final closed in [false, true]) {
      for (final status in [200, 201, 400, 401, 403, 500, 0]) {
        testWidgets('${edit ? 'edit' : 'add'} chemical ${closed ? 'disposed' : 'active'} completion $status', (tester) async {
          Get.testMode = true;
          SharedPreferences.setMockInitialValues({'token':'fixture'});
          await Cache.init();
          Get.put(SessionService());
          final observer = DialogObserver();
          await tester.pumpWidget(GetMaterialApp(initialRoute:'/other', navigatorObservers:[observer], getPages:[
            GetPage(name:'/other',page:()=>const Scaffold(body:Text('other'))),
            GetPage(name:'/Chemicals',page:()=>const Scaffold(body:Text('chemicals'))),
            GetPage(name:'/Login',page:()=>const Scaffold(body:Text('login'))),
          ]));
          await tester.pumpAndSettle();
          // Permanent registration isolates controller liveness from route cleanup.
          final c = Get.put<addchemical>(LocalChemical(), permanent:true);
          final data = AlumChlorineReference(chemicalId:7,technologyId:1,waterSourceId:2,season:'fixture',chlorineRangeFrom:0,chlorineRangeTo:1);
          final net = PendingHttp();
          var loadingAtCompletion = false;
          var lateUpdates = 0;
          late Worker worker;
          await tester.runAsync(() => http.runWithClient(() async {
            final result = edit ? c.editchemicals(reference:data,id:7) : c.addchemicals(reference:data);
            await net.started(1);
            expect(net.requests.single.method, 'POST');
            expect(net.requests.single.url.toString(), '${ApiConfig.baseUrl}/${edit ? 'edit-chemical/7' : 'new-chemical'}');
            expect(jsonDecode(net.requests.single.body), data.toJson());
            expect(net.requests.single.headers['Authorization'], 'Bearer fixture');
            expect(net.requests.single.headers['Content-Type'], contains('application/json'));
            loadingAtCompletion = c.loading.value;
            worker = ever(c.loading, (_) => lateUpdates++);
            if (closed) {
              Get.delete<addchemical>(force:true);
              expect(c.isClosed, isTrue);
            }
            if (status == 0) {
              net.responses.single.completeError(StateError('fixture network error'));
            } else {
              net.finish(0, {'message':'fixture error'},status:status);
            }
            await result;
            expect(net.requests.length, 1); // no retry/duplicate/cancellation
          }, () => net.client));
          await tester.pumpAndSettle();
          if (closed) {
            expect(Get.currentRoute, '/other');
            expect(observer.dialogs, 0);
            expect(Get.isDialogOpen, isNot(true));
            expect(c.loading.value, loadingAtCompletion);
            expect(lateUpdates, 0);
            expect(Cache.getdata(key:'token'), 'fixture');
          } else if (status == 401 || status == 403) {
            expect(Get.currentRoute, '/Login');
            expect(Cache.getdata(key:'token'), isNull);
          } else {
            expect(observer.dialogs, 1);
            expect(Get.currentRoute, status == 200 ? '/Chemicals' : '/other');
            expect(c.loading.value, false);
            if (status != 200) {
              expect(find.text(status == 0 ? 'Bad state: fixture network error' : 'fixture error'), findsOneWidget);
            }
          }
          worker.dispose();
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        });
      }
    }
  }
}
