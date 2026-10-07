class HostsResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Hostmodel>? data;

  HostsResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostsResponse.fromJson(Map<String, dynamic> json) {
    return HostsResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? List<Hostmodel>.from(
              json['data'].map((x) => Hostmodel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class Hostmodel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? profileImageUrl;
  final String? gender;
  final bool? isOnline;
  final String? countryCode;
  final String? mobileNumber;
  final String? dateOfBirth;
  final String? aboutMe;
  final String? relationshipStatus;
  final String? religion;
  final int? height;
  final List<String>? otherLanguages;
  final List<String>? interests;
  final String? currentProfession;
  final String? companyName;
  final String? education;
  final String? collegeName;
  final int? graduationYear;
  final bool? currentlyStudying;
  final List<String>? profilePhotos;
  final String? userType;
  final String? customerStatus;
  final bool? isVerified;
  final String? assignedEmployee;
  final String? createdByAdmin;
  final bool? isActive;

  Hostmodel({
    this.id,
    this.fullName,
    this.email,
    this.profileImageUrl,
    this.gender,
    this.isOnline,
    this.countryCode,
    this.mobileNumber,
    this.dateOfBirth,
    this.aboutMe,
    this.relationshipStatus,
    this.religion,
    this.height,
    this.otherLanguages,
    this.interests,
    this.currentProfession,
    this.companyName,
    this.education,
    this.collegeName,
    this.graduationYear,
    this.currentlyStudying,
    this.profilePhotos,
    this.userType,
    this.customerStatus,
    this.isVerified,
    this.assignedEmployee,
    this.createdByAdmin,
    this.isActive,
  });

  factory Hostmodel.fromJson(Map<String, dynamic> json) {
    return Hostmodel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      gender: json['gender'],
      isOnline: json['isOnline'],
      countryCode: json['countryCode'],
      mobileNumber: json['mobileNumber'],
      dateOfBirth: json['dateOfBirth'],
      aboutMe: json['aboutMe'],
      relationshipStatus: json['relationshipStatus'],
      religion: json['religion'],
      height: json['height'],
      otherLanguages: json['otherLanguages'] != null
          ? List<String>.from(json['otherLanguages'])
          : [],
      interests:
          json['interests'] != null ? List<String>.from(json['interests']) : [],
      currentProfession: json['currentProfession'],
      companyName: json['companyName'],
      education: json['education'],
      collegeName: json['collegeName'],
      graduationYear: json['graduationYear'],
      currentlyStudying: json['currentlyStudying'],
      profilePhotos: json['profilePhotos'] != null
          ? List<String>.from(json['profilePhotos'])
          : [],
      userType: json['userType'],
      customerStatus: json['customerStatus'],
      isVerified: json['isVerified'],
      assignedEmployee: json['assignedEmployee'],
      createdByAdmin: json['createdByAdmin'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'gender': gender,
      'isOnline': isOnline,
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'aboutMe': aboutMe,
      'relationshipStatus': relationshipStatus,
      'religion': religion,
      'height': height,
      'otherLanguages': otherLanguages,
      'interests': interests,
      'currentProfession': currentProfession,
      'companyName': companyName,
      'education': education,
      'collegeName': collegeName,
      'graduationYear': graduationYear,
      'currentlyStudying': currentlyStudying,
      'profilePhotos': profilePhotos,
      'userType': userType,
      'customerStatus': customerStatus,
      'isVerified': isVerified,
      'assignedEmployee': assignedEmployee,
      'createdByAdmin': createdByAdmin,
      'isActive': isActive,
    };
  }
}
