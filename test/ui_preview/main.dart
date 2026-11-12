// Local component preview only: no authentication, API, or business submission.
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_page.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/core/widgets/main_screen/reuseable_appbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final response=await html.HttpRequest.request('/__fixture_font',responseType:'arraybuffer');
  final loader=FontLoader('FixtureFont')..addFont(Future.value(ByteData.view(response.response as ByteBuffer)));
  await loader.load();
  runApp(GetMaterialApp(locale:const Locale('ar'),supportedLocales:const [Locale('ar')],localizationsDelegates:GlobalMaterialLocalizations.delegates,theme:ThemeData(useMaterial3:true,fontFamily:'FixtureFont'),debugShowCheckedModeBanner:false,initialRoute:'/preview',getPages:[
    GetPage(name:'/preview',page:()=>const Preview()),
    GetPage(name:'/catalog-preview',page:()=>const CatalogPreview()),
  ]));
}
class Preview extends StatelessWidget {
  const Preview({super.key});
  @override
  Widget build(BuildContext context)=>AppScaffold(showDrawer:false,mobileAppBar:const CustomAppBar(title:'بيانات المحطة',backRoute:'/catalog-preview'),body:FormPage(child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    const Padding(padding:EdgeInsets.only(bottom:16),child:Text('معاينة تصميم محلية • بيانات تجريبية فقط',style:TextStyle(color:Colors.blueGrey))),
    FormCard(child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      const SectionHeader(title:'معلومات المحطة',icon:Icons.water_drop_outlined),
      const SizedBox(height:16),
      TextFormField(initialValue:'محطة تجريبية',decoration:const InputDecoration(labelText:'اسم المحطة',prefixIcon:Icon(Icons.location_city),border:OutlineInputBorder())),
      const SizedBox(height:24),
      const Text('تفاصيل التشغيل',style:TextStyle(fontSize:18,fontWeight:FontWeight.w600)),
      const SizedBox(height:16),
      LayoutBuilder(builder:(context,box) {
        const items=[DropdownMenuItem(value:'water',child:Text('مياه')),DropdownMenuItem(value:'waste',child:Text('صرف'))];
        final fields=[DropdownButtonFormField<String>(initialValue:'water',isExpanded:true,items:items,onChanged:(_){},decoration:const InputDecoration(labelText:'نوع المحطة',border:OutlineInputBorder())),TextFormField(initialValue:'1200',decoration:const InputDecoration(labelText:'الطاقة التصميمية',border:OutlineInputBorder()))];
        return box.maxWidth<500 ? Column(children:[fields[0],const SizedBox(height:16),fields[1]]) : Row(children:[Expanded(child:fields[0]),const SizedBox(width:24),Expanded(child:fields[1])]);
      }),
      const SizedBox(height:24),
      FilledButton.icon(onPressed:(){},icon:const Icon(Icons.check),label:const Padding(padding:EdgeInsets.all(12),child:Text('زر توضيحي — لا يتم إرسال بيانات'))),
    ])),
  ])));
}
class CatalogPreview extends StatefulWidget {
  const CatalogPreview({super.key});
  @override
  State<CatalogPreview> createState()=>_CatalogPreviewState();
}
class _CatalogPreviewState extends State<CatalogPreview> {
  final searching=false.obs;
  @override
  Widget build(BuildContext context)=>AppScaffold(showDrawer:false,mobileAppBar:ReusableAppBar(title:'قائمة المحطات',isSearching:searching,onSearchToggle:()=>searching.toggle(),onNavigateHome:()=>Get.offNamed('/preview')),body:FormPage(child:FormCard(child:Column(children:[const SectionHeader(title:'معاينة البحث والرجوع',icon:Icons.search),TextButton(onPressed:()=>Get.toNamed('/preview'),child:const Text('فتح نموذج المعاينة'))]))));
}
