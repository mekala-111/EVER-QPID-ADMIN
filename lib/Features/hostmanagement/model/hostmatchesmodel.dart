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
  final String id; // Match ID
  final String userId; // User ID from nested user object
  final String fullName;
  final String gender;
  final DateTime? matchedAt; // Changed from updatedAt to matchedAt

  UserMatch({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.gender,
    this.matchedAt,
  });

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    // Extract user object
    final user = json['user'] as Map<String, dynamic>?;

    return UserMatch(
      id: json['_id'] ?? '', // This is the match ID
      userId: user?['_id'] ?? '', // This is the actual user ID
      fullName: user?['fullName'] ?? 'Unknown',
      gender: user?['gender'] ?? 'Unknown',
      matchedAt: json['matchedAt'] != null
          ? DateTime.tryParse(json['matchedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        '_id': userId,
        'fullName': fullName,
        'gender': gender,
      },
      'matchedAt': matchedAt?.toIso8601String(),
    };
  }
}
