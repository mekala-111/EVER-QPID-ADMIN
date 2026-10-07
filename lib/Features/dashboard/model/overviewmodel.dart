class DashboardSummaryModel {
  final int totalUsers;
  final int menUsers;
  final int womenUsers;
  final int revenue;

  DashboardSummaryModel({
    required this.totalUsers,
    required this.menUsers,
    required this.womenUsers,
    required this.revenue,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalUsers: json['totalUsers'] ?? 0,
      menUsers: json['menUsers'] ?? 0,
      womenUsers: json['womenUsers'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'menUsers': menUsers,
      'womenUsers': womenUsers,
      'revenue': revenue,
    };
  }
}
