class GuageBill {
  final int? guageBillId;
  final String accountNumber;
  final int billMonth;
  final int billYear;
  final int prevReading;
  final int currentReading;
  final int readingFactor;
  final int powerConsump;

  final double fixedInstallment;
  final double settlements;
  final double stamp;
  final double prevPayments;
  final double rounding;
  final double billTotal;
  final bool isPaid;
  List<double>? ratios;

  GuageBill({
    this.guageBillId,
    required this.accountNumber,
    required this.billMonth,
    required this.billYear,
    required this.prevReading,
    required this.currentReading,
    required this.readingFactor,
    required this.powerConsump,
    this.ratios,
    required this.fixedInstallment,
    required this.settlements,
    required this.stamp,
    required this.prevPayments,
    required this.rounding,
    required this.billTotal,
    required this.isPaid,
  });

  factory GuageBill.fromJson(Map<String, dynamic> json) {
    return GuageBill(
      guageBillId: json['guage_bill_id'],
      accountNumber: json['account_number'],
      billMonth: json['bill_month'],
      billYear: json['bill_year'],
      prevReading: json['prev_reading'],
      currentReading: json['current_reading'],
      readingFactor: json['reading_factor'],
      powerConsump: json['power_consump'],
      ratios: json["percent"],
      fixedInstallment: json['fixed_installment'].toDouble(),
      settlements: json['settlements'].toDouble(),
      stamp: json['stamp'].toDouble(),
      prevPayments: json['prev_payments'].toDouble(),
      rounding: json['rounding'].toDouble(),
      billTotal: json['bill_total'].toDouble(),
      isPaid: json['is_paid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percent': ratios,
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
