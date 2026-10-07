class HostDetailsResponse {
  final bool status;
  final int statusCode;
  final String message;
  final HostDetailsData data;

  HostDetailsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HostDetailsResponse.fromJson(Map<String, dynamic> json) {
    return HostDetailsResponse(
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: HostDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class HostDetailsData {
  final UserProfile userProfile;
  final SideProfileDetails sideProfileDetails;

  HostDetailsData({
    required this.userProfile,
    required this.sideProfileDetails,
  });

  factory HostDetailsData.fromJson(Map<String, dynamic> json) {
    return HostDetailsData(
      userProfile: UserProfile.fromJson(json['userProfile'] ?? {}),
      sideProfileDetails:
          SideProfileDetails.fromJson(json['sideProfileDetails'] ?? {}),
    );
  }
}

class UserProfile {
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

  final GeoLocation location;
  final GeoLocation homeLocation;
  final GeoLocation workLocation;
  final GeoLocation studyLocation;

  final List<dynamic> questLocations;
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

  final bool isHostProfile;
  final bool isVerified;
  final bool adminReport;
  final bool isPaused;
  final bool unSubscribeSMS;
  final bool unSubscribeEmail;

  final AssignedEmployee? assignedEmployee;

  final bool isOnline;
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.location,
    required this.homeLocation,
    required this.workLocation,
    required this.studyLocation,
    required this.questLocations,
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
    required this.isVerified,
    required this.adminReport,
    required this.isPaused,
    required this.unSubscribeSMS,
    required this.unSubscribeEmail,
    required this.assignedEmployee,
    required this.isOnline,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['countryCode'] ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      location: GeoLocation.fromJson(json['location']),
      homeLocation: GeoLocation.fromJson(json['homeLocation']),
      workLocation: GeoLocation.fromJson(json['workLocation']),
      studyLocation: GeoLocation.fromJson(json['studyLocation']),
      questLocations: json['questLocations'] ?? [],
      locationString: json['locationString'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      relationshipGoals: List<String>.from(json['relationshipGoals'] ?? []),
      relationshipStatus: json['relationshipStatus'] ?? '',
      religion: json['religion'] ?? '',
      height: json['height'] ?? '',
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
      isVerified: json['isVerified'] ?? false,
      adminReport: json['adminReport'] ?? false,
      isPaused: json['isPaused'] ?? false,
      unSubscribeSMS: json['unSubscribeSMS'] ?? false,
      unSubscribeEmail: json['unSubscribeEmail'] ?? false,
      assignedEmployee: json['assignedEmployee'] != null
          ? AssignedEmployee.fromJson(json['assignedEmployee'])
          : null,
      isOnline: json['isOnline'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class GeoLocation {
  final String type;
  final List<double> coordinates;

  GeoLocation({
    required this.type,
    required this.coordinates,
  });

  factory GeoLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return GeoLocation(type: 'Point', coordinates: [0, 0]);
    }

    return GeoLocation(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(
        (json['coordinates'] ?? [0, 0]).map((e) => (e as num).toDouble()),
      ),
    );
  }
}

class AssignedEmployee {
  final String id;
  final String name;

  AssignedEmployee({
    required this.id,
    required this.name,
  });

  factory AssignedEmployee.fromJson(Map<String, dynamic> json) {
    return AssignedEmployee(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SideProfileDetails {
  final String fullName;
  final DateTime joinedDate;
  final DateTime? lastActive;
  final String phoneNo;
  final String email;
  final String? assignedEmployeeName;
  final String status;
  final bool isVerified;
  final bool isSubscribed;
  final int totalMatches;
  final int totalChats;
  final DateTime? lastChatOn;
  final int totalSpend;
  final int openTickets;

  SideProfileDetails({
    required this.fullName,
    required this.joinedDate,
    this.lastActive,
    required this.phoneNo,
    required this.email,
    this.assignedEmployeeName,
    required this.status,
    required this.isVerified,
    required this.isSubscribed,
    required this.totalMatches,
    required this.totalChats,
    this.lastChatOn,
    required this.totalSpend,
    required this.openTickets,
  });

  factory SideProfileDetails.fromJson(Map<String, dynamic> json) {
    return SideProfileDetails(
      fullName: json['fullName'] ?? '',
      joinedDate: DateTime.parse(json['joinedDate']),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
      phoneNo: json['phoneNo']?.toString() ?? '',
      email: json['email'] ?? '',
      assignedEmployeeName: json['assignedEmployeeName'],
      status: json['status'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      totalMatches: json['totalMatches'] ?? 0,
      totalChats: json['totalChats'] ?? 0,
      lastChatOn: json['lastChatOn'] != null
          ? DateTime.parse(json['lastChatOn'])
          : null,
      totalSpend: json['totalSpend'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
    );
  }
}
