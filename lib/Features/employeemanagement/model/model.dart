// Root response model
class EmployeesResponse {
  final EmployeesData data;

  EmployeesResponse({required this.data});

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    return EmployeesResponse(
      data: EmployeesData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

// Data wrapper
class EmployeesData {
  final List<Employee> employees;
  final int totalCount;
  final bool hasNext;

  EmployeesData({
    required this.employees,
    required this.totalCount,
    required this.hasNext,
  });

  factory EmployeesData.fromJson(Map<String, dynamic> json) {
    return EmployeesData(
      employees:
          (json['employees'] as List).map((e) => Employee.fromJson(e)).toList(),
      totalCount: json['totalCount'],
      hasNext: json['hasNext'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employees': employees.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'hasNext': hasNext,
    };
  }
}

// Employee model
class Employee {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;

  final String authorityLevel;
  final String createdByAdmin;
  final DateTime createdAt;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.authorityLevel,
    required this.createdByAdmin,
    required this.createdAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      authorityLevel: json['authorityLevel'],
      createdByAdmin: json['createdByAdmin'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'authorityLevel': authorityLevel,
      'createdByAdmin': createdByAdmin,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
