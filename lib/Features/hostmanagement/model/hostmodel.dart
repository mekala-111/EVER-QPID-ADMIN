class HostsResponse {
  final List<Host> hosts;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final bool hasNext;

  HostsResponse({
    required this.hosts,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.hasNext,
  });

  factory HostsResponse.fromJson(Map<String, dynamic> json) {
    return HostsResponse(
      hosts: (json['hosts'] as List<dynamic>? ?? [])
          .map((e) => Host.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      activeCount: json['activeCount'] ?? 0,
      inactiveCount: json['inactiveCount'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hosts': hosts.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'activeCount': activeCount,
      'inactiveCount': inactiveCount,
      'hasNext': hasNext,
    };
  }
}

class Host {
  final String id;
  final bool documentStatus;
  final String fullName;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String profileImageUrl;
  final String gender;

  final String zodiacSign;
  final String alcoholConsumption;
  final String smokingHabit;
  final String workoutFrequency;

  final String dateOfBirth;
  final String aboutMe;

  final GeoLocation? location;
  final GeoLocation? homeLocation;
  final GeoLocation? workLocation;
  final GeoLocation? studyLocation;

  final ClanActivity? clanActivity;
  final String locationString;
  final double lat;
  final double lng;

  final List<String> relationshipGoals;
  final String relationshipStatus;
  final String religion;
  final num height;
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

  final List<String> fcmTokens;
  final List<String> hiddenContacts;
  final String subscribedPlanStatus;
  final String? subscriptionId;

  final bool isHostProfile;
  final bool isVerified;
  final bool adminReport;
  final bool isPaused;
  final bool unSubscribeSMS;
  final bool unSubscribeEmail;
  final bool isOnline;
  final bool isActive;

  final int age;

  final String createdAt;
  final String updatedAt;
  final String date;
  final String? lastActive;
  final String? createdUser;

  final int verificationIdNumber;
  final String verificationIdType;
  final String verificationImageUrl;
  final String deleteReason;
  final String feedBack;
  final List<dynamic> notes;

  final String assignedEmployeeId;

  Host({
    required this.id,
    required this.documentStatus,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
    required this.profileImageUrl,
    required this.gender,
    required this.zodiacSign,
    required this.alcoholConsumption,
    required this.smokingHabit,
    required this.workoutFrequency,
    required this.dateOfBirth,
    required this.aboutMe,
    this.location,
    this.homeLocation,
    this.workLocation,
    this.studyLocation,
    this.clanActivity,
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
    this.subscriptionId,
    required this.isHostProfile,
    required this.isVerified,
    required this.adminReport,
    required this.isPaused,
    required this.unSubscribeSMS,
    required this.unSubscribeEmail,
    required this.isOnline,
    required this.isActive,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    this.lastActive,
    this.createdUser,
    required this.verificationIdNumber,
    required this.verificationIdType,
    required this.verificationImageUrl,
    required this.deleteReason,
    required this.feedBack,
    required this.notes,
    required this.assignedEmployeeId,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['_id'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['countryCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',
      zodiacSign: json['zodiacSign'] ?? '',
      alcoholConsumption: json['alcoholConsumption'] ?? '',
      smokingHabit: json['smokingHabit'] ?? '',
      workoutFrequency: json['workoutFrequency'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      location: json['location'] != null
          ? GeoLocation.fromJson(json['location'])
          : null,
      homeLocation: json['homeLocation'] != null
          ? GeoLocation.fromJson(json['homeLocation'])
          : null,
      workLocation: json['workLocation'] != null
          ? GeoLocation.fromJson(json['workLocation'])
          : null,
      studyLocation: json['studyLocation'] != null
          ? GeoLocation.fromJson(json['studyLocation'])
          : null,
      clanActivity: json['clanActivity'] != null
          ? ClanActivity.fromJson(json['clanActivity'])
          : null,
      locationString: json['locationString'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'] ?? '',
      religion: json['religion'] ?? '',
      height: json['height'] ?? 0,
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
      fcmTokens: List<String>.from(json['fcmTokens'] ?? []),
      hiddenContacts: List<String>.from(json['hiddenContacts'] ?? []),
      subscribedPlanStatus: json['subscribedPlanStatus'] ?? '',
      subscriptionId: json['subscriptionId'],
      isHostProfile: json['isHostProfile'] ?? false,
      isVerified: json['isVerified'] ?? false,
      adminReport: json['adminReport'] ?? false,
      isPaused: json['isPaused'] ?? false,
      unSubscribeSMS: json['unSubscribeSMS'] ?? false,
      unSubscribeEmail: json['unSubscribeEmail'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isActive: json['isActive'] ?? false,
      age: json['age'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      date: json['date'] ?? '',
      lastActive: json['lastActive'],
      createdUser: json['createdUser'],
      verificationIdNumber: json['verificationIdNumber'] ?? 0,
      verificationIdType: json['verificationIdType'] ?? '',
      verificationImageUrl: json['verificationImageUrl'] ?? '',
      deleteReason: json['deleteReason'] ?? '',
      feedBack: json['feedBack'] ?? '',
      notes: json['notes'] ?? [],
      assignedEmployeeId: json['assignedEmployee'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'documentStatus': documentStatus,
      'fullName': fullName,
      'email': email,
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'profileImageUrl': profileImageUrl,
      'gender': gender,
      'zodiacSign': zodiacSign,
      'alcoholConsumption': alcoholConsumption,
      'smokingHabit': smokingHabit,
      'workoutFrequency': workoutFrequency,
      'dateOfBirth': dateOfBirth,
      'aboutMe': aboutMe,
      'location': location?.toJson(),
      'homeLocation': homeLocation?.toJson(),
      'workLocation': workLocation?.toJson(),
      'studyLocation': studyLocation?.toJson(),
      'clanActivity': clanActivity?.toJson(),
      'locationString': locationString,
      'lat': lat,
      'lng': lng,
      'relationshipGoals': relationshipGoals,
      'relationshipStatus': relationshipStatus,
      'religion': religion,
      'height': height,
      'otherLanguages': otherLanguages,
      'interests': interests,
      'currentProfession': currentProfession,
      'companyName': companyName,
      'roleInCompany': roleInCompany,
      'employmentType': employmentType,
      'education': education,
      'collegeName': collegeName,
      'graduationYear': graduationYear,
      'currentlyStudying': currentlyStudying,
      'profilePhotos': profilePhotos,
      'userType': userType,
      'customerStatus': customerStatus,
      'fcmTokens': fcmTokens,
      'hiddenContacts': hiddenContacts,
      'subscribedPlanStatus': subscribedPlanStatus,
      'subscriptionId': subscriptionId,
      'isHostProfile': isHostProfile,
      'isVerified': isVerified,
      'adminReport': adminReport,
      'isPaused': isPaused,
      'unSubscribeSMS': unSubscribeSMS,
      'unSubscribeEmail': unSubscribeEmail,
      'isOnline': isOnline,
      'isActive': isActive,
      'age': age,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'date': date,
      'lastActive': lastActive,
      'createdUser': createdUser,
      'verificationIdNumber': verificationIdNumber,
      'verificationIdType': verificationIdType,
      'verificationImageUrl': verificationImageUrl,
      'deleteReason': deleteReason,
      'feedBack': feedBack,
      'notes': notes,
      'assignedEmployee': assignedEmployeeId,
    };
  }
}

class GeoLocation {
  final String type;
  final List<double> coordinates;
  final String? city;
  final String? state;

  GeoLocation({
    required this.type,
    required this.coordinates,
    this.city,
    this.state,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      type: json['type'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] ?? []).map((e) => (e as num).toDouble()),
      ),
      city: json['city'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
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

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'work': work,
      'study': study,
      'quest': quest,
    };
  }
}
