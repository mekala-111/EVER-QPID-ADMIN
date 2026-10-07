class ReportsApiResponse {
  final ReportsData data;

  ReportsApiResponse({
    required this.data,
  });

  factory ReportsApiResponse.fromJson(Map<String, dynamic> json) {
    return ReportsApiResponse(
      data: ReportsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class ReportsData {
  final List<Report> reports;
  final int totalCount;
  final bool hasNext;
  final ReportStats stats;

  ReportsData({
    required this.reports,
    required this.totalCount,
    required this.hasNext,
    required this.stats,
  });

  factory ReportsData.fromJson(Map<String, dynamic> json) {
    return ReportsData(
      reports: (json['reports'] as List<dynamic>)
          .map((e) => Report.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      stats: ReportStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reports': reports.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'hasNext': hasNext,
      'stats': stats.toJson(),
    };
  }
}

class ReportStats {
  final int totalUsers;
  final int activeUsers;
  final int activeMaleUsers;
  final int activeFemaleUsers;
  final int newSignUps;
  final int newMaleSignUps;
  final int newFemaleSignUps;
  final int reportedUsersCount;
  final int reportedMaleAccounts;
  final int reportedFemaleAccounts;

  ReportStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.activeMaleUsers,
    required this.activeFemaleUsers,
    required this.newSignUps,
    required this.newMaleSignUps,
    required this.newFemaleSignUps,
    required this.reportedUsersCount,
    required this.reportedMaleAccounts,
    required this.reportedFemaleAccounts,
  });

  factory ReportStats.fromJson(Map<String, dynamic> json) {
    return ReportStats(
      totalUsers: json['totalUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      activeMaleUsers: json['activeMaleUsers'] ?? 0,
      activeFemaleUsers: json['activeFemaleUsers'] ?? 0,
      newSignUps: json['newSignUps'] ?? 0,
      newMaleSignUps: json['newMaleSignUps'] ?? 0,
      newFemaleSignUps: json['newFemaleSignUps'] ?? 0,
      reportedUsersCount: json['reportedUsersCount'] ?? 0,
      reportedMaleAccounts: json['reportedMaleAccounts'] ?? 0,
      reportedFemaleAccounts: json['reportedFemaleAccounts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'activeMaleUsers': activeMaleUsers,
      'activeFemaleUsers': activeFemaleUsers,
      'newSignUps': newSignUps,
      'newMaleSignUps': newMaleSignUps,
      'newFemaleSignUps': newFemaleSignUps,
      'reportedUsersCount': reportedUsersCount,
      'reportedMaleAccounts': reportedMaleAccounts,
      'reportedFemaleAccounts': reportedFemaleAccounts,
    };
  }
}

class Report {
  final String id;
  final User? reporter; // ✅ nullable — reporter account may be deleted
  final User? reported; // ✅ nullable — reported account may be deleted
  final String reason;
  final String warningLevel;
  final int attemptsLeft;
  final String status;
  final bool documentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    this.reporter,
    this.reported,
    required this.reason,
    required this.warningLevel,
    required this.attemptsLeft,
    required this.status,
    required this.documentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] ?? '',
      reporter: json['reporter'] != null
          ? User.fromJson(json['reporter'] as Map<String, dynamic>)
          : null,
      reported: json['reported'] != null
          ? User.fromJson(json['reported'] as Map<String, dynamic>)
          : null,
      reason: json['reason'] ?? '',
      warningLevel: json['warningLevel'] ?? '',
      attemptsLeft: json['attemptsLeft'] ?? 0,
      status: json['status'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reporter': reporter?.toJson(),
      'reported': reported?.toJson(),
      'reason': reason,
      'warningLevel': warningLevel,
      'attemptsLeft': attemptsLeft,
      'status': status,
      'documentStatus': documentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String email;

  User({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
    };
  }
}
