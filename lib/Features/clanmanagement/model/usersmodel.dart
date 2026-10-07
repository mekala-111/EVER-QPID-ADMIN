class UsersResponse {
  final List<User> users;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final bool hasNext;

  UsersResponse({
    required this.users,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasNext,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List).map((e) => User.fromJson(e)).toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'hasNext': hasNext,
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String gender;
  final String customerStatus;
  final DateTime createdAt;
  final String clanType;
  final Location? location;
  final String city;
  final String state;

  User({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.customerStatus,
    required this.createdAt,
    required this.clanType,
    this.location,
    required this.city,
    required this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      gender: json['gender'] ?? '',
      customerStatus: json['customerStatus'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      clanType: json['clanType'] ?? '',
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'customerStatus': customerStatus,
      'createdAt': createdAt.toIso8601String(),
      'clanType': clanType,
      'location': location?.toJson(),
      'city': city,
      'state': state,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String? title;
  final String? city;
  final String? state;
  final String? id;

  Location({
    required this.type,
    required this.coordinates,
    this.title,
    this.city,
    this.state,
    this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      title: json['title'],
      city: json['city'],
      state: json['state'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'title': title,
      'city': city,
      'state': state,
      '_id': id,
    };
  }
}
