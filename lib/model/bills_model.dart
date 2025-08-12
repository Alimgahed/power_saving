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
  });

  factory GuageBill.fromJson(Map<String, dynamic> json) {
    return GuageBill(
      delayMonth: json[""],
      delayYear: json["delay_year"],
      settlementsratio: json["settlement_qty"],
      guageBillId: json['guage_bill_id'],
      accountNumber: json['account_number'],
      billMonth: json['bill_month'],
      billYear: json['bill_year'],
      prevReading: json['prev_reading'],
      currentReading: json['current_reading'],
      readingFactor: json['reading_factor'],
      powerConsump: json['power_consump'],
      percentMoney: json["percent_money"],
      percentPower: json["percent_power"],
      fixedInstallment: json['fixed_installment'],
      settlements: json['settlements'].toDouble(),
      stamp: json['stamp'].toDouble(),
      prevPayments: json['prev_payments'].toDouble(),
      rounding: json['rounding'].toDouble(),
      billTotal: json['bill_total'].toDouble(),
      isPaid: json['is_paid'],
      notes: json["notes"],
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
    };
  }
}
