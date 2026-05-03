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
      stationname: json['station_name']??"",
      year: json['year']??0,
      stationnames: json['station_names']??"",
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
