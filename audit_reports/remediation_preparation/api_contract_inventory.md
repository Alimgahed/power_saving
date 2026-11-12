# Frozen API contract inventory

**Scope:** current client-observed behavior, not a verified server specification. All URLs, HTTP methods, query/header/body shapes, status interpretation and response mappings are frozen. Incompatible inconsistencies are recorded rather than silently corrected. No endpoint was contacted. Commented-out calls are not executable contracts; duplicate/possibly unused methods are retained and labeled by source.

## Base URL and shared transport

[ApiConfig.baseUrl / ip / getUrlForEnvironment](/Users/alimegahed/power_saving/lib/global/ip_config.dart:15) selects HTTP public host on non-web, localhost host for localhost/127.0.0.1, LAN host for 172.16.* or 192.168.*, public host otherwise. Exact current implementation follows. These host constants are configuration, not secrets. No switch to HTTPS, emulator host, same-origin proxy, flavor or environment variable is authorized.

```dart
// lib/config/api_config.dart
import 'package:flutter/foundation.dart';
import 'package:power_saving/global/html_platform.dart';

class ApiConfig {
  // Private constructor
  ApiConfig._();
  
  // Singleton instance
  static final ApiConfig _instance = ApiConfig._();
  static ApiConfig get instance => _instance;
  
  // Configuration
  static const String localIP = "172.16.0.10:5000";
  static const String publicIP = "41.33.3.89:5000";
  static const String localhostIP = "localhost:5000";
  
  /// Automatically detect and return the appropriate API URL
  static String get baseUrl {
    final currentHost = getHostname();
    
    if (currentHost.isEmpty) {
      // Accessed from non-web platform or headless environment
      return "http://$publicIP";
    }
    
    // Check where the app is being accessed from
    if (currentHost == 'localhost' || currentHost == '127.0.0.1') {
      // Accessed from localhost
      return "http://$localhostIP";
    } else if (currentHost.startsWith('172.16.') || currentHost.startsWith('192.168.')) {
      // Accessed from local network (LAN)
      return "http://$localIP";
    } else {
      // Accessed from public internet
      return "http://$publicIP";
    }
  }
  
  /// Alternative: Return just the IP:PORT for your existing code
  static String get ip {
    final currentHost = getHostname();
    
    if (currentHost.isEmpty) {
      return publicIP;
    }
    
    if (currentHost == 'localhost' || currentHost == '127.0.0.1') {
      return localhostIP;
    } else if (currentHost.startsWith('172.16.') || currentHost.startsWith('192.168.')) {
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
    debugPrint('🌐 Current hostname: ${getHostname()}');
    debugPrint('🔗 API URL: $baseUrl');
    debugPrint('📍 Using IP: $ip');
  }
}
```

| Transport | Frozen headers, encoding and behavior |
|---|---|
| fetchData / postData | Content-Type application/json; Authorization Bearer plus cached token or empty string. GET without body; POST jsonEncode(body). Accept all 2xx at transport layer; 401/403 remove token and navigate Login; other status messages decode message/error/body. No explicit application timeout or retry. |
| ApiClient | Content-Type and Accept application/json; Authorization only for nonempty token. GET/POST; POST jsonEncode(body). 15-second default per attempt, up to three attempts for eligible exceptions, 300ms×attempt delay. AppException rethrown. 401/403 AuthenticationException, 422 ValidationException, >=500/other ServerException. No idempotency key. |

ApiClient is called by authentication repository; do not move feature requests to it and accidentally add Accept, retries or alter empty-token headers. BaseRepository adds UI/error/session handling. A future facade must preserve each operation profile until explicitly approved.

## Call-site matrix

| ID | Source / symbol | Method / endpoint expression | Query | Caller success codes |
|---|---|---|---|
| API-01 | [lib/controller/voltage/financial.dart:24](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:24) `financialAnalysis` | GET `${ApiConfig.baseUrl}/financial-analysis` | No query map added at this call; path interpolation retained. | 200 |
| API-02 | [lib/controller/voltage/voltage.dart:42](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:42) `allVoltage` | GET `${ApiConfig.baseUrl}/voltage-costs` | No query map added at this call; path interpolation retained. | 200 |
| API-03 | [lib/controller/voltage/voltage.dart:78](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:78) `editVoltage` | POST `${ApiConfig.baseUrl}/edit-v-cost/$voltid` | No query map added at this call; path interpolation retained. | 200 |
| API-04 | [lib/features/Counter/controller/add_counter_controller.dart:48](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:48) `addCounter` | POST `${ApiConfig.baseUrl}/new-gauge` | No query map added at this call; path interpolation retained. | 200 |
| API-05 | [lib/features/Counter/controller/add_counter_controller.dart:72](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:72) `allVoltige` | GET `${ApiConfig.baseUrl}/new-gauge` | No query map added at this call; path interpolation retained. | 200 |
| API-06 | [lib/features/Counter/controller/counter.dart:152](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:152) `fetchAllCounters` | GET `${ApiConfig.baseUrl}/gauges` | No query map added at this call; path interpolation retained. | 200 |
| API-07 | [lib/features/Counter/controller/counter.dart:195](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:195) `addCounter` | POST `${ApiConfig.baseUrl}/new-station` | No query map added at this call; path interpolation retained. | 200 |
| API-08 | [lib/features/Counter/controller/edit_counter_controller.dart:50](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:50) `editCounter` | POST `${ApiConfig.baseUrl}/edit-gauge` | No query map added at this call; path interpolation retained. | 200 |
| API-09 | [lib/features/Counter/controller/edit_counter_controller.dart:78](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:78) `allVoltige` | GET `${ApiConfig.baseUrl}/new-gauge` | No query map added at this call; path interpolation retained. | 200 |
| API-10 | [lib/features/analysis/controller/analysis.dart:15](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:15) `getAnalysis` | GET `${ApiConfig.baseUrl}/analysis-single/$station/$tech` | No query map added at this call; path interpolation retained. | 200 |
| API-11 | [lib/features/auth/controller/all_user.dart:36](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:36) `loadUsers` | GET `${ApiConfig.baseUrl}/all-users` | No query map added at this call; path interpolation retained. | 200 |
| API-12 | [lib/features/auth/controller/all_user.dart:128](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:128) `editUser` | POST `${ApiConfig.baseUrl}/edit-user/${editedUser.empCode}` | No query map added at this call; path interpolation retained. | 200 |
| API-13 | [lib/features/auth/controller/new_user.dart:49](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:49) `new_user` | POST `${ApiConfig.baseUrl}/register` | No query map added at this call; path interpolation retained. | 200 |
| API-14 | [lib/features/auth/data/repositories/auth_repository_impl.dart:19](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:19) `login` | POST `${ApiConfig.baseUrl}/login` | No query map added at this call; path interpolation retained. | no explicit caller equality check; transport 2xx then parse |
| API-15 | [lib/features/auth/data/repositories/auth_repository_impl.dart:44](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:44) `changePassword` | POST `${ApiConfig.baseUrl}/change-password` | No query map added at this call; path interpolation retained. | 200 |
| API-16 | [lib/features/bill/controller/all_bills.dart:153](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:153) `allbills` | GET `${ApiConfig.baseUrl}/view-bills` | page/per_page; optional search, bill_year, bill_month, is_paid, account_number | 200 |
| API-17 | [lib/features/bill/controller/bills.dart:262](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:262) `newbill` | GET `${ApiConfig.baseUrl}/new-bill/$accountNumber` | No query map added at this call; path interpolation retained. | 200 |
| API-18 | [lib/features/bill/controller/bills.dart:303](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:303) `addnewbill` | POST `${ApiConfig.baseUrl}/new-bill/$number` | No query map added at this call; path interpolation retained. | 200 |
| API-19 | [lib/features/bill/controller/tech_bills.dart:84](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:84) `allbills` | GET `${ApiConfig.baseUrl}/view-tech-bills` | page/per_page; optional bill_year, bill_month, search | 200 |
| API-20 | [lib/features/chemcails/controller/add_chemacial.dart:56](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:56) `addchemicals` | POST `${ApiConfig.baseUrl}/new-chemical` | No query map added at this call; path interpolation retained. | 200 |
| API-21 | [lib/features/chemcails/controller/add_chemacial.dart:90](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:90) `editchemicals` | POST `${ApiConfig.baseUrl}/edit-chemical/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-22 | [lib/features/chemcails/controller/add_chemacial.dart:118](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:118) `getchemicals` | GET `${ApiConfig.baseUrl}/new-chemical` | No query map added at this call; path interpolation retained. | 200 |
| API-23 | [lib/features/chemcails/controller/chemacial.dart:78](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:78) `getchemicals` | GET `${ApiConfig.baseUrl}/chemicals` | No query map added at this call; path interpolation retained. | 200 |
| API-24 | [lib/features/home/controller/home.dart:38](/Users/alimegahed/power_saving/lib/features/home/controller/home.dart:38) `home` | GET `ApiConfig.baseUrl (root)` | No query map added at this call; path interpolation retained. | 200 |
| API-25 | [lib/features/planning/controller/blance_chart/blance_chart.dart:107](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:107) `allareas` | GET `${ApiConfig.baseUrl}/all-areas` | No query map added at this call; path interpolation retained. | 200 |
| API-26 | [lib/features/planning/controller/blance_chart/blance_chart.dart:140](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:140) `allvalues` | GET `${ApiConfig.baseUrl}/place-types` | No query map added at this call; path interpolation retained. | 200 |
| API-27 | [lib/features/planning/controller/blance_chart/blance_chart.dart:201](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:201) `submitData` | POST `${ApiConfig.baseUrl}/balance-plot-calc/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-28 | [lib/features/planning/controller/place/add_places_controller.dart:48](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:48) `addplace` | POST `${ApiConfig.baseUrl}/new-place` | No query map added at this call; path interpolation retained. | 200 |
| API-29 | [lib/features/planning/controller/place/add_places_controller.dart:73](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:73) `allNewData` | GET `${ApiConfig.baseUrl}/new-place` | No query map added at this call; path interpolation retained. | 200 |
| API-30 | [lib/features/planning/controller/place/edit_place_type_controller.dart:44](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:44) `fetchPlaceTypes` | GET `${ApiConfig.baseUrl}/place-types` | No query map added at this call; path interpolation retained. | 200 |
| API-31 | [lib/features/planning/controller/place/edit_place_type_controller.dart:75](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:75) `updatePlaceType` | POST `${ApiConfig.baseUrl}/edit-place-type/$placeTypeId` | No query map added at this call; path interpolation retained. | 200 |
| API-32 | [lib/features/planning/controller/place/edit_places_controller.dart:48](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:48) `editplace` | POST `${ApiConfig.baseUrl}/edit-place/${place.placeId}` | No query map added at this call; path interpolation retained. | 200 |
| API-33 | [lib/features/planning/controller/place/edit_places_controller.dart:73](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:73) `allNewData` | GET `${ApiConfig.baseUrl}/new-place` | No query map added at this call; path interpolation retained. | 200 |
| API-34 | [lib/features/planning/controller/place/places_controller.dart:81](/Users/alimegahed/power_saving/lib/features/planning/controller/place/places_controller.dart:81) `allPlaces` | GET `${ApiConfig.baseUrl}/places` | No query map added at this call; path interpolation retained. | 200 |
| API-35 | [lib/features/predaction/controller/prediaction.dart:17](/Users/alimegahed/power_saving/lib/features/predaction/controller/prediaction.dart:17) `prediactions` | POST `${ApiConfig.baseUrl}/prediction/$stationId` | No query map added at this call; path interpolation retained. | no explicit caller equality check; transport 2xx then parse |
| API-36 | [lib/features/relations/controller/add_relations_controller.dart:40](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:40) `new_relations` | GET `${ApiConfig.baseUrl}/new-relation` | No query map added at this call; path interpolation retained. | 200 |
| API-37 | [lib/features/relations/controller/add_relations_controller.dart:79](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:79) `addRelations` | POST `${ApiConfig.baseUrl}/new-relation` | No query map added at this call; path interpolation retained. | 200 |
| API-38 | [lib/features/relations/controller/relations/relation.dart:80](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:80) `getRelations` | GET `${ApiConfig.baseUrl}/stg-relations` | No query map added at this call; path interpolation retained. | 200 |
| API-39 | [lib/features/relations/controller/relations/relation.dart:123](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:123) `editRelation` | GET `${ApiConfig.baseUrl}/edit-relation/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-40 | [lib/features/reports/controller/reports_controller.dart:201](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:201) `getReports` | POST `${ApiConfig.baseUrl}/reports` | No query map added at this call; path interpolation retained. | 200 |
| API-41 | [lib/features/stations/controller/add_stations_controller.dart:55](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:55) `addStation` | POST `${ApiConfig.baseUrl}/new-station` | No query map added at this call; path interpolation retained. | 200 |
| API-42 | [lib/features/stations/controller/add_stations_controller.dart:88](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:88) `allareas` | GET `${ApiConfig.baseUrl}/all-areas` | No query map added at this call; path interpolation retained. | 200 |
| API-43 | [lib/features/stations/controller/add_stations_controller.dart:105](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:105) `allBranches` | GET `${ApiConfig.baseUrl}/new-station` | No query map added at this call; path interpolation retained. | 200 |
| API-44 | [lib/features/stations/controller/all_stations_controller.dart:78](/Users/alimegahed/power_saving/lib/features/stations/controller/all_stations_controller.dart:78) `getStations` | GET `${ApiConfig.baseUrl}/stations` | No query map added at this call; path interpolation retained. | 200 |
| API-45 | [lib/features/stations/controller/edit_stations_controller.dart:51](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:51) `allBranches` | GET `${ApiConfig.baseUrl}/new-station` | No query map added at this call; path interpolation retained. | 200 |
| API-46 | [lib/features/stations/controller/edit_stations_controller.dart:70](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:70) `allareas` | GET `${ApiConfig.baseUrl}/all-areas` | No query map added at this call; path interpolation retained. | 200 |
| API-47 | [lib/features/stations/controller/edit_stations_controller.dart:97](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:97) `edit_Stations` | POST `${ApiConfig.baseUrl}/edit-station/$Stations_id` | No query map added at this call; path interpolation retained. | 200 |
| API-48 | [lib/features/stations/controller/following_stations_controller.dart:67](/Users/alimegahed/power_saving/lib/features/stations/controller/following_stations_controller.dart:67) `stationsTechs` | GET `${ApiConfig.baseUrl}/station-techs` | No query map added at this call; path interpolation retained. | 200 |
| API-49 | [lib/features/tech_bills/controller/new_tech_bills.dart:121](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:121) `stationsTechs` | GET `${ApiConfig.baseUrl}/station-techs` | No query map added at this call; path interpolation retained. | 200 |
| API-50 | [lib/features/tech_bills/controller/new_tech_bills.dart:181](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:181) `addTechBills` | POST `${ApiConfig.baseUrl}/insert-or-edit-tech-bill` | No query map added at this call; path interpolation retained. | 200, 201 |
| API-51 | [lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:73](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:73) `editTechBills` | POST `${ApiConfig.baseUrl}/edit-old-tech-bills/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-52 | [lib/features/tech_bills/controller/tech_bills/techbills.dart:133](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:133) `fetchTechBills` | GET `${ApiConfig.baseUrl}/tech-bills` | No query map added at this call; path interpolation retained. | 200 |
| API-53 | [lib/features/tech_bills/controller/tech_bills/techbills.dart:165](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:165) `addTechBills` | POST `${ApiConfig.baseUrl}/edit-tech-bill/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-54 | [lib/features/tech_bills/controller/techbills.dart:223](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:223) `fetchTechBills` | GET `${ApiConfig.baseUrl}/tech-bills` | No query map added at this call; path interpolation retained. | 200 |
| API-55 | [lib/features/tech_bills/controller/techbills.dart:274](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:274) `addTechBills` | POST `${ApiConfig.baseUrl}/edit-tech-bill/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-56 | [lib/features/technology/controller/add_tech_controller.dart:53](/Users/alimegahed/power_saving/lib/features/technology/controller/add_tech_controller.dart:53) `addtech` | POST `${ApiConfig.baseUrl}/new-tech` | No query map added at this call; path interpolation retained. | 200 |
| API-57 | [lib/features/technology/controller/edit_tech_controller.dart:41](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:41) `edittech` | POST `${ApiConfig.baseUrl}/edit-tech/$id` | No query map added at this call; path interpolation retained. | 200 |
| API-58 | [lib/features/technology/controller/technlogy.dart:132](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:132) `alltechnology` | GET `${ApiConfig.baseUrl}/technologies` | No query map added at this call; path interpolation retained. | 200 |
| API-59 | [lib/features/technology/controller/technlogy.dart:184](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:184) `addtech` | POST `${ApiConfig.baseUrl}/new-tech` | No query map added at this call; path interpolation retained. | 200 |

