import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/core/auth/session_middleware.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';
import 'package:power_saving/features/stations/controller/add_stations_controller.dart';
import 'package:power_saving/features/stations/view/screens/add_station.dart';
import 'dropdown_layout_test.dart' show LayoutStation;

void main() {
  tearDown(() => Get.reset());
  testWidgets('root back uses the declared fallback', (tester) async {
    await tester.pumpWidget(GetMaterialApp(initialRoute:'/edit',getPages:[
      GetPage(name:'/edit',page:()=>const Scaffold(appBar:CustomAppBar(title:'تعديل',backRoute:'/list'))),
      GetPage(name:'/list',page:()=>const Scaffold(body:Text('list'))),
    ]));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(Get.currentRoute,'/list');
  });
  testWidgets('back preserves previous screen instead of using fallback', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home:const Scaffold(body:Text('original'))));
    Get.to(()=>const Scaffold(appBar:CustomAppBar(title:'تعديل',backRoute:'/unused')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(find.text('original'),findsOneWidget);
  });
  testWidgets('catalog root back invokes its existing home callback', (tester) async {
    var homes=0;
    await tester.pumpWidget(GetMaterialApp(home:Scaffold(appBar:ReusableAppBar(title:'قائمة',isSearching:false.obs,onSearchToggle:(){},onNavigateHome:()=>homes++))));
    final bar=tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.leading,isNotNull);
    await tester.tap(find.descendant(of:find.byWidget(bar.leading!),matching:find.byType(IconButton)).first);
    expect(homes,1);
  });
  for(final direction in [TextDirection.rtl,TextDirection.ltr]) {
    testWidgets('back stays physically left for $direction',(tester) async {
      await tester.pumpWidget(MaterialApp(home:Directionality(textDirection:direction,child:const Scaffold(appBar:CustomAppBar(title:'عنوان')))));
      final bar=tester.widget<AppBar>(find.byType(AppBar));
      expect(bar.leading,isNotNull);
      expect(find.byIcon(Icons.arrow_back),findsOneWidget);
      final x=tester.getCenter(find.byIcon(Icons.arrow_back)).dx;
      expect(x<400,isTrue);
    });
  }
  for(final width in [375.0,768.0,1440.0]) {
    testWidgets('form uses symmetric bounded content at $width',(tester) async {
      tester.view.physicalSize=Size(width,1200);tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
      Get.put<AddStationController>(LayoutStation());
      await tester.pumpWidget(GetMaterialApp(home:AddStationScreen()));
      await tester.pump();
      final card=tester.getRect(find.byType(FormCard).first);
      expect(card.left,closeTo(width-card.right,0.1));
      expect(card.width,closeTo(width<600 ? width-32 : (width-48).clamp(0,960),0.1));
      final container=tester.widget<Container>(find.descendant(of:find.byType(FormCard).first,matching:find.byType(Container)).first);
      expect(container.padding,EdgeInsets.all(width<600?16:24));
      expect(find.byType(DropdownButtonFormField<int>),findsNWidgets(3));
      expect(find.byType(DropdownButtonFormField<String>),findsOneWidget);
      expect(tester.takeException(),isNull);
    });
  }
  testWidgets('catalog search can open and close without leaving its screen',(tester) async {
    final searching=false.obs;
    var toggles=0;
    await tester.pumpWidget(GetMaterialApp(home:Scaffold(appBar:ReusableAppBar(title:'قائمة',isSearching:searching,onSearchToggle:(){toggles++;searching.toggle();},onNavigateHome:(){}))));
    await tester.tap(find.byIcon(Icons.search)); await tester.pump();
    expect(find.byType(TextFormField),findsOneWidget);
    expect(find.byIcon(Icons.close),findsOneWidget);
    await tester.tap(find.byIcon(Icons.close)); await tester.pumpAndSettle();
    expect(toggles,2); expect(find.text('قائمة'),findsOneWidget);
  });
  testWidgets('back respects a blocked route without running root fallback',(tester) async {
    var fallbackCalls=0;
    await tester.pumpWidget(GetMaterialApp(home:const Scaffold(body:Text('original'))));
    Get.to(()=>PopScope(canPop:false,child:Scaffold(appBar:ReusableAppBar(title:'draft',isSearching:false.obs,onSearchToggle:(){},onNavigateHome:()=>fallbackCalls++))));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('draft'),findsOneWidget); expect(fallbackCalls,0);
  });
  testWidgets('root fallback still passes through authentication middleware',(tester) async {
    SharedPreferences.setMockInitialValues({}); await Cache.init(); Get.put(SessionService());
    await tester.pumpWidget(GetMaterialApp(initialRoute:'/fixture',getPages:[
      GetPage(name:'/fixture',page:()=>const Scaffold(appBar:CustomAppBar(title:'fixture',backRoute:'/protected'))),
      GetPage(name:'/protected',middlewares:[SessionMiddleware()],page:()=>const Scaffold(body:Text('protected'))),
      GetPage(name:'/Login',page:()=>const Scaffold(body:Text('login'))),
    ]));
    await tester.pumpAndSettle(); await tester.tap(find.byTooltip('Back')); await tester.pumpAndSettle();
    expect(Get.currentRoute,'/Login'); expect(find.text('protected'),findsNothing);
  });
  testWidgets('explicit card padding stays supported',(tester) async {
    await tester.pumpWidget(const MaterialApp(home:Scaffold(body:FormCard(padding:EdgeInsets.all(8),child:Text('custom')))));
    final c=tester.widget<Container>(find.descendant(of:find.byType(FormCard),matching:find.byType(Container)).first);
    expect(c.padding,const EdgeInsets.all(8));
  });
}
