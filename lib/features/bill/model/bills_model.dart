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
