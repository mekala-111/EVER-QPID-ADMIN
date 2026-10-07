class HostsResponse {
  final HostsData? data;

  HostsResponse({this.data});

  factory HostsResponse.fromJson(Map<String, dynamic> json) {
    return HostsResponse(
      data: json['data'] != null ? HostsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class HostsData {
  final List<Hostmodel>? hosts;
  final int? totalCount;
  final bool? hasNext;

  HostsData({
    this.hosts,
    this.totalCount,
    this.hasNext,
  });

  factory HostsData.fromJson(Map<String, dynamic> json) {
    return HostsData(
      hosts: json['hosts'] != null
          ? List<Hostmodel>.from(
              json['hosts'].map((x) => Hostmodel.fromJson(x)),
            )
          : [],
      totalCount: json['totalCount'],
      hasNext: json['hasNext'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hosts': hosts?.map((x) => x.toJson()).toList(),
      'totalCount': totalCount,
      'hasNext': hasNext,
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

  Hostmodel({
    this.id,
    this.fullName,
    this.email,
    this.profileImageUrl,
    this.gender,
    this.isOnline,
  });

  factory Hostmodel.fromJson(Map<String, dynamic> json) {
    return Hostmodel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      gender: json['gender'],
      isOnline: json['isOnline'],
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
    };
  }
}
