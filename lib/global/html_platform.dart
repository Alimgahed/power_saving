import 'html_stub.dart' if (dart.library.html) 'html_web.dart' as platform_html;

String getHostname() {
  return platform_html.getPlatformHostname();
}

void openHtmlReport(String htmlContent) {
  platform_html.openHtmlReport(htmlContent);
}
