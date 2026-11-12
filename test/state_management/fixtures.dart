import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> placeType(int id, {String name = 'Village'}) => {
  'place_type_id': id,
  'place_type_name': name,
  'person_portion_from': 1,
  'person_portion_to': 100,
};
Map<String, dynamic> techBill(int id, {String branch = 'North'}) => {
  'tech_bill_id': id,
  'bill_month': 3,
  'bill_year': 2026,
  'station_id': id + 100,
  'station_name': 'Station $id',
  'technology_id': 5,
  'technology_name': 'Treatment',
  'branch_name': branch,
  'technology_power_consump': 12,
  'technology_bill_total': '25.50',
  'technology_water_amount': 8,
};
Map<String, dynamic> meterBill(int id) => {
  'guage_bill_id': id,
  'account_number': 'M$id',
  'bill_month': 3,
  'bill_year': 2026,
  'power_consump': 12,
  'bill_total': 25.5,
  'is_paid': true,
};
Map<String, dynamic> page(List<dynamic> data, int number) => {
  'data': data,
  'meta': {
    'page': number,
    'per_page': 20,
    'total': 60,
    'total_pages': 3,
    'has_next': number < 3,
    'has_prev': number > 1,
  },
};
http.Response jsonResponse(Object data, {int status = 200}) => http.Response(
  jsonEncode(data),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// Every request stays in memory; no fallback to a real client is possible.
class PendingHttp {
  final requests = <http.Request>[];
  final responses = <Completer<http.Response>>[];
  late final client = MockClient((request) {
    requests.add(request);
    final response = Completer<http.Response>();
    responses.add(response);
    return response.future;
  });
  Future<void> started(int count) async {
    for (var i = 0; i < 100 && requests.length < count; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    if (requests.length != count) throw StateError('Expected $count requests');
  }

  void finish(int index, Object data, {int status = 200}) =>
      responses[index].complete(jsonResponse(data, status: status));
}