## Exact call bodies, parsing and invalidation

Each section records the exact source invocation, response extraction lines and cache actions. If invocation passes `body`, `bill.toJson()`, `counter.toJson()`, `tech.toJson()`, `place.toJson()`, `relation.toJson()`, `reference.toJson()`, `volt.toJson()` or `editedUser.toJson()`, the full originating method and serializer appendix define the body; no keys or defaults may be normalized. Blank cache actions mean no explicit cache invalidation in that method, not proof that dependent data stays fresh.

### API-01 — financialAnalysis (GET)

Source: [lib/controller/voltage/financial.dart:24](/Users/alimegahed/power_saving/lib/controller/voltage/financial.dart:24). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/financial-analysis")
```

**Response parsing / mapping**
```dart
final jsonData = jsonDecode(res.body);
waterChartHtml = jsonData["water_chart"] as String?;
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void financialAnalysis() async {
    try {
      loading.value = true;

      final res = await fetchData("${ApiConfig.baseUrl}/financial-analysis");
      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        waterChartHtml = jsonData["water_chart"] as String?;

        // Register iframe view for web compilation dynamically
        if (waterChartHtml != null && kIsWeb) {
          registerIframe('sunburst-chart', waterChartHtml!);
        }

        loading.value = false;
        update();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      loading.value = false;
      debugPrint("Error fetching financial analysis: $e");
    }
  }
```

</details>

### API-02 — allVoltage (GET)

Source: [lib/controller/voltage/voltage.dart:42](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:42). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/voltage-costs",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
VoltagePlan vlotag = VoltagePlan.fromJson(i);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allVoltage() async {
    try {
      vlotages = [];
      final res = await fetchData(
        "${ApiConfig.baseUrl}/voltage-costs",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        for (var i in responseData) {
          VoltagePlan vlotag = VoltagePlan.fromJson(i);
          vlotages.add(vlotag);
          update();
        }
        for (var i in vlotages) {
          if (i.voltageId == 2) {
            avaargefixed = TextEditingController(text: i.fixedFee.toString());
            avaragecost = TextEditingController(text: i.voltageCost.toString());
          } else {
            lowfixed = TextEditingController(text: i.fixedFee.toString());
            lowcost = TextEditingController(text: i.voltageCost.toString());
          }
        }

        // Debug prints
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      print("Error fetching branches: $e");
    }
  }
```

</details>

### API-03 — editVoltage (POST)

Source: [lib/controller/voltage/voltage.dart:78](/Users/alimegahed/power_saving/lib/controller/voltage/voltage.dart:78). Headers: legacy profile.

**Request invocation**
```dart
postData(
       "${ApiConfig.baseUrl}/edit-v-cost/$voltid",
         (volt.toJson()),
      )
```

**Response parsing / mapping**
```dart
// No explicit parsed response consumed in this method.
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> editVoltage({
    required VoltagePlan volt,
    required int voltid,
  }) async {
    try {
      final res = await postData(
       "${ApiConfig.baseUrl}/edit-v-cost/$voltid",
         (volt.toJson()),
      );

      if (res.statusCode == 200) {
        showSuccessToast("تم الحفظ بنجاح");
        // Debug prints
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      print("Error fetching branches: $e");
    }
  }
```

</details>

### API-04 — addCounter (POST)

Source: [lib/features/Counter/controller/add_counter_controller.dart:48](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:48). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-gauge",
        (counter.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
CounterController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addCounter({required ElectricMeter counter}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة العداد بنجاح");
        // Refresh the main counter list
        CounterController.sessionCache = null;
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? res.body;
        showCustomErrorDialog(errorMessage: errorMessage.toString());
      }
    } catch (e) {
      looading.value = false;
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-05 — allVoltige (GET)

Source: [lib/features/Counter/controller/add_counter_controller.dart:72](/Users/alimegahed/power_saving/lib/features/Counter/controller/add_counter_controller.dart:72). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
       "${ApiConfig.baseUrl}/new-gauge",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
VoltageType voltage = VoltageType.fromJson(i);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allVoltige() async {
    try {
      final res = await fetchData(
       "${ApiConfig.baseUrl}/new-gauge",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        for (var i in jsonData) {
          VoltageType voltage = VoltageType.fromJson(i);
          allVoltage.add(voltage);
          update();
        }
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      
    }
  }
```

</details>

### API-06 — fetchAllCounters (GET)

Source: [lib/features/Counter/controller/counter.dart:152](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:152). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/gauges")
```

**Response parsing / mapping**
```dart
_allCounters.addAll(sessionCache!.map((json) => ElectricMeter.fromJson(json)));
final List<dynamic> jsonData = jsonDecode(response.body);
final List<ElectricMeter> parsed = jsonData.map((json) => ElectricMeter.fromJson(json)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// Fetch all counters from API
  Future<void> fetchAllCounters({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        _allCounters.clear();
        _allCounters.addAll(sessionCache!.map((json) => ElectricMeter.fromJson(json)));
        allcounter.value = List.from(_allCounters);
        conters = _allCounters;
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        looading.value = true;
      }
    }

    try {
      if (!isBackground) {
        _allCounters.clear();
        allcounter.clear();
      }

      final response = await fetchData("${ApiConfig.baseUrl}/gauges");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        sessionCache = jsonData;

        final List<ElectricMeter> parsed = jsonData.map((json) => ElectricMeter.fromJson(json)).toList();

        _allCounters.clear();
        _allCounters.addAll(parsed);
        
        allcounter.value = List.from(_allCounters);
        conters = _allCounters; // Update global variable
        
        // Apply search filter again to keep current UI state consistent
        _performSearch(_searchQuery.value);
      } else if (!isBackground) {
        Get.snackbar(
          'خطأ',
          'فشل تحميل العدادات: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        debugPrint("Error fetching counters: $e");
      }
    } finally {
      if (!isBackground) {
        looading.value = false;
      }
    }
  }
```

</details>

### API-07 — addCounter (POST)

Source: [lib/features/Counter/controller/counter.dart:195](/Users/alimegahed/power_saving/lib/features/Counter/controller/counter.dart:195). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-station",
        counter.toJson(),
      )
```

**Response parsing / mapping**
```dart
final error = jsonDecode(response.body)['error'] ?? 'خطأ غير متوقع';
```

**Cache / refresh actions**
```dart
await fetchAllCounters();
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// Add new counter
  Future<void> addCounter(ElectricMeter counter) async {
    try {
      final response = await postData(
        "${ApiConfig.baseUrl}/new-station",
        counter.toJson(),
      );

      if (response.statusCode == 200) {
        showSuccessToast("تم إضافة العداد بنجاح");
        await fetchAllCounters();
        Get.back();
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: error);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint("Error adding counter: $e");
    }
  }
```

</details>

### API-08 — editCounter (POST)

Source: [lib/features/Counter/controller/edit_counter_controller.dart:50](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:50). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-gauge",
        (counter.toJson()),
      )
```

**Response parsing / mapping**
```dart
// No explicit parsed response consumed in this method.
```

**Cache / refresh actions**
```dart
CounterController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> editCounter({
    required ElectricMeter counter,
    required String serial,
  }) async {
    try {
      looadig.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-gauge",
        (counter.toJson()),
      );

      if (res.statusCode == 200) {
        looadig.value = false;
        showSuccessToast("تم تعديل العداد بنجاح");
        // Refresh the main counter list
        CounterController.sessionCache = null;
      } else {
        looadig.value = false;
        Get.snackbar(
          "خطأ",
          "فشل في تعديل المحطة: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looadig.value = false;
      
    }
  }
```

</details>

### API-09 — allVoltige (GET)

Source: [lib/features/Counter/controller/edit_counter_controller.dart:78](/Users/alimegahed/power_saving/lib/features/Counter/controller/edit_counter_controller.dart:78). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-gauge",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
VoltageType voltage = VoltageType.fromJson(i);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allVoltige() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-gauge",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        for (var i in jsonData) {
          VoltageType voltage = VoltageType.fromJson(i);
          allVoltage.add(voltage);
          update();
        }
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في تحميل أنواع الجهد: ${res.body}",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-10 — getAnalysis (GET)

Source: [lib/features/analysis/controller/analysis.dart:15](/Users/alimegahed/power_saving/lib/features/analysis/controller/analysis.dart:15). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/analysis-single/$station/$tech"
    
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
anl=AnalysisModel.fromJson(jsonData);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> getAnalysis({required int station,required int tech}) async {
    try {
      anl=null;
      final res = await fetchData(
        "${ApiConfig.baseUrl}/analysis-single/$station/$tech"
    
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        anl=AnalysisModel.fromJson(jsonData);
        update(); // returns a String
      
      } 
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
  
    }
  }
```

</details>

### API-11 — loadUsers (GET)

Source: [lib/features/auth/controller/all_user.dart:36](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:36). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/all-users")
```

**Response parsing / mapping**
```dart
users.value = sessionCache!.map((user) => User.fromJson(user)).toList();
final jsonData = json.decode(res.body);
} else if (jsonData['users'] != null) {
data = jsonData['users'] as List;
users.value = data.map((user) => User.fromJson(user)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = data;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
/// Load all users from API
  Future<void> loadUsers({bool isBackground = false}) async {
    if (!isBackground && sessionCache != null) {
      users.value = sessionCache!.map((user) => User.fromJson(user)).toList();
      _fetchLatestBackground();
      return;
    }
    try {
      if (!isBackground) {
        isLoading.value = true;
        errorMessage.value = '';
      }
      
      final res = await fetchData("${ApiConfig.baseUrl}/all-users");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> data = [];
        
        if (jsonData is List) {
          data = jsonData;
        } else if (jsonData['users'] != null) {
          data = jsonData['users'] as List;
        } else {
          data = [jsonData];
        }
        
        sessionCache = data;
        users.value = data.map((user) => User.fromJson(user)).toList();
      } 
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
      }
    } finally {
      if (!isBackground) isLoading.value = false;
    }
  }
```

</details>

### API-12 — editUser (POST)

Source: [lib/features/auth/controller/all_user.dart:128](/Users/alimegahed/power_saving/lib/features/auth/controller/all_user.dart:128). Headers: legacy profile.

**Request invocation**
```dart
postData(
  "${ApiConfig.baseUrl}/edit-user/${editedUser.empCode}",
  
    editedUser.toJson()
   
  )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
sessionCache = null;
loadUsers(isBackground: true);
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
/// Edit user information
  Future<void> editUser(int index, User editedUser) async {
    if (index < 0 || index >= users.length) return;

      try {
    isLoading.value = true;

   final res = await postData(
  "${ApiConfig.baseUrl}/edit-user/${editedUser.empCode}",
  
    editedUser.toJson()
   
  );
      users.refresh();

      // Send update to API
      // final res = await fetchData(
      //   "http://$ip/update-user",
      //   method: 'PUT',
      //   body: json.encode({
      //     'empCode': editedUser.empCode,
      //     'empName': editedUser.empName,
      //     'username': editedUser.username,
      //     'groupId': editedUser.groupId,
      //     'isActive': editedUser.isActive,
      //   }),
      // );

      if (res.statusCode == 200) {
        isLoading.value=false;
        showSuccessToast('تم تحديث بيانات المستخدم بنجاح');
        sessionCache = null;
        loadUsers(isBackground: true);
      } else {
                isLoading.value=false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage.toString());   
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());   

      // Revert on error
    } finally {
      isLoading.value = false;
    }
  }
```

</details>

### API-13 — new_user (POST)

Source: [lib/features/auth/controller/new_user.dart:49](/Users/alimegahed/power_saving/lib/features/auth/controller/new_user.dart:49). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/register",

        {
          "username": username,
          "password": password,
          "emp_code":code,
          "emp_name":name,

        })
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// ignore: non_constant_identifier_names
  Future<void> new_user({required String name,required String password,
  required String username,required String code,} ) async {
    try {
      isLoading.value==true;

      final res = await postData(
        "${ApiConfig.baseUrl}/register",

        {
          "username": username,
          "password": password,
          "emp_code":code,
          "emp_name":name,

        });
      
      if (res.statusCode == 200) {
           isLoading.value==false;
showSuccessToast("تم تسجيل المستخدم بنجاح");
      }else{
 final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
        isLoading.value==false;

    }
  }
```

</details>

### API-14 — login (POST)

Source: [lib/features/auth/data/repositories/auth_repository_impl.dart:19](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:19). Headers: ApiClient profile.

**Request invocation**
```dart
_apiClient.post(
        "${ApiConfig.baseUrl}/login",
        {
          "username": username,
          "password": password,
        },
      )
```

**Response parsing / mapping**
```dart
final jsonResponse = jsonDecode(response.body);
final userMap = jsonResponse['current_user'];
final token = jsonResponse['token'];
return User.fromJson(userMap);
```

**Cache / refresh actions**
```dart
await Cache.saveData(key: "user", value: jsonEncode(userMap));
await Cache.saveData(key: "token", value: token);
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<Result<User>> login(String username, String password) async {
    return safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/login",
        {
          "username": username,
          "password": password,
        },
      );

      final jsonResponse = jsonDecode(response.body);

      // Extract user info and token
      final userMap = jsonResponse['current_user'];
      final token = jsonResponse['token'];

      // Save to cache
      await Cache.saveData(key: "user", value: jsonEncode(userMap));
      await Cache.saveData(key: "token", value: token);

      return User.fromJson(userMap);
    });
  }
```

</details>

### API-15 — changePassword (POST)

Source: [lib/features/auth/data/repositories/auth_repository_impl.dart:44](/Users/alimegahed/power_saving/lib/features/auth/data/repositories/auth_repository_impl.dart:44). Headers: ApiClient profile.

**Request invocation**
```dart
_apiClient.post(
        "${ApiConfig.baseUrl}/change-password",
        {
          "old_password": currentPassword,
          "new_password": newPassword,
        },
      )
```

**Response parsing / mapping**
```dart
// No explicit parsed response consumed in this method.
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<Result<bool>> changePassword(String currentPassword, String newPassword) async {
    return safeRemoteCall(() async {
      final response = await _apiClient.post(
        "${ApiConfig.baseUrl}/change-password",
        {
          "old_password": currentPassword,
          "new_password": newPassword,
        },
      );

      return response.statusCode == 200;
    });
  }
```

</details>

### API-16 — allbills (GET)

Source: [lib/features/bill/controller/all_bills.dart:153](/Users/alimegahed/power_saving/lib/features/bill/controller/all_bills.dart:153). Headers: legacy profile.

**Request invocation**
```dart
fetchData(uri.toString())
```

**Response parsing / mapping**
```dart
List<dynamic> responseData = jsonData['data'];
_allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
final meta = jsonData['meta'];
currentPage.value = meta['page'] ?? 1;
perPage.value = meta['per_page'] ?? 20;
totalItems.value = meta['total'] ?? 0;
totalPages.value = meta['total_pages'] ?? 1;
hasNext.value = meta['has_next'] ?? false;
hasPrev.value = meta['has_prev'] ?? false;
final jsonData = json.decode(res.body);
List<dynamic> responseData = jsonData['data'];
_allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
final meta = jsonData['meta'];
currentPage.value = meta['page'] ?? 1;
perPage.value = meta['per_page'] ?? 20;
totalItems.value = meta['total'] ?? 0;
totalPages.value = meta['total_pages'] ?? 1;
hasNext.value = meta['has_next'] ?? false;
hasPrev.value = meta['has_prev'] ?? false;
_allBills.addAll(jsonData.map((bill) => GuageBill.fromJson(bill)).toList());
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allbills({bool isBackground = false}) async {
    final bool isDefaultState = currentPage.value == 1 &&
        _searchQuery.value.trim().isEmpty &&
        selectedYear == 'all' &&
        selectedMonth == 'all' &&
        selectedFilter == 'all' &&
        (selectedAccountNumber == 'all' || selectedAccountNumber.isEmpty);

    if (!isBackground && isDefaultState && sessionCache != null) {
      // Restore from cache instantly
      final jsonData = sessionCache!;
      _allBills.clear();
      bills.clear();

      if (jsonData.containsKey('data')) {
        List<dynamic> responseData = jsonData['data'];
        _allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
        
        if (jsonData.containsKey('meta')) {
          final meta = jsonData['meta'];
          currentPage.value = meta['page'] ?? 1;
          perPage.value = meta['per_page'] ?? 20;
          totalItems.value = meta['total'] ?? 0;
          totalPages.value = meta['total_pages'] ?? 1;
          hasNext.value = meta['has_next'] ?? false;
          hasPrev.value = meta['has_prev'] ?? false;
        }
      }

      bills.value = List.from(_allBills);
      searchError.value = '';

      // Trigger silent background refresh
      _fetchLatestBackground();
      return;
    }

    try {
      if (!isBackground) {
        isLoading.value = true;
      }
      errorMessage.value = '';

      Map<String, String> queryParams = {
        'page': currentPage.value.toString(),
        'per_page': perPage.value.toString(),
      };

      if (_searchQuery.value.isNotEmpty) {
        queryParams['search'] = _searchQuery.value.trim();
      }

      if (selectedYear != 'all') {
        queryParams['bill_year'] = selectedYear;
      }
      
      if (selectedMonth != 'all') {
        queryParams['bill_month'] = selectedMonth;
      }
      
      if (selectedFilter != 'all') {
        queryParams['is_paid'] = selectedFilter == 'paid' ? 'true' : 'false';
      }

      if (selectedAccountNumber != 'all' && selectedAccountNumber.isNotEmpty) {
        queryParams['account_number'] = selectedAccountNumber;
      }

      Uri uri = Uri.parse("${ApiConfig.baseUrl}/view-bills").replace(queryParameters: queryParams);
      final res = await fetchData(uri.toString());

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        if (isDefaultState) {
          sessionCache = jsonData;
        }

        _allBills.clear();
        bills.clear();

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          List<dynamic> responseData = jsonData['data'];
          _allBills.addAll(responseData.map((bill) => GuageBill.fromJson(bill)).toList());
          
          if (jsonData.containsKey('meta')) {
            final meta = jsonData['meta'];
            currentPage.value = meta['page'] ?? 1;
            perPage.value = meta['per_page'] ?? 20;
            totalItems.value = meta['total'] ?? 0;
            totalPages.value = meta['total_pages'] ?? 1;
            hasNext.value = meta['has_next'] ?? false;
            hasPrev.value = meta['has_prev'] ?? false;
          }
        } else if (jsonData is List) {
          _allBills.addAll(jsonData.map((bill) => GuageBill.fromJson(bill)).toList());
          totalItems.value = _allBills.length;
          totalPages.value = 1;
          hasNext.value = false;
          hasPrev.value = false;
        }

        bills.value = List.from(_allBills);
        
        if (bills.isEmpty && _searchQuery.value.isNotEmpty) {
           searchError.value = 'لا توجد نتائج تطابق "${_searchQuery.value}"';
        } else {
           searchError.value = '';
        }
      } else if (!isBackground) {
        errorMessage.value = 'فشل تحميل الفواتير: ${res.statusCode}';
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
      }
    } finally {
      if (!isBackground) {
        isLoading.value = false;
      }
    }
  }
