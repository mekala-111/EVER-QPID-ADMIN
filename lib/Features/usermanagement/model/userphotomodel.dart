class UserPhotosResponse {
  final bool status;
  final List<String> photos;

  UserPhotosResponse({
    required this.status,
    required this.photos,
  });

  factory UserPhotosResponse.fromJson(Map<String, dynamic> json) {
    return UserPhotosResponse(
      status: json['status'] ?? false,
      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'photos': photos,
    };
  }
}
