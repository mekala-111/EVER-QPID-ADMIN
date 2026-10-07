class HostLikesResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final LikesData? data;

  HostLikesResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostLikesResponse.fromJson(Map<String, dynamic> json) {
    return HostLikesResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? LikesData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class LikesData {
  final List<LikeModel>? likes;

  LikesData({this.likes});

  factory LikesData.fromJson(Map<String, dynamic> json) {
    return LikesData(
      likes: json['likes'] != null
          ? List<LikeModel>.from(
              json['likes'].map((x) => LikeModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes?.map((x) => x.toJson()).toList(),
    };
  }
}

class LikeModel {
  final String? id;
  final bool? documentStatus;
  final FromUser? fromUserId;
  final String? toUserId;
  final String? createdUser;
  final DateTime? createdAt;
  final String? updatedUser;
  final DateTime? updatedAt;
  final bool? isSuperLike;
  final int? v;
  final bool? isLikedBack; // ← NEW

  LikeModel({
    this.id,
    this.documentStatus,
    this.fromUserId,
    this.toUserId,
    this.createdUser,
    this.createdAt,
    this.updatedUser,
    this.updatedAt,
    this.isSuperLike,
    this.v,
    this.isLikedBack, // ← NEW
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['_id'],
      documentStatus: json['documentStatus'],
      fromUserId: json['fromUserId'] != null
          ? FromUser.fromJson(json['fromUserId'])
          : null,
      toUserId: json['toUserId'],
      createdUser: json['createdUser'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedUser: json['updatedUser'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSuperLike: json['isSuperLike'],
      v: json['__v'],
      isLikedBack: json['isLikedBack'], // ← NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'documentStatus': documentStatus,
      'fromUserId': fromUserId?.toJson(),
      'toUserId': toUserId,
      'createdUser': createdUser,
      'createdAt': createdAt?.toIso8601String(),
      'updatedUser': updatedUser,
      'updatedAt': updatedAt?.toIso8601String(),
      'isSuperLike': isSuperLike,
      '__v': v,
      'isLikedBack': isLikedBack, // ← NEW
    };
  }
}

class FromUser {
  final String? id;
  final String? fullName;
  final String? gender;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final int? age;

  FromUser({
    this.id,
    this.fullName,
    this.gender,
    this.profileImageUrl,
    this.dateOfBirth,
    this.age,
  });

  factory FromUser.fromJson(Map<String, dynamic> json) {
    return FromUser(
      id: json['_id'],
      fullName: json['fullName'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'age': age,
    };
  }
}