```

</details>

### API-17 — newbill (GET)

Source: [lib/features/bill/controller/bills.dart:262](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:262). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/new-bill/$accountNumber")
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
(jsonData['gauge_sgt_list'] as List)
.map((item) => StationGaugeTechnologyRelation.fromJson(item))
showPercent = jsonData['show_percent'];
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> newbill(String number) async {
    try {
      gauges = [];
      final accountNumber = Uri.encodeComponent(number);

      final res = await fetchData("${ApiConfig.baseUrl}/new-bill/$accountNumber");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        // Parse gauge_sgt_list into List<StationGaugeTechnologyRelation>
        gauges =
            (jsonData['gauge_sgt_list'] as List)
                .map((item) => StationGaugeTechnologyRelation.fromJson(item))
                .toList();

        // Extract show_percent
        showPercent = jsonData['show_percent'];

        if (showPercent == true) {
          // Clear existing controllers and create new ones
          powerControllers.clear();
          moneyControllers.clear();
          for (int i = 0; i < gauges.length; i++) {
            powerControllers.add(TextEditingController());
            moneyControllers.add(TextEditingController());
          }
        }
        // Call update() to notify GetBuilder widgets
        update();

       
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      
    }
  }
```

</details>

### API-18 — addnewbill (POST)

Source: [lib/features/bill/controller/bills.dart:303](/Users/alimegahed/power_saving/lib/features/bill/controller/bills.dart:303). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-bill/$number",
      (bill.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
AllBills.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addnewbill({
    required String number,
    required GuageBill bill,
  }) async {
    try {
      isLoading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-bill/$number",
      (bill.toJson()),
      );

      if (res.statusCode == 200) {
        AllBills.sessionCache = null;
        showSuccessToast("تم تسجيل الفاتورة بنجاح");
        isLoading.value = false;

        // Optional: clear or populate text fields here if needed
      } else {
        isLoading.value = false;

        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      print(e.toString());
      isLoading.value = false;

    }
  }
```

</details>

### API-19 — allbills (GET)

Source: [lib/features/bill/controller/tech_bills.dart:84](/Users/alimegahed/power_saving/lib/features/bill/controller/tech_bills.dart:84). Headers: legacy profile.

**Request invocation**
```dart
fetchData(uri.toString())
```

**Response parsing / mapping**
```dart
bills = (jsonData['data'] as List).map((bill) => TechnologyBill.fromJson(bill)).toList();
final meta = jsonData['meta'];
currentPage = meta['page'] ?? 1;
totalPages = meta['total_pages'] ?? 1;
totalItems = meta['total'] ?? bills.length;
hasNext = meta['has_next'] ?? false;
hasPrev = meta['has_prev'] ?? false;
final jsonData = json.decode(res.body);
bills = (jsonData['data'] as List).map((bill) => TechnologyBill.fromJson(bill)).toList();
final meta = jsonData['meta'];
currentPage = meta['page'] ?? 1;
totalPages = meta['total_pages'] ?? 1;
totalItems = meta['total'] ?? bills.length;
hasNext = meta['has_next'] ?? false;
hasPrev = meta['has_prev'] ?? false;
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allbills({bool isBackground = false}) async {
    final bool isDefaultState = currentPage == 1 &&
        searchQuery.value.trim().isEmpty &&
        selectedYear == 'all' &&
        selectedMonth == 'all';

    if (!isBackground && isDefaultState && sessionCache != null) {
      final jsonData = sessionCache!;
      bills = [];
      if (jsonData is Map && jsonData.containsKey('data')) {
        bills = (jsonData['data'] as List).map((bill) => TechnologyBill.fromJson(bill)).toList();
        if (jsonData.containsKey('meta')) {
          final meta = jsonData['meta'];
          currentPage = meta['page'] ?? 1;
          totalPages = meta['total_pages'] ?? 1;
          totalItems = meta['total'] ?? bills.length;
          hasNext = meta['has_next'] ?? false;
          hasPrev = meta['has_prev'] ?? false;
        }
      }
      update();
      _fetchLatestBackground();
      return;
    }

    try {
      if (!isBackground) {
        isLoading.value = true;
      }
      errorMessage.value = '';
      if (!isBackground) {
        bills = [];
      }

      Map<String, String> queryParams = {
        'page': currentPage.toString(),
        'per_page': perPage.toString(),
      };

      if (selectedYear != 'all') queryParams['bill_year'] = selectedYear;
      if (selectedMonth != 'all') queryParams['bill_month'] = selectedMonth;
      if (searchQuery.value.isNotEmpty) queryParams['search'] = searchQuery.value;

      final uri = Uri.parse("${ApiConfig.baseUrl}/view-tech-bills").replace(queryParameters: queryParams);
      final res = await fetchData(uri.toString());

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        if (isDefaultState) {
          sessionCache = jsonData;
        }
        
        if (jsonData is Map && jsonData.containsKey('data')) {
          bills = (jsonData['data'] as List).map((bill) => TechnologyBill.fromJson(bill)).toList();
          
          if (jsonData.containsKey('meta')) {
            final meta = jsonData['meta'];
            currentPage = meta['page'] ?? 1;
            totalPages = meta['total_pages'] ?? 1;
            totalItems = meta['total'] ?? bills.length;
            hasNext = meta['has_next'] ?? false;
            hasPrev = meta['has_prev'] ?? false;
          }
        }
        update();
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
      }
    } finally {
      if (!isBackground) {
        isLoading.value = false;
      }
    }
  }
```

</details>

### API-20 — addchemicals (POST)

Source: [lib/features/chemcails/controller/add_chemacial.dart:56](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:56). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-chemical",
        (reference.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
Chemacialcontroller.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addchemicals({required AlumChlorineReference reference}) async {
    try {
      loading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-chemical",
        (reference.toJson()),
      );

      if (res.statusCode == 200) {
        loading.value = false;
        Chemacialcontroller.sessionCache = null;
        showSuccessToast("تم الاضافة  بنجاح");
        Get.offNamed('/Chemicals');

      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
        loading.value = false;
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      loading.value = false;
     
    }
  }
```

</details>

### API-21 — editchemicals (POST)

Source: [lib/features/chemcails/controller/add_chemacial.dart:90](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:90). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-chemical/$id",
         (reference.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
Chemacialcontroller.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> editchemicals({
    required AlumChlorineReference reference,
    required int id,
  }) async {
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-chemical/$id",
         (reference.toJson()),
      );

      if (res.statusCode == 200) {
        Chemacialcontroller.sessionCache = null;
        showSuccessToast("تم التعديل  بنجاح");
        Get.offNamed('/Chemicals');
      } else {
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    
     
    }
  }
```

</details>

### API-22 — getchemicals (GET)

Source: [lib/features/chemcails/controller/add_chemacial.dart:118](/Users/alimegahed/power_saving/lib/features/chemcails/controller/add_chemacial.dart:118). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
       "${ApiConfig.baseUrl}/new-chemical"
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
jsonData["water_sources"].forEach((source) {
waterSourceList.add(WaterSource.fromJson(source));
jsonData["techs"].forEach((tech) {
this.tech.add(TechnologyModel.fromJson(tech));
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void getchemicals() async {
    try {
      final res = await fetchData(
       "${ApiConfig.baseUrl}/new-chemical"
      );
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        jsonData["water_sources"].forEach((source) {
          waterSourceList.add(WaterSource.fromJson(source));
        });
        jsonData["techs"].forEach((tech) {
          this.tech.add(TechnologyModel.fromJson(tech));
        });
     
     

        update(); // Notify listeners
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-23 — getchemicals (GET)

Source: [lib/features/chemcails/controller/chemacial.dart:78](/Users/alimegahed/power_saving/lib/features/chemcails/controller/chemacial.dart:78). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/chemicals")
```

**Response parsing / mapping**
```dart
allChemicals.addAll(sessionCache!.map((e) => AlumChlorineReference.fromJson(e)));
final List<dynamic> responseData = json.decode(res.body);
final List<AlumChlorineReference> parsed = responseData.map((e) => AlumChlorineReference.fromJson(e)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = responseData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// -------------------------------
  // API Call - Get Chemicals
  // -------------------------------
  void getchemicals({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        allChemicals.clear();
        allChemicals.addAll(sessionCache!.map((e) => AlumChlorineReference.fromJson(e)));
        chemicals.value = List.from(allChemicals);
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        loading.value = true;
      }
    }

    try {
      if (!isBackground) {
        allChemicals.clear();
        chemicals.clear();
      }

      final res = await fetchData("${ApiConfig.baseUrl}/chemicals");
      
      if (res.statusCode == 200) {
        final List<dynamic> responseData = json.decode(res.body);
        
        sessionCache = responseData;
        
        final List<AlumChlorineReference> parsed = responseData.map((e) => AlumChlorineReference.fromJson(e)).toList();
        
        allChemicals.clear();
        allChemicals.addAll(parsed);
        
        // Re-apply current search filter instead of unconditionally clearing search
        _performSearch(_searchQuery.value);
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }
```

</details>

### API-24 — home (GET)

Source: [lib/features/home/controller/home.dart:38](/Users/alimegahed/power_saving/lib/features/home/controller/home.dart:38). Headers: legacy profile.

**Request invocation**
```dart
fetchData(ApiConfig.baseUrl)
```

**Response parsing / mapping**
```dart
final jsonData = jsonDecode(res.body);
consumptionModel = ConsumptionModel.fromJson(jsonData);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> home() async {
    try {
      loading.value = true;

      // ✅ Use new ApiConfig
      final res = await fetchData(ApiConfig.baseUrl);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);

        consumptionModel = ConsumptionModel.fromJson(jsonData);


        animateAll();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint("❌ Error fetching home: $e");
    } finally {
      loading.value = false;
      update();
    }
  }
```

</details>

### API-25 — allareas (GET)

Source: [lib/features/planning/controller/blance_chart/blance_chart.dart:107](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:107). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/all-areas")
```

**Response parsing / mapping**
```dart
areas.addAll(areasCache!.map((json) => AreaOfService.fromJson(json)));
final jsonData = jsonDecode(response.body) as List<dynamic>;
areas.addAll(jsonData.map((json) => AreaOfService.fromJson(json)));
```

**Cache / refresh actions**
```dart
areasCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allareas({bool isBackground = false}) async {
    if (!isBackground && areasCache != null) {
      areas.clear();
      areas.addAll(areasCache!.map((json) => AreaOfService.fromJson(json)));
      areas.value = List.from(areas);
      update();
      _fetchLatestBackgroundAreas();
      return;
    }
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/all-areas");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        areasCache = jsonData;
        areas.clear();
        areas.addAll(jsonData.map((json) => AreaOfService.fromJson(json)));
        areas.value = List.from(areas);
        update();
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }
```

</details>

### API-26 — allvalues (GET)

Source: [lib/features/planning/controller/blance_chart/blance_chart.dart:140](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:140). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/place-types")
```

**Response parsing / mapping**
```dart
final type = PlaceType.fromJson(json);
final List<dynamic> jsonData = jsonDecode(response.body);
final type = PlaceType.fromJson(json);
```

**Cache / refresh actions**
```dart
valuesCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allvalues({bool isBackground = false}) async {
    if (!isBackground && valuesCache != null) {
      allTypes.clear();
      textControllers.clear();
      for (var json in valuesCache!) {
        final type = PlaceType.fromJson(json);
        allTypes.add(type);
        textControllers[type.placeTypeId] = TextEditingController();
      }
      _fetchLatestBackgroundValues();
      return;
    }
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        valuesCache = jsonData;
        allTypes.clear();
        textControllers.clear();
        for (var json in jsonData) {
          final type = PlaceType.fromJson(json);
          allTypes.add(type);
          textControllers[type.placeTypeId] = TextEditingController();
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
    }
  }
```

</details>

### API-27 — submitData (POST)

Source: [lib/features/planning/controller/blance_chart/blance_chart.dart:201](/Users/alimegahed/power_saving/lib/features/planning/controller/blance_chart/blance_chart.dart:201). Headers: legacy profile.

**Request invocation**
```dart
postData(
      "${ApiConfig.baseUrl}/balance-plot-calc/$id",
      body,
    )
```

**Response parsing / mapping**
```dart
final responseJson = jsonDecode(response.body);
if (responseJson['best_model'] != null) {
final mlResponse = MLForecastResponse.fromJson(responseJson);
} else if (responseJson['table'] is List) {
balanceData.value = WaterDataResponse.fromJson(responseJson);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> submitData(int id) async {
  isloading.value = true;
  final body = buildRequestBody();

  try {
    final response = await postData(
      "${ApiConfig.baseUrl}/balance-plot-calc/$id",
      body,
    );

    if (response.statusCode == 200) {
      // Parse response
      final responseJson = jsonDecode(response.body);
      
      // If Machine Learning response
      if (responseJson['best_model'] != null) {
        final mlResponse = MLForecastResponse.fromJson(responseJson);
        isloading.value = false;
        Get.to(
          () => MLForecastResultScreen(result: mlResponse),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 100),
        );
      } else if (responseJson['table'] is List) {
        // Validate and store equation/ministry data
        balanceData.value = WaterDataResponse.fromJson(responseJson);
        
        isloading.value = false;
        
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.to(
            () => BalanceChartPrintScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 100),
          );
        });
      } else {
        isloading.value = false;
        showCustomErrorDialog(errorMessage: "تنسيق البيانات المستلمة غير متوقع");
      }
    } else {
      isloading.value = false;
    }
  } catch (e) {
    showCustomErrorDialog(errorMessage: e.toString());
    isloading.value = false;
    debugPrint("Error: $e");
  }
}
```

</details>

### API-28 — addplace (POST)

