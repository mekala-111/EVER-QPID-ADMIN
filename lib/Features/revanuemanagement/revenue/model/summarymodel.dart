class RevenueSummary {
  final int totalRevenue;
  final int averageRevenuePerUser;
  final int activePlansTotalAmount;

  RevenueSummary({
    required this.totalRevenue,
    required this.averageRevenuePerUser,
    required this.activePlansTotalAmount,
  });

  factory RevenueSummary.fromJson(Map<String, dynamic> json) {
    return RevenueSummary(
      totalRevenue: json['totalRevenue'] ?? 0,
      averageRevenuePerUser: json['averageRevenuePerUser'] ?? 0,
      activePlansTotalAmount: json['activePlansTotalAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'averageRevenuePerUser': averageRevenuePerUser,
      'activePlansTotalAmount': activePlansTotalAmount,
    };
  }
}
