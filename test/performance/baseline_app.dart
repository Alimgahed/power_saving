// Local-only profiling entry point; never used by lib/main.dart.
// ignore_for_file: avoid_print, deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/features/technology/controller/edit_tech_controller.dart';
import '../lifecycle/report_fixture.dart';

final host = GlobalKey<HostState>();
final samples = <Map<String,dynamic>>[];
final frameGaps = <double>[];
final flutterFrames = <Map<String,int>>[];
var collecting = true;
var requests = 0;
var body = '[]';
late http.Client fixtureClient;
@JS('performance')
external JSObject get browserPerformance;
num? heapBytes() {
  if (!browserPerformance.has('memory')) return null;
  final memory=browserPerformance.getProperty<JSObject>('memory'.toJS);
  return memory.getProperty<JSNumber>('usedJSHeapSize'.toJS).toDartDouble;
}
Future<void> publish(Map<String,dynamic> value) async {
  samples.add(value);
  await html.HttpRequest.request('/__baseline_metrics',method:'POST',sendData:jsonEncode(value),requestHeaders:{'Content-Type':'application/json'});
}
Future<void> frames([int count=2]) async {
  for(var i=0;i<count;i++) { await html.window.animationFrame; }
}
Future<void> frameProbe() async {
  var last = await html.window.animationFrame;
  while(collecting) {
    final now = await html.window.animationFrame;
    frameGaps.add((now-last).toDouble());
    last=now;
  }
}
Future<Map<String,dynamic>> measure(String phase,int rows,int run,FutureOr<void> Function() action) async {
  await frames();
  final fi=frameGaps.length;
  final before=heapBytes();
  final watch=Stopwatch()..start();
  await action();
  final workUs=watch.elapsedMicroseconds;
  await frames();
  watch.stop();
  final value=<String,dynamic>{'phase':phase,'rows':rows,'run':run,'warmup':run==0,'work_us':workUs,'through_two_raf_us':watch.elapsedMicroseconds,'frame_gaps_ms':frameGaps.sublist(fi),'heap_before':before,'heap_after':heapBytes(),'request_count':requests};
  await publish(value);
  return value;
}
void check(bool ok,String message) { if(!ok) throw StateError(message); }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final font=FontLoader('FixtureFont');
  final fontResponse=await html.HttpRequest.request('/__fixture_font',responseType:'arraybuffer');
  font.addFont(Future.value(ByteData.view(fontResponse.response as ByteBuffer)));
  await font.load();
  SharedPreferences.setMockInitialValues({'token':'local-fixture'});
  await Cache.init();
  Get.put(SessionService(), permanent:true);
  SchedulerBinding.instance.addTimingsCallback((timings) {
    for(final t in timings) { flutterFrames.add({'build_us':t.buildDuration.inMicroseconds,'raster_us':t.rasterDuration.inMicroseconds}); }
  });
  fixtureClient=MockClient((r) async {
    requests++;
    check(r.method=='POST' && r.url.path=='/reports','Unexpected API call: ${r.method} ${r.url}');
    check(jsonEncode(jsonDecode(r.body))==jsonEncode({'report_name':'branch_total','from_date':'2026-01-01','to_date':'2026-12-31'}),'Request payload mismatch');
    return http.Response(body,200,headers:{'content-type':'application/json; charset=utf-8'});
  });
  runApp(GetMaterialApp(theme:ThemeData(useMaterial3:true,fontFamily:'FixtureFont'),debugShowCheckedModeBanner:false,home:Host(key:host)));
}
class Host extends StatefulWidget {
  const Host({super.key});
  @override
  State<Host> createState()=>HostState();
}
class HostState extends State<Host> {
  Widget screen=const Center(child:Text('Local fixture performance baseline — ready'));
  bool running=false;
  void show(Widget value) { setState(()=>screen=value); }
  @override
  Widget build(BuildContext context)=>Scaffold(body:Column(children:[
    SizedBox(height:40,child:Row(children:[
      const Text('LOCAL FIXTURES ONLY • no production API • profile build'),
      TextButton(onPressed:running?null:() { setState(()=>running=true); http.runWithClient(runBaseline,()=>fixtureClient); },child:const Text('Run baseline')),
    ])),
    Expanded(child:screen),
  ]));
}
Future<void> runBaseline() async {
  try {
    unawaited(frameProbe());
    await publish({'phase':'environment','user_agent':html.window.navigator.userAgent,'viewport':[html.window.innerWidth,html.window.innerHeight],'device_pixel_ratio':html.window.devicePixelRatio,'heap_supported':heapBytes()!=null,'mode':'profile','fixture':'test/lifecycle/report_fixture.dart','auth':'isolated fixture harness; production auth/routes not modified','started':DateTime.now().toIso8601String()});
    await frames(10);
    for(final size in [100,1000,10000]) {
      body=jsonEncode(List.generate(size,reportRow));
      await publish({'phase':'fixture','rows':size,'payload_bytes':utf8.encode(body).length});
      for(var run=0;run<6;run++) {
        final c=Get.put(ReportsController(),permanent:true);
        c.reportname='branch_total';
        c.startdate.text='2026-01-01'; c.enddate.text='2026-12-31';
        await measure('fetch_parse_model_totals',size,run,()=>c.getReports(start:'2026-01-01',end:'2026-12-31',name:'branch_total'));
        check(c.branchs.length==size && c.branchs.last.accountnumber=='A${size-1}','Row/order mismatch');
        check((c.moneysum-c.branchs.fold<double>(0,(v,r)=>v+r.totalBill)).abs()<0.001,'Total mismatch');
        await measure('mount_report',size,run,() { host.currentState!.show(Reports(key:UniqueKey())); });
        await measure('filter_branch_and_render',size,run,() { c.selectedFilterBranch.value='الفرع أ'; });
        check(c.filteredBranchs.length==(size/2).ceil(),'Filter mismatch');
        await measure('clear_filter_and_render',size,run,() { c.selectedFilterBranch.value=null; });
        await measure('html_generation',size,run,() {
          final output=ReportPrinterFactory.forType('branch_total').buildHtml(c);
          check(output.contains('<table') && output.contains('</table>'),'HTML missing');
        });
        // Real report scroll owner, obtained from this isolated widget tree.
        final scrolls=<ScrollPosition>[];
        void visit(Element e) { if(e is StatefulElement && e.state is ScrollableState) { final p=(e.state as ScrollableState).position; if(p.axis==Axis.vertical && p.maxScrollExtent>0) scrolls.add(p); } e.visitChildren(visit); }
        host.currentContext!.visitChildElements(visit);
        await measure('scroll_animation',size,run,() async { if(scrolls.isNotEmpty) await scrolls.last.animateTo(scrolls.last.maxScrollExtent,duration:const Duration(milliseconds:300),curve:Curves.linear); });
        host.currentState!.show(const Center(child:Text('Preparing next local fixture')));
        await frames();
        Get.delete<ReportsController>(force:true);
        check(c.isClosed,'Report owner did not close');
        await frames();
      }
    }
    // Existing dashboard conversion getters; no iframe/chart network resources.
    for(final size in [100,1000,10000]) {
      final raw=List.generate(size,(i)=>{'station_id':i,'station_name':'Station $i','technology_id':1,'technology_name':'Fixture','tech_bill_id':i,'technology_water_amount':10,'technology_power_consump':5});
      final model=ConsumptionModel.fromJson({'over_power_consump':raw});
      for(var run=0;run<6;run++) {
        await measure('dashboard_getter_20_reads',size,run,() {
          List<OverConsump>? previous;
          for(var i=0;i<20;i++) { final next=model.overPowerConsump; check(next.length==size,'Dashboard mapping mismatch'); if(previous!=null)check(!identical(previous,next)&&!identical(previous.first,next.first),'Unexpected getter reuse'); previous=next; }
        });
      }
    }
    body=jsonEncode(List.generate(100,reportRow));
    final lifecycleStart=heapBytes();
    for(var i=0;i<20;i++) {
      final c=Get.put(ReportsController(),permanent:true)..reportname='branch_total';
      await c.getReports(start:'2026-01-01',end:'2026-12-31',name:'branch_total');
      host.currentState!.show(Reports(key:UniqueKey())); await frames();
      host.currentState!.show(const SizedBox()); await frames();
      Get.delete<ReportsController>(force:true);
      final edit=Get.put(EditTechController()); Get.delete<EditTechController>(force:true);
      check(c.isClosed && edit.isClosed && !Get.isRegistered<ReportsController>() && !Get.isRegistered<EditTechController>(),'Retained controller registration');
      await publish({'phase':'lifecycle_cycle','cycle':i+1,'heap':heapBytes(),'reports_closed':c.isClosed,'edit_closed':edit.isClosed,'remaining_test_controller_registrations':0});
    }
    await frames(20);
    collecting=false;
    await publish({'phase':'complete','request_count':requests,'lifecycle_heap_before':lifecycleStart,'lifecycle_heap_after':heapBytes(),'forced_gc':false,'flutter_frame_timings':flutterFrames,'browser_raf_gaps_ms':frameGaps,'completed':DateTime.now().toIso8601String()});
    host.currentState!.show(const Center(child:Text('Baseline complete — measurements saved locally. No optimizations applied.')));
  } catch(e,st) {
    collecting=false;
    await publish({'phase':'error','message':'$e','stack':'$st'});
    host.currentState!.show(Center(child:Text('Baseline failed: $e')));
  }
}
