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
