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
      groupId: json['group_id'] is int ? json['group_id'] : null,
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