Source: [lib/features/planning/controller/place/add_places_controller.dart:48](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:48). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-place",
          (place.toJson()),
       
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
PlacesController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addplace({
required   Place  place,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/new-place",
          (place.toJson()),
       
      );

      if (res.statusCode == 200) {
        looading.value = false;
        PlacesController.sessionCache = null;
        showSuccessToast("تم اضافة المكان بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
    }
  }
```

</details>

### API-29 — allNewData (GET)

Source: [lib/features/planning/controller/place/add_places_controller.dart:73](/Users/alimegahed/power_saving/lib/features/planning/controller/place/add_places_controller.dart:73). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-place",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
branchList = (jsonData['branches'] as List)
.map((branch) => Branch.fromJson(branch))
areaList = (jsonData['areas'] as List)
.map((area) => AreaOfService.fromJson(area))
placeTypeList = (jsonData['place_types'] as List)
.map((placeType) => PlaceType.fromJson(placeType))
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allNewData() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-place",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        branchList = (jsonData['branches'] as List)
            .map((branch) => Branch.fromJson(branch))
            .toList();
             areaList = (jsonData['areas'] as List)
            .map((area) => AreaOfService.fromJson(area))
            .toList();
             placeTypeList = (jsonData['place_types'] as List)
            .map((placeType) => PlaceType.fromJson(placeType))
            .toList();
update();
      

      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-30 — fetchPlaceTypes (GET)

Source: [lib/features/planning/controller/place/edit_place_type_controller.dart:44](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:44). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/place-types")
```

**Response parsing / mapping**
```dart
placeTypes.add(PlaceType.fromJson(json));
final List<dynamic> jsonData = jsonDecode(response.body);
placeTypes.add(PlaceType.fromJson(json));
```

**Cache / refresh actions**
```dart
BalanceChartController.valuesCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> fetchPlaceTypes({bool forceRefresh = false}) async {
    if (!forceRefresh && BalanceChartController.valuesCache != null) {
      placeTypes.clear();
      for (var json in BalanceChartController.valuesCache!) {
        placeTypes.add(PlaceType.fromJson(json));
      }
      return;
    }

    isLoading.value = true;
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/place-types");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        BalanceChartController.valuesCache = jsonData;
        placeTypes.clear();
        for (var json in jsonData) {
          placeTypes.add(PlaceType.fromJson(json));
        }
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
```

</details>

### API-31 — updatePlaceType (POST)

Source: [lib/features/planning/controller/place/edit_place_type_controller.dart:75](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_place_type_controller.dart:75). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-place-type/$placeTypeId",
        body,
      )
