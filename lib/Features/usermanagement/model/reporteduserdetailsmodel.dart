class ReportedUserDetailsResponse {
  final User user;
  final List<Report> reports;
  final SideProfileDetails sideProfileDetails;

  ReportedUserDetailsResponse({
    required this.user,
    required this.reports,
    required this.sideProfileDetails,
  });

  factory ReportedUserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ReportedUserDetailsResponse(
      user: User.fromJson(json['user']),
      reports:
          (json['reports'] as List).map((e) => Report.fromJson(e)).toList(),
      sideProfileDetails:
          SideProfileDetails.fromJson(json['sideProfileDetails']),
    );
  }
}

class User {
  final String id;
  final bool documentStatus;
  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String profileImageUrl;
  final String gender;
  final String dateOfBirth;
  final String aboutMe;
  final String locationString;
  final double lat;
  final double lng;
  final List<String> relationshipGoals;
  final String relationshipStatus;
  final String religion;
  final String height;
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
  final bool isVerified;
  final bool isOnline;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<String> profilePhotos;
  final String zodiacSign;
  final String alcoholConsumption;
  final String smokingHabit;
  final String workoutFrequency;

  User({
    required this.id,
    required this.documentStatus,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
    required this.profileImageUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.aboutMe,
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
    required this.isVerified,
    required this.isOnline,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePhotos,
    required this.zodiacSign,
    required this.alcoholConsumption,
    required this.smokingHabit,
    required this.workoutFrequency,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Parse coordinates from location object if available
    double latitude = (json['lat'] ?? 0).toDouble();
    double longitude = (json['lng'] ?? 0).toDouble();

    // If location object exists, use those coordinates
    if (json['location'] != null && json['location']['coordinates'] != null) {
      final coords = json['location']['coordinates'] as List;
      if (coords.length >= 2) {
        longitude = (coords[0] ?? 0).toDouble();
        latitude = (coords[1] ?? 0).toDouble();
      }
    }

    return User(
      id: json['_id'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['countryCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      locationString: json['locationString'] ?? '',
      lat: latitude,
      lng: longitude,
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'] ?? '',
      religion: json['religion'] ?? '',
      height: json['height']?.toString() ?? '',
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
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      profilePhotos: List<String>.from(json['profilePhotos'] ?? []),
      zodiacSign: json['zodiacSign'] ?? '',
      alcoholConsumption: json['alcoholConsumption'] ?? '',
      smokingHabit: json['smokingHabit'] ?? '',
      workoutFrequency: json['workoutFrequency'] ?? '',
    );
  }
}

class Report {
  final String id;
  final Reporter reporter;
  final String reported;
  final String reason;
  final String warningLevel;
  final int attemptsLeft;
  final String status;
  final bool documentStatus;
  final String createdAt;
  final String updatedAt;

  Report({
    required this.id,
    required this.reporter,
    required this.reported,
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
      reporter: Reporter.fromJson(json['reporter'] ?? {}),
      reported: json['reported'] ?? '',
      reason: json['reason'] ?? '',
      warningLevel: json['warningLevel'] ?? '',
      attemptsLeft: json['attemptsLeft'] ?? 0,
      status: json['status'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Reporter {
  final String id;
  final String fullName;
  final String email;

  Reporter({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory Reporter.fromJson(Map<String, dynamic> json) {
    return Reporter(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class SideProfileDetails {
  final String fullName;
  final String joinedDate;
  final String? lastActive;
  final String phoneNo;
  final String email;
  final bool isVerified;
  final bool isSubscribed;
  final int totalMatches;
  final int totalSpend;
  final int openTickets;
  final String lastChatOn;

  SideProfileDetails({
    required this.fullName,
    required this.joinedDate,
    required this.lastActive,
    required this.phoneNo,
    required this.email,
    required this.isVerified,
    required this.isSubscribed,
    required this.totalMatches,
    required this.totalSpend,
    required this.openTickets,
    required this.lastChatOn,
  });

  factory SideProfileDetails.fromJson(Map<String, dynamic> json) {
    return SideProfileDetails(
      fullName: json['fullName'] ?? '',
      joinedDate: json['joinedDate'] ?? '',
      lastActive: json['lastActive'],
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      totalMatches: json['totalMatches'] ?? 0,
      totalSpend: json['totalSpend'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      lastChatOn: json['lastChatOn'] ?? '',
    );
  }
}
