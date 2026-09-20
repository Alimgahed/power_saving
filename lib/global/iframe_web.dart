import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:power_saving/my_widget/sharable.dart';

void registerIframe(String id, String htmlContent) {
  try {
    final iframeElement = html.IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..srcdoc = htmlContent;

    ui_web.platformViewRegistry.registerViewFactory(
      id,
      (int viewId) => iframeElement,
    );
  } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    debugPrint("Error registering iframe: $e");
  }
}

Widget buildIframeWidget(String id) {
  return HtmlElementView(viewType: id);
}