```

**Response parsing / mapping**
```dart
final resBody = jsonDecode(response.body);
```

**Cache / refresh actions**
```dart
BalanceChartController.valuesCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<bool> updatePlaceType(int placeTypeId) async {
    isSubmitting.value = true;
    try {
      final body = {
        "place_type_name": nameController.text.trim(),
        "person_portion_from": int.tryParse(fromController.text.trim()) ?? 0,
        "person_portion_to": int.tryParse(toController.text.trim()) ?? 0,
      };

      final response = await postData(
        "${ApiConfig.baseUrl}/edit-place-type/$placeTypeId",
        body,
      );

      if (response.statusCode == 200) {
        // Clear caches so the balance chart and other screens reload the updated ranges from route
        BalanceChartController.valuesCache = null;

        // Refresh our local list
        await fetchPlaceTypes(forceRefresh: true);

        // If BalanceChartController is already registered in memory, refresh it
        if (Get.isRegistered<BalanceChartController>()) {
          Get.find<BalanceChartController>().allvalues(isBackground: false);
        }

        showSuccessToast("تم تعديل نوع المكان ونطاق الاستهلاك بنجاح");
        return true;
      } else {
        final resBody = jsonDecode(response.body);
        final msg = resBody["error"] ?? "فشل حفظ التعديلات";
        showCustomErrorDialog(errorMessage: msg);
        return false;
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
```

</details>

### API-32 — editplace (POST)

Source: [lib/features/planning/controller/place/edit_places_controller.dart:48](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:48). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-place/${place.placeId}",
          (place.toJson()),
       
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
PlacesController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> editplace({
required   Place  place,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-place/${place.placeId}",
          (place.toJson()),
       
      );

      if (res.statusCode == 200) {
        looading.value = false;
        PlacesController.sessionCache = null;
        showSuccessToast("تم تعديل المكان بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
    }
  }
```

</details>

### API-33 — allNewData (GET)

Source: [lib/features/planning/controller/place/edit_places_controller.dart:73](/Users/alimegahed/power_saving/lib/features/planning/controller/place/edit_places_controller.dart:73). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-place",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
branchList = (jsonData['branches'] as List)
.map((branch) => Branch.fromJson(branch))
areaList = (jsonData['areas'] as List)
.map((area) => AreaOfService.fromJson(area))
placeTypeList = (jsonData['place_types'] as List)
.map((placeType) => PlaceType.fromJson(placeType))
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allNewData() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-place",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        branchList = (jsonData['branches'] as List)
            .map((branch) => Branch.fromJson(branch))
            .toList();
             areaList = (jsonData['areas'] as List)
            .map((area) => AreaOfService.fromJson(area))
            .toList();
             placeTypeList = (jsonData['place_types'] as List)
            .map((placeType) => PlaceType.fromJson(placeType))
            .toList();
update();
      

      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-34 — allPlaces (GET)

Source: [lib/features/planning/controller/place/places_controller.dart:81](/Users/alimegahed/power_saving/lib/features/planning/controller/place/places_controller.dart:81). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/places")
```

**Response parsing / mapping**
```dart
_allPlaces.addAll(sessionCache!.map((json) => Place.fromJson(json)));
final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;
final List<Place> parsed = jsonData.map((json) => Place.fromJson(json)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// Fetch all places from API
  Future<void> allPlaces({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        _allPlaces.clear();
        _allPlaces.addAll(sessionCache!.map((json) => Place.fromJson(json)));
        places.value = List.from(_allPlaces);
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        loading.value = true;
      }
    }

    try {
      if (!isBackground) {
        _allPlaces.clear();
        places.clear();
      }

      final response = await fetchData("${ApiConfig.baseUrl}/places");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;
        
        sessionCache = jsonData;

        final List<Place> parsed = jsonData.map((json) => Place.fromJson(json)).toList();

        _allPlaces.clear();
        _allPlaces.addAll(parsed);
        
        // Apply search filter again to keep current UI state consistent
        _performSearch(_searchQuery.value);
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        debugPrint("Error fetching places: $e");
      }
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }
```

</details>

### API-35 — prediactions (POST)

Source: [lib/features/predaction/controller/prediaction.dart:17](/Users/alimegahed/power_saving/lib/features/predaction/controller/prediaction.dart:17). Headers: legacy profile.

**Request invocation**
```dart
postData("${ApiConfig.baseUrl}/prediction/$stationId", {})
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
predictionModel = PredictionModel.fromJson(jsonData);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> prediactions(int stationId) async {
    try {
      isLoading.value = true;
      update();

      final res = await postData("${ApiConfig.baseUrl}/prediction/$stationId", {});
      final jsonData = json.decode(res.body);
      predictionModel = PredictionModel.fromJson(jsonData);
      
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode != 401 && e.statusCode != 403) {
          showCustomErrorDialog(errorMessage: e.message);
        }
      } else {
        showCustomErrorDialog(errorMessage: "تعذر الاتصال بالخادم. الرجاء المحاولة لاحقاً.\nالخطأ: $e");
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
```

</details>

### API-36 — new_relations (GET)

Source: [lib/features/relations/controller/add_relations_controller.dart:40](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:40). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-relation",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
if (jsonData['gauges'] != null) {
for (var gauge in jsonData['gauges']) {
electricMeterList.add(ElectricMeter.fromJson(gauge));
if (jsonData['stations'] != null) {
for (var station in jsonData['stations']) {
stationlist.add(allstations.fromJson(station));
if (jsonData['techs'] != null) {
for (var tech in jsonData['techs']) {
technologylist.add(TechnologyModel.fromJson(tech));
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> new_relations() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-relation",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        if (jsonData['gauges'] != null) {
          for (var gauge in jsonData['gauges']) {
            electricMeterList.add(ElectricMeter.fromJson(gauge));
          }
        }

        // Parse stations into Branch list
        if (jsonData['stations'] != null) {
          for (var station in jsonData['stations']) {
            stationlist.add(allstations.fromJson(station));
          }
        }

        // Parse techs into TechnologyModel list
        if (jsonData['techs'] != null) {
          for (var tech in jsonData['techs']) {
            technologylist.add(TechnologyModel.fromJson(tech));
          }
        }

        update(); // Assuming you're using GetX or similar for state management

      } 
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-37 — addRelations (POST)

Source: [lib/features/relations/controller/add_relations_controller.dart:79](/Users/alimegahed/power_saving/lib/features/relations/controller/add_relations_controller.dart:79). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-relation",
        (relation.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
RelationsController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addRelations(StationGaugeTechnologyRelation relation) async {
    try {
            looading.value=true;

      final res = await postData(
        "${ApiConfig.baseUrl}/new-relation",
        (relation.toJson()),
      );

      if (res.statusCode == 200) {
              looading.value=false;

        RelationsController.sessionCache = null;
        showSuccessToast('تمت الاضافة بنجاح');
        // Parse with the existing model
        // Assign to local lists

        // Debug prints
      } else {
                      looading.value=false;

        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? res.body;

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage.toString());
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
                    looading.value=false;

      print("Error fetching branches: $e");
    }
  }
```

</details>

### API-38 — getRelations (GET)

Source: [lib/features/relations/controller/relations/relation.dart:80](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:80). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/stg-relations")
```

**Response parsing / mapping**
```dart
allRelations.addAll(sessionCache!.map((e) => StationGaugeTechnologyRelation.fromJson(e)));
final List<dynamic> jsonData = jsonDecode(response.body);
final List<StationGaugeTechnologyRelation> parsed = jsonData.map((e) => StationGaugeTechnologyRelation.fromJson(e)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// -------------------------------
  // API Call - Get Relations
  // -------------------------------
  Future<void> getRelations({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        allRelations.clear();
        allRelations.addAll(sessionCache!.map((e) => StationGaugeTechnologyRelation.fromJson(e)));
        relations.value = List.from(allRelations);
        
        // Background fetch
        _fetchLatestBackground();
        return;
      } else {
        loading.value = true;
      }
    }

    try {
      if (!isBackground) {
        allRelations.clear();
        relations.clear();
      }

      final response = await fetchData("${ApiConfig.baseUrl}/stg-relations");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        sessionCache = jsonData;

        final List<StationGaugeTechnologyRelation> parsed = jsonData.map((e) => StationGaugeTechnologyRelation.fromJson(e)).toList();

        allRelations.clear();
        allRelations.addAll(parsed);
        
        // Apply search filter again to keep current UI state consistent
        _performSearch(_searchQuery.value);
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        debugPrint('Relations error: $e');
      }
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }
```

</details>

### API-39 — editRelation (GET)

Source: [lib/features/relations/controller/relations/relation.dart:123](/Users/alimegahed/power_saving/lib/features/relations/controller/relations/relation.dart:123). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/edit-relation/$id")
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(response.body);
```

**Cache / refresh actions**
```dart
sessionCache = null;
await _fetchLatestBackground();
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// -------------------------------
  // API Call - Edit Relation
  // -------------------------------
  Future<void> editRelation(int id, String successMessage) async {
    try {
      isProcessing.value = true;

      final response = await fetchData("${ApiConfig.baseUrl}/edit-relation/$id");

      if (response.statusCode == 200) {
        // Cache invalidation and silent refresh
        sessionCache = null;
        await _fetchLatestBackground();
        
        showSuccessToast(successMessage);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint('Edit relation error: $e');
    } finally {
      isProcessing.value = false;
    }
  }
```

</details>

### API-40 — getReports (POST)

Source: [lib/features/reports/controller/reports_controller.dart:201](/Users/alimegahed/power_saving/lib/features/reports/controller/reports_controller.dart:201). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/reports",
        {
          "report_name": name,
          "from_date": start,
          "to_date": end,
        },
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
responseData = jsonData['data'] ?? [];
branchs.add(ReportBranch.fromJson(i));
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// ================== API CALL ====================
  Future<void> getReports({
    required String start,
    required String end,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      update();

      branchs.clear();
      filteredBranchs.clear();
      _index.clear();
      clearSearch(); // Clear any existing search

      final res = await postData(
        "${ApiConfig.baseUrl}/reports",
        {
          "report_name": name,
          "from_date": start,
          "to_date": end,
        },
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        List<dynamic> responseData;
        if (jsonData is List) {
          responseData = jsonData;
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          responseData = jsonData['data'] ?? [];
        } else {
          responseData = [];
        }

        for (var i in responseData) {
          try {
            branchs.add(ReportBranch.fromJson(i));
          } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
            debugPrint("Parsing error: $e");
          }
        }

        // Set filtered data
        filteredBranchs.value = List.from(branchs);

        // Build optimized search index
        _buildSearchIndex();

        sumvalueofreport(filteredBranchs);
      }

      isLoading.value = false;
      update();
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      isLoading.value = false;
      update();
      debugPrint("Error fetching reports: $e");
    }
  }
```

</details>

### API-41 — addStation (POST)

Source: [lib/features/stations/controller/add_stations_controller.dart:55](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:55). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-station",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId
        },
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
StationsController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addStation({
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    required int capacity,
     int? areaId,
  }) async {
    looading.value = true;
    try {
      final res = await postData(
        "${ApiConfig.baseUrl}/new-station",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        StationsController.sessionCache = null;
        showSuccessToast("تم اضافة المحطة بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-42 — allareas (GET)

Source: [lib/features/stations/controller/add_stations_controller.dart:88](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:88). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/all-areas")
```

**Response parsing / mapping**
```dart
final jsonData = jsonDecode(response.body) as List<dynamic>;
jsonData.map((json) => AreaOfService.fromJson(json))
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allareas() async {
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/all-areas");
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        areas.clear();
        areas.addAll(
          jsonData.map((json) => AreaOfService.fromJson(json))
        );
        update();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-43 — allBranches (GET)

Source: [lib/features/stations/controller/add_stations_controller.dart:105](/Users/alimegahed/power_saving/lib/features/stations/controller/add_stations_controller.dart:105). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-station",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
final parsedData = AddStationData.fromJson(jsonData);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allBranches() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-station",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final parsedData = AddStationData.fromJson(jsonData);
        branchList = parsedData.branches;
        waterSourceList = parsedData.waterSources;
        update();
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }
```

</details>

### API-44 — getStations (GET)

Source: [lib/features/stations/controller/all_stations_controller.dart:78](/Users/alimegahed/power_saving/lib/features/stations/controller/all_stations_controller.dart:78). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/stations")
```

**Response parsing / mapping**
```dart
final List<Station> parsedCache = sessionCache!.map((e) => Station.fromJson(e)).toList();
final List<dynamic> jsonData = jsonDecode(response.body);
..addAll(jsonData.map((e) => Station.fromJson(e)));
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// -------------------------------
  // API Call
  // -------------------------------
  Future<void> getStations({bool isBackground = false}) async {
    try {
      if (!isBackground) {
        if (sessionCache != null) {
          // 1. Display cached data instantly
          final List<Station> parsedCache = sessionCache!.map((e) => Station.fromJson(e)).toList();
          allStations.clear();
          allStations.addAll(parsedCache);
          stations.value = List.from(allStations);
          
          // 2. Fetch in background silently
          _fetchLatestBackground();
          return;
        } else {
          loading.value = true;
        }
      }

      final response = await fetchData("${ApiConfig.baseUrl}/stations");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        // Update Static Cache
        sessionCache = jsonData;

        allStations
          ..clear()
          ..addAll(jsonData.map((e) => Station.fromJson(e)));

        // If a search is active, we should re-apply it instead of just copying allStations.
        if (isSearching.value && searchController.text.isNotEmpty) {
           _performSearch(searchController.text);
        } else {
           stations.value = List.from(allStations);
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
      debugPrint('Stations error: $e');
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }
```

</details>

### API-45 — allBranches (GET)

Source: [lib/features/stations/controller/edit_stations_controller.dart:51](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:51). Headers: legacy profile.

**Request invocation**
```dart
fetchData(
        "${ApiConfig.baseUrl}/new-station",
      )
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
final parsedData = AddStationData.fromJson(jsonData);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allBranches() async {
    try {
      final res = await fetchData(
        "${ApiConfig.baseUrl}/new-station",
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final parsedData = AddStationData.fromJson(jsonData);
        branchList = parsedData.branches;
        waterSourceList = parsedData.waterSources;
        update();
      }
    // ignore: empty_catches
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-46 — allareas (GET)

Source: [lib/features/stations/controller/edit_stations_controller.dart:70](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:70). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/all-areas")
```

**Response parsing / mapping**
```dart
final jsonData = jsonDecode(response.body) as List<dynamic>;
jsonData.map((json) => AreaOfService.fromJson(json))
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> allareas() async {
    try {
      final response = await fetchData("${ApiConfig.baseUrl}/all-areas");
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        areas.clear();
        areas.addAll(
          jsonData.map((json) => AreaOfService.fromJson(json))
        );
        update();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-47 — edit_Stations (POST)

Source: [lib/features/stations/controller/edit_stations_controller.dart:97](/Users/alimegahed/power_saving/lib/features/stations/controller/edit_stations_controller.dart:97). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-station/$Stations_id",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId,
        },
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
StationsController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> edit_Stations({
    // ignore: non_constant_identifier_names
    required int Stations_id,
    required String name,
    required int branchId,
    required int sourceId,
    required String typeId,
    int? areaId,
    required int capacity,
  }) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-station/$Stations_id",
        {
          "name": name,
          "branch_id": branchId,
          "water_source_id": sourceId,
          "station_type": typeId,
          "station_water_capacity": capacity,
          "area_id": areaId,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        StationsController.sessionCache = null;
        showSuccessToast("تم تعديل المحطة بنجاح");
        Get.offAllNamed('/Stations');
      } else {
        final errorBody = jsonDecode(res.body);
        looading.value = false;
        final errorMessage = errorBody['error'] ?? 'حدث خطأ غير متوقع';
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      showCustomErrorDialog(errorMessage: e.toString());
    }
  }
```

</details>

### API-48 — stationsTechs (GET)

Source: [lib/features/stations/controller/following_stations_controller.dart:67](/Users/alimegahed/power_saving/lib/features/stations/controller/following_stations_controller.dart:67). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/station-techs")
```

**Response parsing / mapping**
```dart
stations.value = sessionCache!.map((e) => Station.fromJson(e)).toList();
final List data = json.decode(res.body);
stations.value = data.map((e) => Station.fromJson(e)).toList();
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = data;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> stationsTechs({bool isBackground = false}) async {
    if (!isBackground && sessionCache != null) {
      stations.value = sessionCache!.map((e) => Station.fromJson(e)).toList();
      update();
      _fetchLatestBackground();
      return;
    }
    final res = await fetchData("${ApiConfig.baseUrl}/station-techs");

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      sessionCache = data;
      stations.value = data.map((e) => Station.fromJson(e)).toList();
      update();
    }
  }
```

</details>

### API-49 — stationsTechs (GET)

Source: [lib/features/tech_bills/controller/new_tech_bills.dart:121](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:121). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/station-techs")
```

**Response parsing / mapping**
```dart
.map((e) => Station.fromJson(e))
final decoded = json.decode(res.body);
if (decoded.containsKey('stations') && decoded['stations'] is List) {
data = decoded['stations'] as List<dynamic>;
} else if (decoded.containsKey('data') && decoded['data'] is List) {
data = decoded['data'] as List<dynamic>;
.map((e) => Station.fromJson(e))
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = data;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> stationsTechs({bool isBackground = false}) async {
    if (!isBackground && sessionCache != null) {
      stations.value = sessionCache!
          .whereType<Map<String, dynamic>>()
          .map((e) => Station.fromJson(e))
          .toList();
      update();
      _fetchLatestBackground();
      return;
    }
    if (!isBackground) loading.value = true;
    try {
      final res = await fetchData("${ApiConfig.baseUrl}/station-techs");
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        List<dynamic> data = [];

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('stations') && decoded['stations'] is List) {
            data = decoded['stations'] as List<dynamic>;
          } else if (decoded.containsKey('data') && decoded['data'] is List) {
            data = decoded['data'] as List<dynamic>;
          }
        }
        
        sessionCache = data;

        stations.value =
            data
                .whereType<Map<String, dynamic>>()
                .map((e) => Station.fromJson(e))
                .toList();

        if (selectedBranch.value != null &&
            !getBranches().contains(selectedBranch.value)) {
          selectedBranch.value = null;
          selectedStation = null;
          selectedTech = null;
        }
      } else {
        if (!isBackground) showCustomErrorDialog(errorMessage: 'فشل في جلب بيانات المحطات. حاول مرة أخرى.');
      }
    } catch (e) {
      print('Error fetching station techs: $e');
      if (!isBackground) showCustomErrorDialog(errorMessage: e.toString());
    } finally {
      if (!isBackground) loading.value = false;
      update();
    }
  }
```

</details>

### API-50 — addTechBills (POST)

Source: [lib/features/tech_bills/controller/new_tech_bills.dart:181](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/new_tech_bills.dart:181). Headers: legacy profile.

**Request invocation**
```dart
postData("${ApiConfig.baseUrl}/insert-or-edit-tech-bill", {
            "technology_chlorine_consump": chlorine,
            "technology_liquid_alum_consump": liquid,
            "technology_solid_alum_consump": solid,
            "technology_water_amount": water,
            "measured_water": measuredWater,
            "calculated_water": calculatedWater,
            
            "station_id": staionid,
            "technology_id": techid,
            "bill_month": int.tryParse(monthController.text) ?? 0,
            "bill_year": int.tryParse(yearController.text) ?? 0,
          })
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
TechBillscontroller.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void addTechBills({
    required int staionid,
    required int techid,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index,
    required double measuredWater,
    required double calculatedWater,
  }) async {
    try {
      loading.value = true;

      final res =
          await postData("${ApiConfig.baseUrl}/insert-or-edit-tech-bill", {
            "technology_chlorine_consump": chlorine,
            "technology_liquid_alum_consump": liquid,
            "technology_solid_alum_consump": solid,
            "technology_water_amount": water,
            "measured_water": measuredWater,
            "calculated_water": calculatedWater,
            
            "station_id": staionid,
            "technology_id": techid,
            "bill_month": int.tryParse(monthController.text) ?? 0,
            "bill_year": int.tryParse(yearController.text) ?? 0,
          });

      if (res.statusCode == 200 || res.statusCode == 201) {
        loading.value = false;
        TechBillscontroller.sessionCache = null;
        showSuccessToast("تمت الإضافة بنجاح");

        // Clear input fields after successful submission
      } else {
        loading.value = false;
        try {
          final errorBody = jsonDecode(res.body);
          final errorMessage = errorBody['message'] ?? errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
          showCustomErrorDialog(errorMessage: errorMessage.toString());
        } catch (e) {
          showCustomErrorDialog(errorMessage: e.toString());
        }
      }
    } catch (e) {
      loading.value = false;
      print("Error during bill submission: $e");
      showCustomErrorDialog(errorMessage: "حدث خطأ: ${e.toString()}");
    }
  }
```

</details>

### API-51 — editTechBills (POST)

Source: [lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:73](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/edit_techbills.dart:73). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-old-tech-bills/$id",
        {
          "calculated_water": calculatedWater,
          "measured_water": measuredWater,
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
TechBillscontroller.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void editTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required double calculatedWater,
    required double measuredWater,
  }) async {
    try {
      looading.value = true;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-old-tech-bills/$id",
        {
          "calculated_water": calculatedWater,
          "measured_water": measuredWater,
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        TechBillscontroller.sessionCache = null;
        showSuccessToast("تم التعديل بنجاح");
      } else {
        looading.value = false;
        String errorMessage = 'حدث خطأ غير متوقع';
        try {
          final errorBody = jsonDecode(res.body);
          if (errorBody is Map) {
            errorMessage = errorBody['error'] ?? errorBody['message'] ?? 'حدث خطأ غير متوقع';
          }
        } catch (_) {
          // If the backend returns HTML or plain text (e.g., 500 Server Error)
          errorMessage = 'حدث خطأ في الخادم (${res.statusCode})';
        }
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      looading.value = false;
      showCustomErrorDialog(errorMessage: e.toString());
      print("Error during bill submission: $e");
    } 
  }
```

</details>

### API-52 — fetchTechBills (GET)

Source: [lib/features/tech_bills/controller/tech_bills/techbills.dart:133](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:133). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/tech-bills")
```

**Response parsing / mapping**
```dart
final jsonData = json.decode(res.body);
TechnologyBill technologyBill = TechnologyBill.fromJson(i);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// Example method to fetch tech bills data
  void fetchTechBills() async {
    try {
      looading.value = true;
      techBills.clear();
      final res = await fetchData("${ApiConfig.baseUrl}/tech-bills");

      if (res.statusCode == 200) {
        looading.value = false;
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;
        for (var i in responseData) {
          TechnologyBill technologyBill = TechnologyBill.fromJson(i);
          techBills.add(technologyBill);
        }
        applyFilters(); // Apply filters after fetching data
        update();
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
      print("Error fetching tech bills: $e");
    }
  }
```

</details>

### API-53 — addTechBills (POST)

Source: [lib/features/tech_bills/controller/tech_bills/techbills.dart:165](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/tech_bills/techbills.dart:165). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
fetchTechBills();
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required int index,
  }) async {
    try {
      looading.value = true;
      loadingIndex.value = index;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
        },
      );

      if (res.statusCode == 200) {
        looading.value = false;
        fetchTechBills();
        showSuccessToast("تمت الإضافة بنجاح");

        /// ✅ Clear input fields after successful submission
        getChlorineController(index).clear();
        getLiquidAlumController(index).clear();
        getSolidAlumController(index).clear();
        getWaterProducedController(index).clear();
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
      print("Error during bill submission: $e");
    } finally {
      loadingIndex.value = null;
    }
  }
```

</details>

### API-54 — fetchTechBills (GET)

Source: [lib/features/tech_bills/controller/techbills.dart:223](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:223). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/tech-bills")
```

**Response parsing / mapping**
```dart
techBills.add(TechnologyBill.fromJson(i));
final jsonData = json.decode(res.body);
techBills.add(TechnologyBill.fromJson(i));
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = jsonData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> fetchTechBills({bool isBackground = false}) async {
    if (!isBackground && sessionCache != null) {
      techBills.clear();
      for (var i in sessionCache!) {
        techBills.add(TechnologyBill.fromJson(i));
      }
      applyFilters();
      _fetchLatestBackground();
      return;
    }

    try {
      if (!isBackground) {
        loading.value = true;
      }
      
      final res = await fetchData("${ApiConfig.baseUrl}/tech-bills");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        sessionCache = jsonData;
        
        techBills.clear();
        for (var i in jsonData) {
          techBills.add(TechnologyBill.fromJson(i));
        }
        applyFilters();
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
      }
      print("Error fetching tech bills: $e");
    } finally {
      if (!isBackground) {
        loading.value = false;
      }
    }
  }
```

</details>

### API-55 — addTechBills (POST)

Source: [lib/features/tech_bills/controller/techbills.dart:274](/Users/alimegahed/power_saving/lib/features/tech_bills/controller/techbills.dart:274). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
          "measured_water": measuredWater,
          "calculated_water": calculatedWater,
        },
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
sessionCache = null;
fetchTechBills(isBackground: true);
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
void addTechBills({
    required int id,
    required double chlorine,
    required double liquid,
    required double solid,
    required double water,
    required double calculatedWater,
    required double measuredWater,
    required int index,
  }) async {
    try {
      loading.value = true;
      loadingIndex.value = index;

      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech-bill/$id",
        {
          "technology_chlorine_consump": chlorine,
          "technology_liquid_alum_consump": liquid,
          "technology_solid_alum_consump": solid,
          "technology_water_amount": water,
          "measured_water": measuredWater,
          "calculated_water": calculatedWater,
        },
      );

      if (res.statusCode == 200) {
        loading.value = false;
        sessionCache = null;
        fetchTechBills(isBackground: true);
        showSuccessToast("تمت الإضافة بنجاح");

        // Clear input fields after successful submission
        getChlorineController(index).clear();
        getLiquidAlumController(index).clear();
        getSolidAlumController(index).clear();
        getWaterProducedController(index).clear();
        getcalculatedWaterControllers(index).clear();
        getmeasuredWaterControllers(index).clear();
      } else {
        loading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      loading.value = false;
      print("Error during bill submission: $e");
    } finally {
      loadingIndex.value = null;
    }
  }
```

</details>

### API-56 — addtech (POST)

Source: [lib/features/technology/controller/add_tech_controller.dart:53](/Users/alimegahed/power_saving/lib/features/technology/controller/add_tech_controller.dart:53). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()), // ✅ Proper JSON encoding
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
TechnlogyController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// Filter function
  

  Future<void> addtech({required TechnologyModel tech}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        looading.value = false;
        TechnlogyController.sessionCache = null;
        showSuccessToast("تم اضافة التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
      print("Error adding station: $e");
    }
  }
```

</details>

### API-57 — edittech (POST)

Source: [lib/features/technology/controller/edit_tech_controller.dart:41](/Users/alimegahed/power_saving/lib/features/technology/controller/edit_tech_controller.dart:41). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/edit-tech/$id",
        (tech.toJson()), // ✅ Proper JSON encoding
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
TechnlogyController.sessionCache = null;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> edittech({
    required TechnologyModel tech,
    required int id,
  }) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/edit-tech/$id",
        (tech.toJson()), // ✅ Proper JSON encoding
      );

      if (res.statusCode == 200) {
        looading.value = false;
        TechnlogyController.sessionCache = null;
        showSuccessToast("تم تعديل التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);

        // Extract Arabic error message
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();

        // Show custom dialog or toast with Arabic error
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
    }
  }
```

</details>

### API-58 — alltechnology (GET)

Source: [lib/features/technology/controller/technlogy.dart:132](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:132). Headers: legacy profile.

**Request invocation**
```dart
fetchData("${ApiConfig.baseUrl}/technologies")
```

**Response parsing / mapping**
```dart
TechnologyModel tech = TechnologyModel.fromJson(i);
final jsonData = json.decode(res.body);
TechnologyModel tech = TechnologyModel.fromJson(i);
```

**Cache / refresh actions**
```dart
_fetchLatestBackground();
sessionCache = responseData;
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
// --- API Calls ---

  Future<void> alltechnology({bool isBackground = false}) async {
    if (!isBackground) {
      if (sessionCache != null) {
        // 1. Display cached data instantly
        all_technology.clear();
        for (var i in sessionCache!) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
        }
        technologies = all_technology;
        _applyFilters();
        
        // 2. Fetch silently in background
        _fetchLatestBackground();
        return;
      } else {
        isLoading.value = true;
        update();
      }
    }
    
    try {
      final res = await fetchData("${ApiConfig.baseUrl}/technologies");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        List<dynamic> responseData = jsonData;

        // Update static cache
        sessionCache = responseData;

        all_technology.clear();
        for (var i in responseData) {
          TechnologyModel tech = TechnologyModel.fromJson(i);
          all_technology.add(tech);
        }
        
        technologies = all_technology; // Update global
        _applyFilters(); // Initialize filtered list
        
        if (!isBackground) {
          isLoading.value = false;
          update();
        }
      } else {
        if (!isBackground) {
          isLoading.value = false;
          update();
          debugPrint("Failed to fetch technologies: ${res.body}");
        }
      }
    } catch (e) {
      if (!isBackground) {
        showCustomErrorDialog(errorMessage: e.toString());
        isLoading.value = false;
        update();
        debugPrint("Error fetching technologies: $e");
      }
    }
  }
```

</details>

### API-59 — addtech (POST)

Source: [lib/features/technology/controller/technlogy.dart:184](/Users/alimegahed/power_saving/lib/features/technology/controller/technlogy.dart:184). Headers: legacy profile.

**Request invocation**
```dart
postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()),
      )
```

**Response parsing / mapping**
```dart
final errorBody = jsonDecode(res.body);
```

**Cache / refresh actions**
```dart
// No explicit cache write/invalidation/refresh found in this method.
```

<details><summary>Exact enclosing method (frozen request construction and response control flow)</summary>

```dart
Future<void> addtech({required TechnologyModel tech}) async {
    try {
      looading.value = true;
      final res = await postData(
        "${ApiConfig.baseUrl}/new-tech",
        (tech.toJson()),
      );

      if (res.statusCode == 200) {
        looading.value = false;
        showSuccessToast("تم اضافة التقنية بنجاح");
      } else {
        looading.value = false;
        final errorBody = jsonDecode(res.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorBody.toString();
        showCustomErrorDialog(errorMessage: errorMessage);
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      looading.value = false;
      debugPrint("Error adding tech: $e");
    }
  }
```

</details>

## Payload and response serializer appendix

All model files used by the application are listed below with exact factory/fromJson/toJson implementation context. This freezes aliases, fallback values, coercions, nullable fields, list behavior and key spelling. These are client assumptions; compatibility with a real server is not asserted.

### lib/features/Counter/model/Counter_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/Counter/model/Counter_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class ElectricMeter {
  final String? accountNumber;
  final double? finalReading;
  final int? meterFactor;
  final int? voltageid;
  final num? price;
  final num? fixedprice;
final String?branch;
  final String meterId;
  String? voltageType;
    String? station;


  ElectricMeter({
    required this.voltageid,
    this.accountNumber,
    this.finalReading,
    this.meterFactor,
    this.price,
    this.fixedprice,
    this.branch,
    this.station,
    required this.meterId,
    this.voltageType,
  });

  factory ElectricMeter.fromJson(Map<String, dynamic> json) {
    return ElectricMeter(
      branch: json['branch_name'],
      voltageid: json['voltage_id'],
      accountNumber: json['account_number'],
      finalReading: json['final_reading'],
      meterFactor: json['meter_factor'],
      price: json["voltage_cost"],
      fixedprice: json["fixed_fee"],
      meterId: json['meter_id'],
      voltageType: json['voltage_type'],
      station: json['station_names'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branch,
      'account_number': accountNumber,
      'final_reading': finalReading,
      'meter_factor': meterFactor,
      'voltage_id': voltageid,
      'meter_id': meterId,
      'voltage_type': voltageType,
      'station_names': station,
    };
  }
}

class VoltageType {
  final num voltageCost;
  final int voltageId;
  final String voltageType;

  VoltageType({
    required this.voltageCost,
    required this.voltageId,
    required this.voltageType,
  });

  factory VoltageType.fromJson(Map<String, dynamic> json) {
    return VoltageType(
      voltageCost: json['voltage_cost'],
      voltageId: json['voltage_id'],
      voltageType: json['voltage_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voltage_cost': voltageCost,
      'voltage_id': voltageId,
      'voltage_type': voltageType,
    };
  }
}
```

</details>

### lib/features/analysis/model/analysis.dart

[Source](/Users/alimegahed/power_saving/lib/features/analysis/model/analysis.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class AnalysisModel {
  final String clorhine;
  final String soild;
  final String liquid;
  final String power;

  AnalysisModel({
    required this.clorhine,
    required this.soild,
    required this.liquid,
    required this.power,
  });

  // Factory method to create from JSON
  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      clorhine: json['chlorine_plot'] ?? '',
      liquid: json['liquid_alum_plot'] ?? '',
      soild: json['solid_alum_plot'] ?? '',
      power: json['power_plot'] ?? '',
    );
  }

}
```

</details>

### lib/features/auth/model/login.dart

[Source](/Users/alimegahed/power_saving/lib/features/auth/model/login.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class User {
  final String empCode;
  final String empName;
  final int? groupId;
  final String? groupName;
  final bool isActive;
  final String username;
  final bool? reset;

  User({
    required this.empCode,
    required this.empName,
    this.reset,
    required this.groupId,
     this.groupName,
    required this.isActive,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      empCode: json['emp_code'] as String,
      empName: json['emp_name'] as String,
      groupId: json['group_id']??1,
      reset: json["reset"]??false,
      groupName: json['group_name']??"",
      isActive: json['is_active'] as bool,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'reset':reset,
      'emp_code': empCode,
      'emp_name': empName,
      'group_id': groupId,
      'group_name': groupName,
      'is_active': isActive,
      'username': username,
    };
  }
}
```

</details>

### lib/features/bill/model/bills_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/bill/model/bills_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class GuageBill {
  final int? guageBillId;
  final String accountNumber;
  final int billMonth;
  final int billYear;
  final num prevReading;
  final num currentReading;
  final num readingFactor;
  final num powerConsump;
  final String? notes;
  final bool? isPaid;
  final num fixedInstallment;
  final num settlements;
  final num settlementsratio;
  final num stamp;
  final num prevPayments;
  final num rounding;
  final num billTotal;
  final int? delayYear;
  final int? delayMonth;
  List<double>? percentMoney;
  List<double>? percentPower;
  
  // New fields from backend to_dict()
  final String? voltageType;
  final String? branchName;
  final String? stationNames;
  final List<String>? stationNamesList;

  GuageBill({
    this.guageBillId,
    this.notes,
    this.isPaid,
    this.delayYear,
    this.delayMonth,
    required this.accountNumber,
    required this.billMonth,
    required this.billYear,
    required this.prevReading,
    required this.currentReading,
    required this.readingFactor,
    required this.powerConsump,
    this.percentMoney,
    this.percentPower,
    required this.settlementsratio,
    required this.fixedInstallment,
    required this.settlements,
    required this.stamp,
    required this.prevPayments,
    required this.rounding,
    required this.billTotal,
    this.voltageType,
    this.branchName,
    this.stationNames,
    this.stationNamesList,
  });

  factory GuageBill.fromJson(Map<String, dynamic> json) {
    return GuageBill(
      delayMonth: json["delay_month"],
      delayYear: json["delay_year"],
      settlementsratio: json["settlement_qty"] ?? 0.0,
      guageBillId: json['guage_bill_id'],
      accountNumber: json['account_number'] ?? '',
      billMonth: json['bill_month'] ?? 1,
      billYear: json['bill_year'] ?? 2024,
      prevReading: json['prev_reading'] ?? 0,
      currentReading: json['current_reading'] ?? 0,
      readingFactor: json['reading_factor'] ?? 1,
      powerConsump: json['power_consump'] ?? 0,
      percentMoney: json["percent_money"] != null ? List<double>.from(json["percent_money"].map((x) => x.toDouble())) : null,
      percentPower: json["percent_power"] != null ? List<double>.from(json["percent_power"].map((x) => x.toDouble())) : null,
      fixedInstallment: json['fixed_installment'] ?? 0.0,
      settlements: json['settlements']?.toDouble() ?? 0.0,
      stamp: json['stamp']?.toDouble() ?? 0.0,
      prevPayments: json['prev_payments']?.toDouble() ?? 0.0,
      rounding: json['rounding']?.toDouble() ?? 0.0,
      billTotal: json['bill_total']?.toDouble() ?? 0.0,
      isPaid: json['is_paid'],
      notes: json["notes"],
      voltageType: json['voltage_type'],
      branchName: json['branch_name'],
      stationNames: json['station_names'],
      stationNamesList: json['station_names_list'] != null ? List<String>.from(json['station_names_list']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "delay_month": delayMonth,
      "delay_year": delayYear,
      "notes": notes,
      "settlement_qty": settlementsratio,
      'percent_money': percentMoney,
      'percent_power': percentPower,
      'guage_bill_id': guageBillId,
      'account_number': accountNumber,
      'bill_month': billMonth,
      'bill_year': billYear,
      'prev_reading': prevReading,
      'current_reading': currentReading,
      'reading_factor': readingFactor,
      'power_consump': powerConsump,
      'fixed_installment': fixedInstallment,
      'settlements': settlements,
      'stamp': stamp,
      'prev_payments': prevPayments,
      'rounding': rounding,
      'bill_total': billTotal,
      'is_paid': isPaid,
      'voltage_type': voltageType,
      'branch_name': branchName,
      'station_names': stationNames,
      'station_names_list': stationNamesList,
    };
  }
}
```

</details>

### lib/features/chemcails/model/chemacial.dart

[Source](/Users/alimegahed/power_saving/lib/features/chemcails/model/chemacial.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class AlumChlorineReference {
  final int? chemicalId;
  final int technologyId;
  final int waterSourceId;
  final String season;
  final String? tech;
  final String? source;

  final double chlorineRangeFrom;
  final double chlorineRangeTo;
  final double? solidAlumRangeFrom;
  final double? solidAlumRangeTo;
  final double? liquidAlumRangeFrom;
  final double? liquidAlumRangeTo;

  AlumChlorineReference({
    this.chemicalId,
    this.tech,
    this.source,
    required this.technologyId,
    required this.waterSourceId,
    required this.season,
    required this.chlorineRangeFrom,
    required this.chlorineRangeTo,
    this.solidAlumRangeFrom,
    this.solidAlumRangeTo,
    this.liquidAlumRangeFrom,
    this.liquidAlumRangeTo,
  });

  factory AlumChlorineReference.fromJson(Map<String, dynamic> json) {
    return AlumChlorineReference(
      chemicalId: json['chemical_id'],
      technologyId: json['technology_id'],
      waterSourceId: json['water_source_id'],
      season: json['season'],
      tech: json['technology_name'],
      source: json['water_source_name'],
      chlorineRangeFrom: json['chlorine_range_from'].toDouble(),
      chlorineRangeTo: json['chlorine_range_to'].toDouble(),
      solidAlumRangeFrom: json['solid_alum_range_from']?.toDouble(),
      solidAlumRangeTo: json['solid_alum_range_to']?.toDouble(),
      liquidAlumRangeFrom: json['liquid_alum_range_from']?.toDouble(),
      liquidAlumRangeTo: json['liquid_alum_range_to']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technology_name': tech,
      'water_source_name': source,
      'chemical_id': chemicalId,
      'technology_id': technologyId,
      'water_source_id': waterSourceId,
      'season': season,
      'chlorine_range_from': chlorineRangeFrom,
      'chlorine_range_to': chlorineRangeTo,
      'solid_alum_range_from': solidAlumRangeFrom,
      'solid_alum_range_to': solidAlumRangeTo,
      'liquid_alum_range_from': liquidAlumRangeFrom,
      'liquid_alum_range_to': liquidAlumRangeTo,
    };
  }
}
```

</details>

### lib/features/home/model/home.dart

[Source](/Users/alimegahed/power_saving/lib/features/home/model/home.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class TopStationEntry {
  final int stationId;
  final String stationName;
  final String branchName;
  final double totalValue;
  final double percent;

  TopStationEntry({
    required this.stationId,
    required this.stationName,
    required this.branchName,
    required this.totalValue,
    required this.percent,
  });

  factory TopStationEntry.fromJson(Map<String, dynamic> json, String valueKey, {double divider = 1}) {
    double p = (json['percent'] as num?)?.toDouble() ?? 0.0;
    if (p.isNaN || p.isInfinite) p = 0.0;
    
    return TopStationEntry(
      stationId: json['station_id'] ?? 0,
      stationName: json['station_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      totalValue: ((json[valueKey] as num?)?.toDouble() ?? 0.0) / divider,
      percent: p,
    );
  }
}

class Max5Data {
  final List<TopStationEntry> topWater;
  final List<TopStationEntry> topPower;
  final List<TopStationEntry> topChlorine;

  Max5Data({
    required this.topWater,
    required this.topPower,
    required this.topChlorine,
  });

  factory Max5Data.fromJson(Map<String, dynamic> json) {
    return Max5Data(
      topWater: (json['top_water'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_water'))
          .toList(),
      topPower: (json['top_power'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_power'))
          .toList(),
      topChlorine: (json['top_chlorine'] as List? ?? [])
          .map((e) => TopStationEntry.fromJson(e as Map<String, dynamic>, 'total_chlorine', divider: 1000))
          .toList(),
    );
  }
}

class OverWaterStation {
  final int capacityLimit;
  final int month;
  final String stationName;
  final double totalWater;
  final int waterCapacity;
  final int year;

  OverWaterStation({
    required this.capacityLimit,
    required this.month,
    required this.stationName,
    required this.totalWater,
    required this.waterCapacity,
    required this.year,
  });

  factory OverWaterStation.fromJson(Map<String, dynamic> json) {
    return OverWaterStation(
      capacityLimit: json['capacity_limit'] ?? 0,
      month: json['month'] ?? 0,
      stationName: json['station_name'] ?? '',
      totalWater: (json['total_water'] as num?)?.toDouble() ?? 0.0,
      waterCapacity: json['water_capacity'] ?? 0,
      year: json['year'] ?? 0,
    );
  }
}
class ConsumptionModel {
  final num? chlorine;
  final num? liquidAlum;
  final double? money;
  final num? power;
  final num? solidAlum;
  final num? water;
  final num? sanitaion;
  final List<OverWaterStation>? overWaterStations;
  final Max5Data? max5;

  // Raw JSON lists
  final List<dynamic>? _rawOverChlorineConsump;
  final List<dynamic>? _rawOverLiquidAlumConsump;
  final List<dynamic>? _rawOverPowerConsump;
  final List<dynamic>? _rawOverSolidAlumConsump;
  final List<dynamic>? _rawWaterForMissingPower;
  final List<dynamic>? _rawOverPowerFor0Water;

  // Cached parsed lists
  List<OverConsump>? _overChlorineConsump;
  List<OverConsump>? _overLiquidAlumConsump;
  List<OverConsump>? _overPowerConsump;
  List<OverConsump>? _overSolidAlumConsump;
  List<OverConsump>? _waterformissingpower;
  List<OverConsump>? _overpowerfor0water;

  ConsumptionModel({
    required this.sanitaion,
    required this.chlorine,
    required this.liquidAlum,
    required this.money,
    required this.power,
    required this.solidAlum,
    required this.water,
    required this.overWaterStations,
    this.max5,
    List<dynamic>? rawWaterForMissingPower,
    List<dynamic>? rawOverPowerFor0Water,
    List<dynamic>? rawOverChlorineConsump,
    List<dynamic>? rawOverLiquidAlumConsump,
    List<dynamic>? rawOverPowerConsump,
    List<dynamic>? rawOverSolidAlumConsump,
  })  : _rawWaterForMissingPower = rawWaterForMissingPower,
        _rawOverPowerFor0Water = rawOverPowerFor0Water,
        _rawOverChlorineConsump = rawOverChlorineConsump,
        _rawOverLiquidAlumConsump = rawOverLiquidAlumConsump,
        _rawOverPowerConsump = rawOverPowerConsump,
        _rawOverSolidAlumConsump = rawOverSolidAlumConsump;

  // Count getters
  int get overChlorineConsumpCount => _rawOverChlorineConsump?.length ?? 0;
  int get overLiquidAlumConsumpCount => _rawOverLiquidAlumConsump?.length ?? 0;
  int get overPowerConsumpCount => _rawOverPowerConsump?.length ?? 0;
  int get overSolidAlumConsumpCount => _rawOverSolidAlumConsump?.length ?? 0;
  int get waterForMissingPowerCount => _rawWaterForMissingPower?.length ?? 0;
  int get overPowerFor0WaterCount => _rawOverPowerFor0Water?.length ?? 0;

  // Lazy parsed getters
  List<OverConsump> get overChlorineConsump {
    if (_rawOverChlorineConsump == null) return [];
    _overChlorineConsump ??= _rawOverChlorineConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overChlorineConsump!;
  }

  List<OverConsump> get overLiquidAlumConsump {
    if (_rawOverLiquidAlumConsump == null) return [];
    _overLiquidAlumConsump ??= _rawOverLiquidAlumConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overLiquidAlumConsump!;
  }

  List<OverConsump> get overPowerConsump {
    if (_rawOverPowerConsump == null) return [];
    _overPowerConsump ??= _rawOverPowerConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overPowerConsump!;
  }

  List<OverConsump> get overSolidAlumConsump {
    if (_rawOverSolidAlumConsump == null) return [];
    _overSolidAlumConsump ??= _rawOverSolidAlumConsump.map((e) => OverConsump.fromJson(e)).toList();
    return _overSolidAlumConsump!;
  }

  List<OverConsump> get Waterformissingpower {
    if (_rawWaterForMissingPower == null) return [];
    _waterformissingpower ??= _rawWaterForMissingPower.map((e) => OverConsump.fromJson(e)).toList();
    return _waterformissingpower!;
  }

  List<OverConsump> get overpowerfor0water {
    if (_rawOverPowerFor0Water == null) return [];
    _overpowerfor0water ??= _rawOverPowerFor0Water.map((e) => OverConsump.fromJson(e)).toList();
    return _overpowerfor0water!;
  }

  factory ConsumptionModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionModel(
      chlorine: json['chlorine'],
      liquidAlum: json['liquid_alum'],
      money: (json['money'] as num?)?.toDouble(),
      power: json['power'],
      solidAlum: json['solid_alum'],
      water: json['water'],
      sanitaion: json['sanitaion'],
      rawWaterForMissingPower: json['water_with_missing_power'] as List?,
      rawOverPowerFor0Water: json['over_power_for_0_water'] as List?,
      rawOverChlorineConsump: json['over_chlorine_consump'] as List?,
      rawOverLiquidAlumConsump: json['over_liquid_alum_consump'] as List?,
      rawOverPowerConsump: json['over_power_consump'] as List?,
      rawOverSolidAlumConsump: json['over_solid_alum_consump'] as List?,
      overWaterStations: json['over_water_stations'] == null
          ? null
          : (json['over_water_stations'] as List)
              .map((e) => OverWaterStation.fromJson(e))
              .toList(),
      max5: json['max_5'] != null
          ? Max5Data.fromJson(json['max_5'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OverConsump {
  final int billMonth;
  final int billYear;
  final num? chlorineRangeFrom;
  final num? chlorineRangeTo;
  final num? liquidAlumRangeFrom;
  final num? liquidAlumRangeTo;
  final num? powerPerWater;
  final num? solidAlumRangeFrom;
  final num? solidAlumRangeTo;
  final int stationId;
  final String stationName;
  final int techBillId;
  final num? technologyBillPercentage;
  final String technologyBillTotal;
  final num? technologyChlorineConsump;
  final int technologyId;
  final num? technologyLiquidAlumConsump;
  final String technologyName;
  final num? technologyPowerConsump;
  final num? technologySolidAlumConsump;
  final num? technologyWaterAmount;

  OverConsump({
    required this.billMonth,
    required this.billYear,
    required this.chlorineRangeFrom,
    required this.chlorineRangeTo,
    required this.liquidAlumRangeFrom,
    required this.liquidAlumRangeTo,
    required this.powerPerWater,
    required this.solidAlumRangeFrom,
    required this.solidAlumRangeTo,
    required this.stationId,
    required this.stationName,
    required this.techBillId,
    required this.technologyBillPercentage,
    required this.technologyBillTotal,
    required this.technologyChlorineConsump,
    required this.technologyId,
    required this.technologyLiquidAlumConsump,
    required this.technologyName,
    required this.technologyPowerConsump,
    required this.technologySolidAlumConsump,
    required this.technologyWaterAmount,
  });

  factory OverConsump.fromJson(Map<String, dynamic> json) {
    return OverConsump(
      billMonth: json['bill_month'] ?? 0,
      billYear: json['bill_year'] ?? 0,
      chlorineRangeFrom: json['chlorine_range_from'],
      chlorineRangeTo: json['chlorine_range_to'],
      liquidAlumRangeFrom: json['liquid_alum_range_from'],
      liquidAlumRangeTo: json['liquid_alum_range_to'],
      powerPerWater: json['power_per_water'],
      solidAlumRangeFrom: json['solid_alum_range_from'],
      solidAlumRangeTo: json['solid_alum_range_to'],
      stationId: json['station_id'] ?? 0,
      stationName: json['station_name'] ?? '',
      techBillId: json['tech_bill_id'] ?? 0,
      technologyBillPercentage: json['technology_bill_percentage'],
      technologyBillTotal: (json['technology_bill_total'] ?? '').toString(),
      technologyChlorineConsump: json['technology_chlorine_consump'],
      technologyId: json['technology_id'] ?? 0,
      technologyLiquidAlumConsump: json['technology_liquid_alum_consump'],
      technologyName: json['technology_name'] ?? '',
      technologyPowerConsump: json['technology_power_consump'],
      technologySolidAlumConsump: json['technology_solid_alum_consump'],
      technologyWaterAmount: json['technology_water_amount'],
    );
  }
}
```

</details>

### lib/features/planning/model/all_places_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/planning/model/all_places_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class Place {
  final int? placeId;
  final String placeName;
  final int placeTypeId;
  final int branchId;
  final int areaId;
  final String? placeTypeName;
  final String? areaName;
  final String? branchName;
  final List<PopulationsModel>? populations;
  // Add other relationships if needed, such as `Branch`, `AreaOfService`

  // Constructor
  Place({
    this.populations,
     this.placeId,
    required this.placeName,
    required this.placeTypeId,
    required this.branchId,
    required this.areaId,
     this.placeTypeName,
     this.areaName,
     this.branchName,
  });

  // Factory method to create a Place instance from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      placeName: json['place_name'],
      populations: (json['populations'] as List<dynamic>?)
          ?.map((e) => PopulationsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeTypeId: json['place_type_id'],
      branchId: json['branch_id'],
      areaId: json['area_id'],
      placeTypeName: json['place_type_name'],
      areaName: json['area_name'],
      branchName: json['branch_name'],
    );
  }

  // Convert a Place instance to JSON
  Map<String, dynamic> toJson() {
    return {

      'place_id': placeId,
      'place_name': placeName,
      'place_type_id': placeTypeId,
      'branch_id': branchId,
      'area_id': areaId,
      'place_type_name': placeTypeName,
      'area_name': areaName,
      'branch_name': branchName,
      'populations': populations?.map((e) => e.toJson()).toList(),
    };
  }
}
class PopulationsModel {
  int placeId;
  String placeName;
  int population;
  int populationYear;

  // Constructor
  PopulationsModel({
    required this.placeId,
    required this.placeName,
    required this.population,
    required this.populationYear,
  });

  // Factory constructor to create a Place instance from a JSON object
  factory PopulationsModel.fromJson(Map<String, dynamic> json) {
    return PopulationsModel(
      placeId: json['place_id'],
      placeName: json['place_name'],
      population: json['population'],
      populationYear: json['population_year'],
    );
  }

  // Method to convert a Place instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'population': population,
      'population_year': populationYear,
    };
  }

  // Optionally, you can create a method to print the data in a human-readable format
  @override
  String toString() {
    return 'Place{id: $placeId, name: $placeName, population: $population, populationYear: $populationYear}';
  }
}
class PlaceType {
  final int personPortionFrom;
  final int personPortionTo;
  final int placeTypeId;
  final String placeTypeName;

  PlaceType({
    required this.personPortionFrom,
    required this.personPortionTo,
    required this.placeTypeId,
    required this.placeTypeName,
  });

  // Factory method to create a Place instance from JSON data
  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(
      personPortionFrom: json['person_portion_from'],
      personPortionTo: json['person_portion_to'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
    );
  }

  // Convert a Place instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'person_portion_from': personPortionFrom,
      'person_portion_to': personPortionTo,
      'place_type_id': placeTypeId,
      'place_type_name': placeTypeName,
    };
  }
}



  // Convert an AreaOfService instance to JSON
```

</details>

### lib/features/planning/model/area_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/planning/model/area_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class AreaOfService {
  final int areaId;
  final String areaName;
  final bool increasable;

  AreaOfService({
    required this.areaId,
    required this.areaName,
    this.increasable = false,
  });

  // Factory method to create an AreaOfService instance from JSON
  factory AreaOfService.fromJson(Map<String, dynamic> json) {
    return AreaOfService(
      areaId: json['area_id'] ?? 0,
      areaName: json['area_name'] ?? '',
      increasable: json['increasable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'area_name': areaName,
      'increasable': increasable,
    };
  }
}
```

</details>

### lib/features/planning/model/blance_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/planning/model/blance_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
import 'package:power_saving/features/stations/model/station_model.dart';

class WaterData {
  final int year;
  final double waterNeed;
  final num population;
  final num qDemandedMonthlyMin;
  final num qDemandedMonthlyAvg;
  final num qDemandedMonthlyMax;
  final num qDemandedDailyMin;
  final num qDemandedDailyAvg;
  final num qDemandedDailyMax;
  final num qDemandedHourly;
  final num qFire;
  final num currentProduction;
  final num maxProduction;
  final num? futureProduction;
  
  // New area-related fields
  final int? areaId;
  final String? areaName;
  final int? branchId;
  final String? branchName;
  final int? placeId;
  final String? placeName;
  final int? placeTypeId;
  final String? placeTypeName;

  WaterData({
    required this.year,
    required this.waterNeed,
    required this.population,
    required this.qDemandedMonthlyMin,
    required this.qDemandedMonthlyAvg,
    required this.qDemandedMonthlyMax,
    required this.qDemandedDailyMin,
    required this.qDemandedDailyAvg,
    required this.qDemandedDailyMax,
    required this.qDemandedHourly,
    required this.qFire,
    required this.currentProduction,
    required this.maxProduction,
    this.futureProduction,
    this.areaId,
    this.areaName,
    this.branchId,
    this.branchName,
    this.placeId,
    this.placeName,
    this.placeTypeId,
    this.placeTypeName,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      year: json['year'],
      waterNeed: json['water_need'],
      population: json['population'],
      qDemandedMonthlyMin: json['Q_demanded_monthly_min'],
      qDemandedMonthlyAvg: json['Q_demanded_monthly_avg'],
      qDemandedMonthlyMax: json['Q_demanded_monthly_max'],
      qDemandedDailyMin: json['Q_demanded_daily_min'],
      qDemandedDailyAvg: json['Q_demanded_daily_avg'],
      qDemandedDailyMax: json['Q_demanded_daily_max'],
      qDemandedHourly: json['Q_demanded_hourly'],
      qFire: json['Q_fire'],
      currentProduction: json['current_production'],
      maxProduction: json['max_production'],
      futureProduction: json['future_production'],
      areaId: json['area_id'],
      areaName: json['area_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
    );
  }

  static List<WaterData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => WaterData.fromJson(json)).toList();
  }
}

