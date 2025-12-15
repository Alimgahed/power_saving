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
