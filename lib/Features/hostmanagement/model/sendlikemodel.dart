class SentLikesResponse {
  final SentLikesData? data;

  SentLikesResponse({this.data});

  factory SentLikesResponse.fromJson(Map<String, dynamic> json) {
    return SentLikesResponse(
      data: json['data'] != null ? SentLikesData.fromJson(json['data']) : null,
    );
  }
}

class SentLikesData {
  final List<SentLikeUser> sentLikes;
  final int totalCount;
  final bool hasNext;

  SentLikesData({
    required this.sentLikes,
    required this.totalCount,
    required this.hasNext,
  });

  factory SentLikesData.fromJson(Map<String, dynamic> json) {
    return SentLikesData(
      sentLikes: (json['sentLikes'] as List<dynamic>? ?? [])
          .map((e) => SentLikeUser.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }
}

class SentLikeUser {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String profileImageUrl;

  SentLikeUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.profileImageUrl,
  });

  factory SentLikeUser.fromJson(Map<String, dynamic> json) {
    return SentLikeUser(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
