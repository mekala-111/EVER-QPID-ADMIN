class PlansResponse {
  final List<Plan> plans;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool hasNext;

  PlansResponse({
    required this.plans,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.hasNext,
  });

  factory PlansResponse.fromJson(Map<String, dynamic> json) {
    return PlansResponse(
      plans: (json['plans'] as List).map((e) => Plan.fromJson(e)).toList(),
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "plans": plans.map((e) => e.toJson()).toList(),
      "totalCount": totalCount,
      "currentPage": currentPage,
      "pageSize": pageSize,
      "hasNext": hasNext,
    };
  }
}

class Plan {
  final String id;
  final String planName;
  final int planAmount;
  final int commentCount;
  final bool documentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Plan({
    required this.id,
    required this.planName,
    required this.planAmount,
    required this.commentCount,
    required this.documentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id'] ?? '',
      planName: json['planName'] ?? '',
      planAmount: json['planAmount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      documentStatus: json['documentStatus'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "planName": planName,
      "planAmount": planAmount,
      "commentCount": commentCount,
      "documentStatus": documentStatus,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": v,
    };
  }
}
