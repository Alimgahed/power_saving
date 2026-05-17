import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Colors
  static const Color primaryColor = Color(0xFF1E40AF);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  
  // Dimensions
  static const double defaultPadding = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double iconSize = 24.0;
  
  // Text Styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Shadow
  static BoxShadow get defaultShadow => BoxShadow(
    color: Colors.black.withOpacity(0.08),
    spreadRadius: 0,
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
  
  // User Group IDs
  static const int adminGroupId = 1;
  static const int technicalGroupId = 2;
  static const int accountingGroupId = 3;
  static const int chemicalGroupId = 4;
  
  // Routes
  static const String homeRoute = '/';
  static const String loginRoute = '/Login';
  static const String stationsRoute = '/Stations';
  static const String countersRoute = '/Countrts';
  static const String technologyRoute = '/Technology';
  static const String relationsRoute = '/Relations';
  static const String chemicalsRoute = '/Chemicals';
  static const String techBillsRoute = '/techbills';
  static const String predictionsRoute = './Predictions';
  static const String billsRoute = './bills';
  static const String techBillRoute = './techBill';
  static const String chartsRoute = './Charts';
  static const String reportsRoute = './Reports';
  static const String newUserRoute = '/NewUser';
  static const String allUsersRoute = '/all_users';
  static const String changePasswordRoute = '/change_password';
  static const String analysisRoute = '/analysis';
  
  // Messages
  static const String loginRequiredMessage = "برجاء تسجيل دخول";
  static const String noDataAvailableMessage = "لا توجد بيانات متاحة";
  static const String noDataFoundMessage = "لم يتم العثور على أي بيانات";
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration loadingAnimationDuration = Duration(milliseconds: 500);
}

/// Home screen typography — larger sizes for readability.
class HomeTypography {
  HomeTypography._();

  static const double greeting = 32;
  static const double greetingSub = 16;
  static const double appBarTitle = 22;
  static const double statTitle = 16;
  static const double statValue = 24;
  static const double cardTitle = 17;
  static const double cardSubtitle = 13;
  static const double body = 16;
  static const double bodySmall = 14;
  static const double caption = 13;
  static const double badge = 12;
  static const double tab = 14;
  static const double insightLabel = 16;
  static const double insightCount = 15;
  static const double resourceTitle = 17;
  static const double resourceValue = 17;
  static const double resourceSub = 14;
  static const double emptyTitle = 18;
  static const double emptyDesc = 15;
  static const double consumptionTitle = 18;
  static const double consumptionSub = 13;
  static const double consumptionLabel = 13;
  static const double consumptionValue = 15;
  static const double consumptionAction = 15;
}

/// User role access helper
class UserRoleHelper {
  // Private constructor
  UserRoleHelper._();
  
  /// Check if user has access based on allowed groups
  static bool hasAccess(int? userGroupId, List<int> allowedGroups) {
    if (userGroupId == null) return false;
    return allowedGroups.contains(userGroupId);
  }
  
  /// Check if user is admin
  static bool isAdmin(int? userGroupId) {
    return userGroupId == AppConstants.adminGroupId;
  }
  
  /// Check if user is technical
  static bool isTechnical(int? userGroupId) {
    return userGroupId == AppConstants.technicalGroupId;
  }
  
  /// Check if user is accounting
  static bool isAccounting(int? userGroupId) {
    return userGroupId == AppConstants.accountingGroupId;
  }
  
  /// Check if user is chemical
  static bool isChemical(int? userGroupId) {
    return userGroupId == AppConstants.chemicalGroupId;
  }
}