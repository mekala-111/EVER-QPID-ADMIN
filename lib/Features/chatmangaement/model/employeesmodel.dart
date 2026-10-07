class EmployeeResponse {
  final EmployeeData? data;

  EmployeeResponse({this.data});

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeResponse(
      data: json['data'] != null ? EmployeeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class EmployeeData {
  final List<Employee>? employees;

  EmployeeData({this.employees});

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      employees: json['employees'] != null
          ? List<Employee>.from(
              json['employees'].map((e) => Employee.fromJson(e)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employees': employees?.map((e) => e.toJson()).toList(),
    };
  }
}

class Employee {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? authorityLevel;
  final String? password;
  final String? otp;
  final String? otpExpiry;
  final String? createdByAdmin;
  final bool? documentStatus;
  final String? updatedUser;
  final String? updatedAt;
  final String? createdAt;
  final int? version;

  Employee({
    this.id,
    this.name,
    this.email,
    this.role,
    this.authorityLevel,
    this.password,
    this.otp,
    this.otpExpiry,
    this.createdByAdmin,
    this.documentStatus,
    this.updatedUser,
    this.updatedAt,
    this.createdAt,
    this.version,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      authorityLevel: json['authorityLevel'],
      password: json['password'],
      otp: json['otp'],
      otpExpiry: json['otpExpiry'],
      createdByAdmin: json['createdByAdmin'],
      documentStatus: json['documentStatus'],
      updatedUser: json['updatedUser'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'authorityLevel': authorityLevel,
      'password': password,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'createdByAdmin': createdByAdmin,
      'documentStatus': documentStatus,
      'updatedUser': updatedUser,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      '__v': version,
    };
  }
}
