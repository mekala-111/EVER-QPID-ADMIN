class UserProfile {
  final String id;
  final bool documentStatus;

  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String profileImageUrl;
  final String gender;
  final DateTime? dateOfBirth;
  final String aboutMe;

  // New lifestyle fields
  final String zodiacSign;
  final String alcoholConsumption;
  final String smokingHabit;
  final String workoutFrequency;

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
  final List<dynamic> fcmTokens;
  final List<dynamic> hiddenContacts;

  final String subscribedPlanStatus;
  final ClanActivity? clanActivity;
  final bool isHostProfile;

  final dynamic createdUser;
  final DateTime? createdAt;
  final dynamic updatedUser;
  final DateTime? updatedAt;

  final bool isVerified;
  final bool adminReport;

  final int verificationIdNumber;
  final String verificationIdType;
  final String verificationImageUrl;

  final String deleteReason;
  final String feedBack;
  final bool isPaused;
  final List<Note> notes;

  final bool unSubscribeSMS;
  final bool unSubscribeEmail;

  final dynamic assignedEmployee;
  final dynamic createdByAdmin;
  final dynamic subscriptionId;

  final bool isOnline;
  final DateTime? lastActive;
  final bool isActive;

  final DateTime? date;
  final bool isBlocked;
  final int version;

  UserProfile({
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
    required this.zodiacSign,
    required this.alcoholConsumption,
    required this.smokingHabit,
    required this.workoutFrequency,
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
    required this.fcmTokens,
    required this.hiddenContacts,
    required this.subscribedPlanStatus,
    this.clanActivity,
    required this.isHostProfile,
    this.createdUser,
    required this.createdAt,
    this.updatedUser,
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
    required this.isBlocked,
    required this.version,
  });

  int get age {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['countryCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      aboutMe: json['aboutMe'] ?? '',
      zodiacSign: json['zodiacSign'] ?? '',
      alcoholConsumption: json['alcoholConsumption'] ?? '',
      smokingHabit: json['smokingHabit'] ?? '',
      workoutFrequency: json['workoutFrequency'] ?? '',
      location: Location.fromJson(json['location']),
      homeLocation: Location.fromJson(json['homeLocation']),
      workLocation: Location.fromJson(json['workLocation']),
      studyLocation: Location.fromJson(json['studyLocation']),
      questLocation: Location.fromJson(json['questLocation']),
      locationString: json['locationString'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'] ?? '',
      religion: json['religion'] ?? '',
      height: json['height'] == null
          ? 0
          : (json['height'] is int
              ? json['height']
              : int.tryParse(json['height'].toString()) ?? 0),
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
      fcmTokens: json['fcmTokens'] ?? [],
      hiddenContacts: json['hiddenContacts'] ?? [],
      subscribedPlanStatus: json['subscribedPlanStatus'] ?? '',
      clanActivity: json['clanActivity'] != null
          ? ClanActivity.fromJson(json['clanActivity'])
          : null,
      isHostProfile: json['isHostProfile'] ?? false,
      createdUser: json['createdUser'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedUser: json['updatedUser'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isVerified: json['isVerified'] ?? false,
      adminReport: json['adminReport'] ?? false,
      verificationIdNumber: json['verificationIdNumber'] ?? 0,
      verificationIdType: json['verificationIdType'] ?? '',
      verificationImageUrl: json['verificationImageUrl'] ?? '',
      deleteReason: json['deleteReason'] ?? '',
      feedBack: json['feedBack'] ?? '',
      isPaused: json['isPaused'] ?? false,
      notes: json['notes'] != null
          ? (json['notes'] as List)
              .map((e) => Note.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      unSubscribeSMS: json['unSubscribeSMS'] ?? false,
      unSubscribeEmail: json['unSubscribeEmail'] ?? false,
      assignedEmployee: json['assignedEmployee'],
      createdByAdmin: json['createdByAdmin'],
      subscriptionId: json['subscriptionId'],
      isOnline: json['isOnline'] ?? false,
      lastActive: json['lastActive'] != null
          ? DateTime.tryParse(json['lastActive'])
          : null,
      isActive: json['isActive'] ?? true,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      isBlocked: json['isBlocked'] ?? false,
      version: json['__v'] ?? 0,
    );
  }
}

class Note {
  final String? id;
  final String? note;
  final String? addedBy;
  final DateTime? createdAt;

  Note({
    this.id,
    this.note,
    this.addedBy,
    this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      note: json['note'],
      addedBy: json['addedBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'note': note,
      'addedBy': addedBy,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class ClanActivity {
  final dynamic home;
  final dynamic work;
  final dynamic study;
  final dynamic quest;

  ClanActivity({
    this.home,
    this.work,
    this.study,
    this.quest,
  });

  factory ClanActivity.fromJson(Map<String, dynamic> json) {
    return ClanActivity(
      home: json['home'],
      work: json['work'],
      study: json['study'],
      quest: json['quest'],
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

  factory Location.fromJson(Map<String, dynamic>? json) {
    return Location(
      type: json?['type'] ?? 'Point',
      coordinates: json?['coordinates'] != null
          ? List<double>.from(
              json!['coordinates'].map((e) => (e ?? 0).toDouble()))
          : [],
      city: json?['city'] ?? '',
      state: json?['state'] ?? '',
    );
  }
}

class SideProfileDetails {
  final String fullName;
  final DateTime? joinedDate;
  final DateTime? lastActive;
  final String phoneNo;
  final String email;
  final bool isVerified;
  final bool isSubscribed;
  final int totalMatches;
  final int totalSpend;
  final int openTickets;
  final DateTime? lastChatOn;

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
      joinedDate: json['joinedDate'] != null
          ? DateTime.tryParse(json['joinedDate'])
          : null,
      lastActive: json['lastActive'] != null
          ? DateTime.tryParse(json['lastActive'])
          : null,
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      totalMatches: json['totalMatches'] ?? 0,
      totalSpend: json['totalSpend'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      lastChatOn: json['lastChatOn'] != null
          ? DateTime.tryParse(json['lastChatOn'])
          : null,
    );
  }
}
