import 'dart:convert';

RevenueChartModel revenueChartModelFromJson(String str) =>
    RevenueChartModel.fromJson(json.decode(str));

class RevenueChartModel {
  final bool status;
  final int statusCode;
  final String message;
  final List<TransactionChartData> data;

  RevenueChartModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RevenueChartModel.fromJson(Map<String, dynamic> json) {
    return RevenueChartModel(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: List<TransactionChartData>.from(
        json['data'].map((x) => TransactionChartData.fromJson(x)),
      ),
    );
  }
}

class TransactionChartData {
  final String month;
  final int success;
  final int failed;
  final int pending;

  TransactionChartData({
    required this.month,
    required this.success,
    required this.failed,
    required this.pending,
  });

  factory TransactionChartData.fromJson(Map<String, dynamic> json) {
    return TransactionChartData(
      month: json['month'],
      success: json['Success'] ?? 0,
      failed: json['Failed'] ?? 0,
      pending: json['Pending'] ?? 0,
    );
  }
}
