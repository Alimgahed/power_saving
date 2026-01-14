// lib/config/api_config.dart
import 'dart:html' as html;

class ApiConfig {
  // Private constructor
  ApiConfig._();
  
  // Singleton instance
  static final ApiConfig _instance = ApiConfig._();
  static ApiConfig get instance => _instance;
  
  // Configuration
  static const String localIP = "172.16.0.10:5000";
  static const String publicIP = "41.33.3.92:5000";
  static const String localhostIP = "localhost:5000";
  
  /// Automatically detect and return the appropriate API URL
  static String get baseUrl {
    final currentHost = html.window.location.hostname;
    
    // Check where the app is being accessed from
    if (currentHost == 'localhost' || currentHost == '127.0.0.1') {
      // Accessed from localhost
      return "http://$localhostIP";
    } else if (currentHost!.startsWith('172.16.') || currentHost.startsWith('192.168.')) {
      // Accessed from local network (LAN)
      return "http://$localIP";
    } else {
      // Accessed from public internet
      return "http://$publicIP";
    }
  }
  
  /// Alternative: Return just the IP:PORT for your existing code
  static String get ip {
    final currentHost = html.window.location.hostname;
    
    if (currentHost == 'localhost' || currentHost == '127.0.0.1') {
      return localhostIP;
    } else if (currentHost!.startsWith('172.16.') || currentHost.startsWith('192.168.')) {
      return localIP;
    } else {
      return publicIP;
    }
  }
  
  /// Manual override for testing
  static String getUrlForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'local':
        return "http://$localhostIP";
      case 'lan':
        return "http://$localIP";
      case 'public':
        return "http://$publicIP";
      default:
        return baseUrl;
    }
  }
  
  /// Debug: Print current configuration
  static void printConfig() {
    print('🌐 Current hostname: ${html.window.location.hostname}');
    print('🔗 API URL: $baseUrl');
    print('📍 Using IP: $ip');
  }
}