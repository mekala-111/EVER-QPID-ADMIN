class UserData {
  final GeoPoint location;
  final AddressLocation homeLocation;
  final AddressLocation workLocation;
  final AddressLocation studyLocation;
  final AddressLocation questLocation;
  final ClanActivity clanActivity;

  final String id;
  final bool documentStatus;
  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String profileImageUrl;
  final String gender;
  final DateTime dateOfBirth;
  final String aboutMe;

  final String locationString;
  final double lat;
  final double lng;

  final List<String> relationshipGoals;
  final String relationshipStatus;
  final String religion;
  final int height;

  final List<dynamic> otherLanguages;
  final List<dynamic> interests;

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

  final List<dynamic> fcmTokens;
  final List<dynamic> hiddenContacts;

  final String subscribedPlanStatus;
  final bool isHostProfile;

  final dynamic createdUser;
  final DateTime createdAt;
  final dynamic updatedUser;
  final DateTime updatedAt;

  final bool isVerified;
  final bool adminReport;

  final int verificationIdNumber;
  final String verificationIdType;
  final String verificationImageUrl;

  final String deleteReason;
  final String feedBack;
  final bool isPaused;
  final List<dynamic> notes; // ✅ Fixed: was String, API returns List

  final bool unSubscribeSMS;
  final bool unSubscribeEmail;

  final dynamic assignedEmployee;
  final dynamic createdByAdmin;
  final dynamic subscriptionId;

  final bool isOnline;
  final DateTime lastActive;
  final bool isActive;

  final DateTime date;
  final int version;

  final Map<String, dynamic> preferences;

  // ✅ New fields from API
  final String zodiacSign;
  final String alcoholConsumption;
  final String smokingHabit;
  final String workoutFrequency;

  UserData({
    required this.location,
    required this.homeLocation,
    required this.workLocation,
    required this.studyLocation,
    required this.questLocation,
    required this.clanActivity,
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
    required this.profilePhotos,
    required this.userType,
    required this.customerStatus,
    required this.fcmTokens,
    required this.hiddenContacts,
    required this.subscribedPlanStatus,
    required this.isHostProfile,
    required this.createdUser,
    required this.createdAt,
    required this.updatedUser,
    required this.updatedAt,
    required this.isVerified,
    required this.adminReport,
    required this.verificationIdNumber,
    required this.verificationIdType,
    required this.verificationImageUrl,
    required this.deleteReason,
    required this.feedBack,
    required this.isPaused,
    required this.notes,
    required this.unSubscribeSMS,
    required this.unSubscribeEmail,
    required this.assignedEmployee,
    required this.createdByAdmin,
    required this.subscriptionId,
    required this.isOnline,
    required this.lastActive,
    required this.isActive,
    required this.date,
    required this.version,
    required this.preferences,
    required this.zodiacSign,
    required this.alcoholConsumption,
    required this.smokingHabit,
    required this.workoutFrequency,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      location: GeoPoint.fromJson(json['location']),
      homeLocation: AddressLocation.fromJson(json['homeLocation']),
      workLocation: AddressLocation.fromJson(json['workLocation']),
      studyLocation: AddressLocation.fromJson(json['studyLocation']),
      questLocation: AddressLocation.fromJson(json['questLocation']),
      clanActivity: ClanActivity.fromJson(json['clanActivity']),
      id: json['_id'],
      documentStatus: json['documentStatus'],
      fullName: json['fullName'],
      email: json['email'],
      countryCode: json['countryCode'],
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      aboutMe: json['aboutMe'] ?? '',
      locationString: json['locationString'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'],
      religion: json['religion'] ?? '',
      height: json['height'] ?? 0,
      otherLanguages: json['otherLanguages'] ?? [],
      interests: json['interests'] ?? [],
      currentProfession: json['currentProfession'] ?? '',
      companyName: json['companyName'] ?? '',
      roleInCompany: json['roleInCompany'] ?? '',
      employmentType: json['employmentType'] ?? '',
      education: json['education'] ?? '',
      collegeName: json['collegeName'] ?? '',
      graduationYear: json['graduationYear'] ?? 0,
      currentlyStudying: json['currentlyStudying'] ?? false,
      profilePhotos: List<String>.from(json['profilePhotos'] ?? []),
      userType: json['userType'],
      customerStatus: json['customerStatus'],
      fcmTokens: json['fcmTokens'] ?? [],
      hiddenContacts: json['hiddenContacts'] ?? [],
      subscribedPlanStatus: json['subscribedPlanStatus'],
      isHostProfile: json['isHostProfile'],
      createdUser: json['createdUser'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedUser: json['updatedUser'],
      updatedAt: DateTime.parse(json['updatedAt']),
      isVerified: json['isVerified'],
      adminReport: json['adminReport'],
      verificationIdNumber: json['verificationIdNumber'] ?? 0,
      verificationIdType: json['verificationIdType'] ?? '',
      verificationImageUrl: json['verificationImageUrl'] ?? '',
      deleteReason: json['deleteReason'] ?? '',
      feedBack: json['feedBack'] ?? '',
      isPaused: json['isPaused'],
      notes: json['notes'] ?? [], // ✅ Fixed: List not String
      unSubscribeSMS: json['unSubscribeSMS'],
      unSubscribeEmail: json['unSubscribeEmail'],
      assignedEmployee: json['assignedEmployee'],
      createdByAdmin: json['createdByAdmin'],
      subscriptionId: json['subscriptionId'],
      isOnline: json['isOnline'],
      lastActive: DateTime.parse(json['lastActive']),
      isActive: json['isActive'],
      date: DateTime.parse(json['date']),
      version: json['__v'],
      preferences: json['preferences'] ?? {},
      zodiacSign: json['zodiacSign'] ?? '', // ✅ New
      alcoholConsumption: json['alcoholConsumption'] ?? '', // ✅ New
      smokingHabit: json['smokingHabit'] ?? '', // ✅ New
      workoutFrequency: json['workoutFrequency'] ?? '', // ✅ New
    );
  }
}

class GeoPoint {
  final String type;
  final List<double> coordinates;

  GeoPoint({
    required this.type,
    required this.coordinates,
  });

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((e) => e.toDouble())),
    );
  }
}

class AddressLocation extends GeoPoint {
  final String city;
  final String state;

  AddressLocation({
    required super.type,
    required super.coordinates,
    required this.city,
    required this.state,
  });

  factory AddressLocation.fromJson(Map<String, dynamic> json) {
    return AddressLocation(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((e) => e.toDouble())),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class ClanActivity {
  final DateTime? home;
  final DateTime? work;
  final DateTime? study;
  final DateTime? quest;

  ClanActivity({
    this.home,
    this.work,
    this.study,
    this.quest,
  });

  factory ClanActivity.fromJson(Map<String, dynamic> json) {
    return ClanActivity(
      home: json['home'] != null ? DateTime.parse(json['home']) : null,
      work: json['work'] != null ? DateTime.parse(json['work']) : null,
      study: json['study'] != null ? DateTime.parse(json['study']) : null,
      quest: json['quest'] != null ? DateTime.parse(json['quest']) : null,
    );
  }
}