class WaterDataResponse {
  final List<WaterData> balncedata; 
  final String chart;
  final AreaData? areaData; // New field for area information

  WaterDataResponse({
    required this.balncedata,
    required this.chart,
    this.areaData,
  });

  factory WaterDataResponse.fromJson(Map<String, dynamic> json) {
    return WaterDataResponse(
      balncedata: WaterData.fromJsonList(json['table']),
      chart: json['chart'],
      areaData: json['area_data'] != null 
          ? AreaData.fromJson(json['area_data']) 
          : null,
    );
  }
}

// New AreaData model
class AreaData {
  final int areaId;
  final String areaName;
  final List<Place> places;
  final List<Station>? stations; // Optional populations list

  AreaData({
    required this.areaId,
    required this.areaName,
    required this.stations,
    required this.places,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      areaId: json['area_id'],
      areaName: json['area_name'],
      stations: json['stations'] != null
          ? (json['stations'] as List)
              .map((station) => Station.fromJson(station))
              .toList()
          : null,
      places: (json['places'] as List)
          .map((place) => Place.fromJson(place))
          .toList(),
    );
  }
}

class Place {
  final int areaId;
  final String areaName;
  final int branchId;
  final String branchName;
  final int placeId;
  final String placeName;
  final int placeTypeId;
  final String placeTypeName;
  final List<Population> populations;

