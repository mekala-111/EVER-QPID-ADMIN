class UsersResponse {
  final List<User> users;
  final bool hasNext;
  final int totalCount;
  final int totalUsers;
  final int totalActiveUsers;
  final int newSignupsThisMonth;
  final int totalMaleUsers;
  final int totalFemaleUsers;
  final int totalOtherUsers;

  UsersResponse({
    required this.users,
    required this.hasNext,
    required this.totalCount,
    required this.totalUsers,
    required this.totalActiveUsers,
    required this.newSignupsThisMonth,
    required this.totalMaleUsers,
    required this.totalFemaleUsers,
    required this.totalOtherUsers,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List<dynamic>? ?? [])
          .map((e) => User.fromJson(e))
          .toList(),
      hasNext: json['hasNext'] ?? false,
      totalCount: json['totalCount'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      totalActiveUsers: json['totalActiveUsers'] ?? 0,
      newSignupsThisMonth: json['newSignupsThisMonth'] ?? 0,
      totalMaleUsers: json['totalMaleUsers'] ?? 0,
      totalFemaleUsers: json['totalFemaleUsers'] ?? 0,
      totalOtherUsers: json['totalOtherUsers'] ?? 0,
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String profileImageUrl;
  final String gender;
  final String dateOfBirth;
  final String aboutMe;
  final Location location;
  final Location homeLocation;
  final Location workLocation;
  final Location studyLocation;
  final Location questLocation;
  final String locationString;
  final double lat;
  final double lng;
  final List<String> relationshipGoals;
  final String relationshipStatus;
  final String religion;
  final int height;
  final List<String> otherLanguages;
  final List<String> interests;
  final String currentProfession;
  final String companyName;
  final String roleInCompany;
  final String employmentType;
  final String education;
  final String collegeName;
  final int graduationYear;
  final bool currentlyStudying;
  final List<String> profilePhotos;
  final String userType;
  final String customerStatus;
  final bool isHostProfile;
  final DateTime createdAt;
  final bool isVerified;
  final bool isPaused;
  final bool isActive;
  final String? lastActive;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
    required this.profileImageUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.aboutMe,
    required this.location,
    required this.homeLocation,
    required this.workLocation,
    required this.studyLocation,
    required this.questLocation,
    required this.locationString,
    required this.lat,
    required this.lng,
    required this.relationshipGoals,
    required this.relationshipStatus,
    required this.religion,
    required this.height,
    required this.otherLanguages,
    required this.interests,
    required this.currentProfession,
    required this.companyName,
    required this.roleInCompany,
    required this.employmentType,
    required this.education,
    required this.collegeName,
    required this.graduationYear,
    required this.currentlyStudying,
    required this.profilePhotos,
    required this.userType,
    required this.customerStatus,
    required this.isHostProfile,
    required this.createdAt,
    required this.isVerified,
    required this.isPaused,
    required this.isActive,
    this.lastActive,
  });

  // Calculate age from dateOfBirth
  int get age {
    if (dateOfBirth.isEmpty) return 0;
    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['countryCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      homeLocation: Location.fromJson(json['homeLocation'] ?? {}),
      workLocation: Location.fromJson(json['workLocation'] ?? {}),
      studyLocation: Location.fromJson(json['studyLocation'] ?? {}),
      questLocation: Location.fromJson(json['questLocation'] ?? {}),
      locationString: json['locationString'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'] ?? '',
      religion: json['religion'] ?? '',
      height: (json['height'] is int)
          ? json['height']
          : (int.tryParse(json['height']?.toString() ?? '') ?? 0),
      otherLanguages: List<String>.from(json['otherLanguages'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      currentProfession: json['currentProfession'] ?? '',
      companyName: json['companyName'] ?? '',
      roleInCompany: json['roleInCompany'] ?? '',
      employmentType: json['employmentType'] ?? '',
      education: json['education'] ?? '',
      collegeName: json['collegeName'] ?? '',
      graduationYear: json['graduationYear'] ?? 0,
      currentlyStudying: json['currentlyStudying'] ?? false,
      profilePhotos: List<String>.from(json['profilePhotos'] ?? []),
      userType: json['userType'] ?? '',
      customerStatus: json['customerStatus'] ?? '',
      isHostProfile: json['isHostProfile'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isVerified: json['isVerified'] ?? false,
      isPaused: json['isPaused'] ?? false,
      isActive: json['isActive'] ?? true,
      lastActive: json['lastActive'],
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String city;
  final String state;

  Location({
    required this.type,
    required this.coordinates,
    this.city = '',
    this.state = '',
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map<double>((e) => (e as num?)?.toDouble() ?? 0.0)
          .toList(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
