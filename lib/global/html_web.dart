import 'dart:html' as html;

String getPlatformHostname() {
  try {
    return html.window.location.hostname ?? '';
  } catch (_) {
    return '';
  }
}

void openHtmlReport(String htmlContent) {
  try {
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
  } catch (_) {
    // Fallback for popups
  }
}