  Place({
    required this.areaId,
    required this.areaName,
    required this.branchId,
    required this.branchName,
    required this.placeId,
    required this.placeName,
    required this.placeTypeId,
    required this.placeTypeName,
    required this.populations,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      areaId: json['area_id'],
      areaName: json['area_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeTypeId: json['place_type_id'],
      placeTypeName: json['place_type_name'],
      populations: (json['populations'] as List)
          .map((pop) => Population.fromJson(pop))
          .toList(),
    );
  }
}

class Population {
  final int placeId;
  final String placeName;
  final int population;
  final int populationYear;

  Population({
    required this.placeId,
    required this.placeName,
    required this.population,
    required this.populationYear,
  });

  factory Population.fromJson(Map<String, dynamic> json) {
    return Population(
      placeId: json['place_id'],
      placeName: json['place_name'],
      population: json['population'],
      populationYear: json['population_year'],
    );
  }
}
```

</details>

### lib/features/planning/model/ml_forecast_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/planning/model/ml_forecast_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class MLDataQuality {
  final int totalRows;
  final int nAreas;
  final int nMonths;
  final bool reliable;
  final List<String> warnings;

  MLDataQuality({
    required this.totalRows,
    required this.nAreas,
    required this.nMonths,
    required this.reliable,
    required this.warnings,
  });

  factory MLDataQuality.fromJson(Map<String, dynamic> json) {
    List<String> warns = [];
    if (json['warnings'] is List) {
      for (var w in json['warnings']) {
        if (w is Map && w['message'] != null) {
          warns.add(w['message'].toString());
        } else if (w is String) {
          warns.add(w);
        }
      }
    }
    return MLDataQuality(
      totalRows: json['total_rows'] ?? 0,
      nAreas: json['n_areas'] ?? 0,
      nMonths: json['n_months'] ?? 0,
      reliable: json['reliable'] ?? false,
      warnings: warns,
    );
  }
}

class MLSaturationResult {
  final String? areaName;
  final int? peakMonth;
  final double? utilization;
  final int? year;
  final int? month;
  final int? popMax;
  final String? warning;
  final Map<String, dynamic>? scenarios;

  MLSaturationResult({
    this.areaName,
    this.peakMonth,
    this.utilization,
    this.year,
    this.month,
    this.popMax,
    this.warning,
    this.scenarios,
  });

  factory MLSaturationResult.fromJson(Map<String, dynamic> json) {
    return MLSaturationResult(
      areaName: json['area_name']?.toString(),
      peakMonth: json['peak_month'],
      utilization: json['utilization'] != null
          ? (json['utilization'] as num).toDouble()
          : null,
      year: json['year'],
      month: json['month'],
      popMax: json['pop_max'],
      warning: json['warning']?.toString(),
      scenarios: json['scenarios'] is Map<String, dynamic>
          ? json['scenarios'] as Map<String, dynamic>
          : null,
    );
  }
}

class MLForecastResponse {
  final String bestModel;
  final String featureSet;
  final double cvR2Mean;
  final double cvR2Std;
  final double finalR2;
  final double finalMae;
  final double? smearingFactor;
  final int? requestedAreaId;
  final MLSaturationResult? requestedAreaSaturation;
  final Map<String, MLSaturationResult> allAreasSaturation;
  final List<dynamic> atRiskAreas;
  final MLDataQuality? dataQuality;

  MLForecastResponse({
    required this.bestModel,
    required this.featureSet,
    required this.cvR2Mean,
    required this.cvR2Std,
    required this.finalR2,
    required this.finalMae,
    this.smearingFactor,
    this.requestedAreaId,
    this.requestedAreaSaturation,
    required this.allAreasSaturation,
    required this.atRiskAreas,
    this.dataQuality,
  });

  factory MLForecastResponse.fromJson(Map<String, dynamic> json) {
    Map<String, MLSaturationResult> areas = {};
    if (json['all_areas_saturation'] is Map) {
      (json['all_areas_saturation'] as Map).forEach((k, v) {
        if (v is Map<String, dynamic>) {
          areas[k.toString()] = MLSaturationResult.fromJson(v);
        }
      });
    }

    return MLForecastResponse(
      bestModel: json['best_model']?.toString() ?? '',
      featureSet: json['feature_set']?.toString() ?? '',
      cvR2Mean: (json['cv_r2_mean'] as num?)?.toDouble() ?? 0.0,
      cvR2Std: (json['cv_r2_std'] as num?)?.toDouble() ?? 0.0,
      finalR2: (json['final_r2'] as num?)?.toDouble() ?? 0.0,
      finalMae: (json['final_mae'] as num?)?.toDouble() ?? 0.0,
      smearingFactor: (json['smearing_factor'] as num?)?.toDouble(),
      requestedAreaId: json['requested_area_id'],
      requestedAreaSaturation: json['requested_area_saturation'] is Map<String, dynamic>
          ? MLSaturationResult.fromJson(json['requested_area_saturation'])
          : null,
      allAreasSaturation: areas,
      atRiskAreas: json['at_risk_areas'] is List ? json['at_risk_areas'] : [],
      dataQuality: json['data_quality'] is Map<String, dynamic>
          ? MLDataQuality.fromJson(json['data_quality'])
          : null,
    );
  }
}
```

</details>

### lib/features/planning/model/populations_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/planning/model/populations_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class PopulationsModel {
  int placeId;
  String placeName;
  int population;
  int populationYear;

  // Constructor
  PopulationsModel({
    required this.placeId,
    required this.placeName,
    required this.population,
    required this.populationYear,
  });

  // Factory constructor to create a Place instance from a JSON object
  factory PopulationsModel.fromJson(Map<String, dynamic> json) {
    return PopulationsModel(
      placeId: json['place_id'],
      placeName: json['place_name'],
      population: json['population'],
      populationYear: json['population_year'],
    );
  }

  // Method to convert a Place instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'population': population,
      'population_year': populationYear,
    };
  }

  // Optionally, you can create a method to print the data in a human-readable format
  @override
  String toString() {
    return 'Place{id: $placeId, name: $placeName, population: $population, populationYear: $populationYear}';
  }
}
```

</details>

### lib/features/predaction/model/predication.dart

[Source](/Users/alimegahed/power_saving/lib/features/predaction/model/predication.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class PredictionModel {
  final String predictionPlot; // base64 image string
  final num waterCapacity; // max_water_amount
  final num representedPoints; // points_represented * 100
  final String expectedYear; // expected_year

  PredictionModel({
    required this.predictionPlot,
    required this.waterCapacity,
    required this.representedPoints,
    required this.expectedYear,
  });

  // Factory method to parse from JSON
  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      predictionPlot: json['prediction_plot'] ?? '',
      waterCapacity: (json['water_capacity'] ?? 0).toDouble(),
      representedPoints: (json['represented_points'] ?? 0).toDouble(),
      expectedYear: json['expected_year'] ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'prediction_plot': predictionPlot,
      'water_capacity': waterCapacity,
      'represented_points': representedPoints,
      'expected_year': expectedYear,
    };
  }
}
```

</details>

### lib/features/relations/model/relations.dart

