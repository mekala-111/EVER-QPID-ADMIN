class UserMatchesResponse {
  final String message;
  final MatchesData data;

  UserMatchesResponse({
    required this.message,
    required this.data,
  });

  factory UserMatchesResponse.fromJson(Map<String, dynamic> json) {
    return UserMatchesResponse(
      message: json['message'] ?? '',
      data: MatchesData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MatchesData {
  final List<UserMatch> matches;
  final int totalCount;
  final bool hasNext;

  MatchesData({
    required this.matches,
    required this.totalCount,
    required this.hasNext,
  });

  factory MatchesData.fromJson(Map<String, dynamic> json) {
    return MatchesData(
      matches: (json['matches'] as List<dynamic>? ?? [])
          .map((e) => UserMatch.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matches': matches.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'hasNext': hasNext,
    };
  }
}

class UserMatch {
  final String id;
  final String fullName;
  final String gender;
  final DateTime? updatedAt;

  UserMatch({
    required this.id,
    required this.fullName,
    required this.gender,
    this.updatedAt,
  });

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    return UserMatch(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'gender': gender,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
