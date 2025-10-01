class ReportBranch {
  final String branchName;
    final String? techname;
        final String? stationname;

  final int month;
  final int year;
    final String? precent;

  final double totalBill;
  final double totalChlorine;
  final double totalLiquidAlum;
  final double totalPower;
  final double totalSolidAlum;
  final double totalWater;

  ReportBranch({
    this.precent,
    required this.branchName,
    required this.month,
    required this.year,
    required this.totalBill,
    required this.totalChlorine,
    this.techname,
    this.stationname,
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
      stationname: json['station_name']??"",
      year: json['year']??0,
      precent: json["percent"]??"",
      totalBill: (json['total_bill']??0 as num).toDouble(),
      totalChlorine: (json['total_chlorine']??0 as num).toDouble(),
      totalLiquidAlum: (json['total_liquid_alum']??0 as num).toDouble(),
      totalPower: (json['total_power']??0 as num).toDouble(),
      totalSolidAlum: (json['total_solid_alum']??0 as num).toDouble(),
      totalWater: (json['total_water']??0 as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'month': month,
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