[Source](/Users/alimegahed/power_saving/lib/features/relations/model/relations.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class StationGaugeTechnologyRelation {
  final String accountNumber;
  final bool relationStatus;
  final int? stationGaugeTechnologyId;
  final int stationId;
  final String? stationName;
  final int technologyId;
  final bool? issource;
  final String? branchName;
  final String? technologyName;

  StationGaugeTechnologyRelation({
    required this.accountNumber,
    required this.relationStatus,
    this.stationGaugeTechnologyId,
    required this.stationId,
    this.stationName,
    this.branchName,
    required this.technologyId,
    this.technologyName,
     this.issource,
  });

  factory StationGaugeTechnologyRelation.fromJson(Map<String, dynamic> json) {
    return StationGaugeTechnologyRelation(
      accountNumber: json['account_number'],
      branchName: json['branch_name'],
      relationStatus: json['relation_status'],
      stationGaugeTechnologyId: json['station_guage_technology_id'],
      stationId: json['station_id'],
      stationName: json['station_name'],
      technologyId: json['technology_id'],
      technologyName: json['technology_name'],
      issource: json['is_source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'relation_status': relationStatus,
      'station_guage_technology_id': stationGaugeTechnologyId,
      'station_id': stationId,
      'branch_name': branchName,
      'is_source': issource,
      'station_name': stationName,
      'technology_id': technologyId,
      'technology_name': technologyName,
    };
  }
}
```

</details>

### lib/features/reports/model/report.dart

[Source](/Users/alimegahed/power_saving/lib/features/reports/model/report.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class ReportBranch {
  final String branchName;
    final String? techname;
        final String? stationname;
        final String? station;
                final String? accountnumber;
                final double?wateramount;
                final double?powerconsump;
                final double?chlorineconsump;
                final double?soildalum;
                final double?liquidalum;

                final bool? ispaid;
                final double? actualratio;

                final double? expected;
                final double? excesspercentage;
                final double? minratio;
                final double? maxratio;
                final double? actialratio;
                final String? statues;

  final int month;
  final int year;
   final int? delleymonth;
  final int? delleyyear;
    final String? precent;

  final double totalBill;
  final double totalChlorine;
  final double totalLiquidAlum;
  final double totalPower;
  final double totalSolidAlum;
  final double totalWater;
  final String? stationnames;

  ReportBranch({
    this.precent,
    
    this.actualratio,
    this.stationnames,
    this.expected,
    this.excesspercentage,
    this.station,
    this.minratio,
    this.maxratio,
    this.actialratio,
    this.accountnumber,
    required this.branchName,
    required this.month,
    required this.year,
    required this.totalBill,
    this.statues,
    required this.totalChlorine,
    this.ispaid,
    this.delleymonth,
    this.delleyyear,
    this.wateramount,
    this.powerconsump,
    this.techname,
    this.stationname,
    this.chlorineconsump,
    this.liquidalum,
    this.soildalum,
    required this.totalLiquidAlum,
    required this.totalPower,
    required this.totalSolidAlum,
    required this.totalWater,
  });

  factory ReportBranch.fromJson(Map<String, dynamic> json) {
    return ReportBranch(
      branchName: json['branch_name']??"",
      techname: json["technology_name"],
      month: json['month']??0,
      ispaid: json["is_paid"],
      statues: json["status"]??"",
      minratio: (json["min_ratio"]??0 as num).toDouble(),
      maxratio: (json["max_ratio"]??0 as num).toDouble(),
      actialratio: (json["actual_ratio"]??0 as num).toDouble(),
      wateramount: json["water_amount"],
      powerconsump: json["power_consumption"],
      chlorineconsump: json["chlorine_consumption"],
      liquidalum: json["liquid_alum_consumption"],
      soildalum: json["solid_alum_consumption"],
delleymonth: json["delay_month"],
excesspercentage: 
    (json["excess_percentage"]??0 as num).toDouble(),
    expected: (json["expected_ratio"]??0 as num).toDouble(),
delleyyear: json["delay_year"],
      accountnumber: json["account_number"]??"",
      stationname: json['station_name'] ?? json['station'] ?? json['stationName'] ?? "",
      year: json['year']??0,
      stationnames: json['station_names'] ?? json['stations'] ?? json['stationNames'] ?? "",
      precent: json["percent"]??"",
      actualratio: (json["actual_ratio"]??0 as num).toDouble(),
      totalBill: (json['total_bill']??0 as num).toDouble(),
      totalChlorine: (json['total_chlorine']??0 as num).toDouble(),
      totalLiquidAlum: (json['total_liquid_alum']??0 as num).toDouble(),
      totalPower: (json['total_power']??0 as num).toDouble(),
      totalSolidAlum: (json['total_solid_alum']??0 as num).toDouble(),
      totalWater: (json['total_water']??0 as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"delay_year":delleyyear
    ,
    "delay_month":delleymonth,
    "is_paid":ispaid,
      "account_number":accountnumber,
      'branch_name': branchName,
      'month': month,
      'station_names': station,
      'year': year,
      'technology_name':techname,
      'total_bill': totalBill,
      'total_chlorine': totalChlorine,
      'total_liquid_alum': totalLiquidAlum,
      'total_power': totalPower,
      'total_solid_alum': totalSolidAlum,
      'total_water': totalWater,
    };
  }
}
```

</details>

### lib/features/stations/model/station_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/stations/model/station_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class Station {
  final String? branchName;
  final int? stationId;
  final String stationName;
  final String stationType;
  final int? stationWaterCapacity;
  final int? branchid;
  final int? sourceid;

  final String? waterSourceName;

  Station({
    this.branchid,
    this.sourceid,
    this.branchName,
    this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    this.waterSourceName,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      sourceid: json['water_source_id'],
      branchid: json['branch_id'],
      branchName: json['branch_name'],
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      waterSourceName: json['water_source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'station_id': stationId,
      'station_name': stationName,
      'station_type': stationType,
      'station_water_capacity': stationWaterCapacity,
      'water_source_name': waterSourceName,
    };
  }
}

class Branch {
  final int branchId;
  final String branchName;

  Branch({required this.branchId, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(branchId: json['branch_id'], branchName: json['branch_name']);
  }

  Map<String, dynamic> toJson() {
    return {'branch_id': branchId, 'branch_name': branchName};
  }
}

class allstations {
  final int branchId;
  final String branchName;

  allstations({required this.branchId, required this.branchName});

  factory allstations.fromJson(Map<String, dynamic> json) {
    return allstations(
      branchId: json['station_id'],
      branchName: json['station_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'station_id': branchId, 'station_name': branchName};
  }
}

class WaterSource {
  final int? waterSourceId;
  final String? waterSourceName;

  WaterSource({required this.waterSourceId, required this.waterSourceName});

  factory WaterSource.fromJson(Map<String, dynamic> json) {
    return WaterSource(
      waterSourceId: json['water_source_id'],
      waterSourceName: json['water_source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water_source_id': waterSourceId,
      'water_source_name': waterSourceName,
    };
  }
}

class AddStationData {
  final List<Branch> branches;
  final List<WaterSource> waterSources;

  AddStationData({required this.branches, required this.waterSources});

  factory AddStationData.fromJson(Map<String, dynamic> json) {
    return AddStationData(
      branches:
          (json['branches'] as List).map((b) => Branch.fromJson(b)).toList(),
      waterSources:
          (json['water_sources'] as List)
              .map((ws) => WaterSource.fromJson(ws))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branches': branches.map((b) => b.toJson()).toList(),
      'water_sources': waterSources.map((ws) => ws.toJson()).toList(),
    };
  }
}
```

</details>

### lib/features/tech_bills/model/tech_bill.dart

[Source](/Users/alimegahed/power_saving/lib/features/tech_bills/model/tech_bill.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class TechnologyBill {
  final int billMonth;
  final int billYear;
  final num? chlorineRangeFrom;
  final num? chlorineRangeTo;
  final num? liquidAlumRangeFrom;
  final num? liquidAlumRangeTo;
  final num? powerPerWater;
  final num? solidAlumRangeFrom;
  final num? solidAlumRangeTo;
  final int stationId;
  final String stationName;
    final String ?branch;

  final int techBillId;
  final num technologyBillPercentage;
  final String technologyBillTotal;
  final num? technologyChlorineConsump;
  final int technologyId;
  final num? technologyLiquidAlumConsump;
  final String technologyName;
  final num technologyPowerConsump;
  final num? technologySolidAlumConsump;
  final num? technologyWaterAmount;
  final num? calculatedWater;
  final num? measuredWater;

  TechnologyBill({
    required this.billMonth,
    required this.billYear,
    this.chlorineRangeFrom,
    this.calculatedWater,
     this.measuredWater,
    this.chlorineRangeTo,
    this.liquidAlumRangeFrom,
    this.liquidAlumRangeTo,
    this.powerPerWater,
    this.solidAlumRangeFrom,
    this.branch,
    this.solidAlumRangeTo,
    required this.stationId,
    required this.stationName,
    required this.techBillId,
    required this.technologyBillPercentage,
    required this.technologyBillTotal,
    this.technologyChlorineConsump,
    required this.technologyId,
    this.technologyLiquidAlumConsump,
    required this.technologyName,
    required this.technologyPowerConsump,
    this.technologySolidAlumConsump,
    this.technologyWaterAmount,
  });

  factory TechnologyBill.fromJson(Map<String, dynamic> json) {
    return TechnologyBill(
      billMonth: json['bill_month'] ?? 0,
      billYear: json['bill_year'] ?? 0,
      branch: json['branch_name'],
      chlorineRangeFrom: json['chlorine_range_from'] ?? 0,
      chlorineRangeTo: json['chlorine_range_to'] ?? 0,
      liquidAlumRangeFrom: json['liquid_alum_range_from'] ?? 0,
      liquidAlumRangeTo: json['liquid_alum_range_to'] ?? 0,
      powerPerWater: json['power_per_water'] ?? 0,
      solidAlumRangeFrom: json['solid_alum_range_from'] ?? 0,
      solidAlumRangeTo: json['solid_alum_range_to'] ?? 0,
      stationId: json['station_id'] ?? 0,
      calculatedWater: json['calculated_water'] ?? 0,
      measuredWater: json['measured_water'] ?? 0,
      stationName: json['station_name'] ?? '',
      techBillId: json['tech_bill_id'] ?? 0,
      technologyBillPercentage: json['technology_bill_percentage'] ?? 0,
      technologyBillTotal: (json['technology_bill_total'] ?? '').toString(),
      technologyChlorineConsump: json['technology_chlorine_consump'] ?? 0,
      technologyId: json['technology_id'] ?? 0,
      technologyLiquidAlumConsump: json['technology_liquid_alum_consump'] ?? 0,
      technologyName: json['technology_name'] ?? '',
      technologyPowerConsump: json['technology_power_consump'] ?? 0,
      technologySolidAlumConsump: json['technology_solid_alum_consump'] ?? 0,
      technologyWaterAmount: json['technology_water_amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name':branch,
      'bill_month': billMonth,
      'bill_year': billYear,
      'chlorine_range_from': chlorineRangeFrom,
      'chlorine_range_to': chlorineRangeTo,
      'liquid_alum_range_from': liquidAlumRangeFrom,
      'liquid_alum_range_to': liquidAlumRangeTo,
      'power_per_water': powerPerWater,
      'solid_alum_range_from': solidAlumRangeFrom,
      'solid_alum_range_to': solidAlumRangeTo,
      'station_id': stationId,
      'station_name': stationName,
      'tech_bill_id': techBillId,
      'technology_bill_percentage': technologyBillPercentage,
      'technology_bill_total': technologyBillTotal,
      'technology_chlorine_consump': technologyChlorineConsump,
      'technology_id': technologyId,
      'technology_liquid_alum_consump': technologyLiquidAlumConsump,
      'technology_name': technologyName,
      'technology_power_consump': technologyPowerConsump,
      'technology_solid_alum_consump': technologySolidAlumConsump,
      'technology_water_amount': technologyWaterAmount,
    };
  }
}
```

</details>

### lib/features/technology/model/tech_model.dart

[Source](/Users/alimegahed/power_saving/lib/features/technology/model/tech_model.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class TechnologyModel {
  final double powerPerWater;
   int? technologyId;
  final String technologyName;
   final String main_type;

  TechnologyModel({
    required this.powerPerWater,
     this.technologyId,
    required this.main_type,
    required this.technologyName,
  });

  factory TechnologyModel.fromJson(Map<String, dynamic> json) {
    return TechnologyModel(
      main_type: json['technology_main_type'],
      powerPerWater: json['power_per_water'],
      technologyId: json['technology_id'],
      technologyName: json['technology_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technology_main_type':main_type,
      'power_per_water': powerPerWater,
      'technology_id': technologyId,
      'technology_name': technologyName,
    };
  }
}
```

</details>

### lib/model/vlotage.dart

[Source](/Users/alimegahed/power_saving/lib/model/vlotage.dart)

<details><summary>Current model definitions and mappings</summary>

```dart
class VoltagePlan {
  num fixedFee;
  num voltageCost;
  final int voltageId;
  final String voltageType;

  VoltagePlan({
    required this.fixedFee,
    required this.voltageCost,
    required this.voltageId,
    required this.voltageType,
  });

  // Factory method to create an object from JSON
  factory VoltagePlan.fromJson(Map<String, dynamic> json) {
    return VoltagePlan(
      fixedFee: json['fixed_fee'],
      voltageCost: json['voltage_cost'],
      voltageId: json['voltage_id'],
      voltageType: json['voltage_type'],
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'fixed_fee': fixedFee,
      'voltage_cost': voltageCost,
      'voltage_id': voltageId,
      'voltage_type': voltageType,
    };
  }
}
```

</details>

### Controller-local Station mapping: lib/features/tech_bills/controller/new_tech_bills.dart

```dart
class Station {
  final int stationId;
  final String stationName;
  final String stationType;
  final int stationWaterCapacity;
  final String branchName;
  final String waterSourceName;
  final List<TechnologyModel> techs;

  Station({
    required this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    required this.branchName,
    required this.waterSourceName,
    required this.techs,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    var techsFromJson = json['techs'] as List<dynamic>? ?? [];
    List<TechnologyModel> techList =
        techsFromJson.map((e) => TechnologyModel.fromJson(e)).toList();

    return Station(
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      branchName: json['branch_name'],
      waterSourceName: json['water_source_name'],
      techs: techList,
    );
  }
}

```

### Controller-local Station mapping: lib/features/stations/controller/following_stations_controller.dart

```dart
class Station {
  final int stationId;
  final String stationName;
  final String stationType;
  final int stationWaterCapacity;
  final String branchName;
  final String waterSourceName;
  final List<TechnologyModel> techs;

  Station({
    required this.stationId,
    required this.stationName,
    required this.stationType,
    required this.stationWaterCapacity,
    required this.branchName,
    required this.waterSourceName,
    required this.techs,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    var techsFromJson = json['techs'] as List<dynamic>? ?? [];
    List<TechnologyModel> techList =
        techsFromJson.map((e) => TechnologyModel.fromJson(e)).toList();

    return Station(
      stationId: json['station_id'],
      stationName: json['station_name'],
      stationType: json['station_type'],
      stationWaterCapacity: json['station_water_capacity'],
      branchName: json['branch_name'],
      waterSourceName: json['water_source_name'],
      techs: techList,
    );
  }
}

```

## Known contract uncertainties — freeze, do not repair

- GET `/edit-relation/$id` is used for a status action. Do not change it to POST or call it as a harmless read.
- CounterController.addCounter points to `/new-station`, whereas the dedicated addcounter.addCounter uses `/new-gauge`. Preserve both until reachability/intended contract is resolved; do not silently correct the endpoint.
- Bill prerequisite path encodes account number; submission interpolates its supplied number. Preserve encoding behavior pending an authoritative path contract.
- Many callers require 200 while transport accepts all 2xx; NewTechBills accepts 200/201. Do not homogenize success codes without fixtures/specification.
- AllBills declares a Map cache before its List-response fallback. Record current failure behavior for List payloads before considering schema changes.
- Controller-local Station mappings duplicate the station model with different shapes. Do not collapse response schemas based on names.
- Default dates, zeros, role 1, nullable numerics and omitted keys are frozen current behavior, not approved domain truth.
- Do not add pagination, idempotency, session-check, refresh-token or logout endpoints, new headers or request fields.

## Exact planning request-body builder

This helper is invoked before submitData and is part of its frozen contract.

```dart
    Map<String, dynamic> buildRequestBody() {
    final Map<String, dynamic> body = {
      "calc_type": selectedMethod.value,
      "is_modified": edited,
      "increasable": int.tryParse(incresableController.text) ?? 0,
      "goal_year": int.tryParse(yearController.text) ?? 0,
      "is_future": isFuture.value,
    };

    if (isFuture.value) {
      final List<Map<String, dynamic>> futureList = [];
      for (var item in futureCapacities) {
        final y = int.tryParse(item.yearController.text.trim());
        final p = num.tryParse(item.productionController.text.trim());
        if (y != null && p != null) {
          futureList.add({
            "future_year": y,
            "future_production": p,
          });
        }
      }
      body["future_years_capacity"] = futureList;
    }

    for (var type in allTypes) {
      final value = textControllers[type.placeTypeId]?.text;
      if (value != null && value.isNotEmpty) {
        body[type.placeTypeId.toString()] = int.parse(value);
      }
    }

    return body;
  }
```
