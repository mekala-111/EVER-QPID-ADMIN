import 'dart:convert';

TransactionListModel transactionListModelFromJson(String str) =>
    TransactionListModel.fromJson(json.decode(str));

class TransactionListModel {
  final bool status;
  final int statusCode;
  final String message;
  final TransactionData data;

  TransactionListModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TransactionListModel.fromJson(Map<String, dynamic> json) {
    return TransactionListModel(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: TransactionData.fromJson(json['data']),
    );
  }
}

class TransactionData {
  final Summary summary;
  final List<TransactionItem> transactions;
  final Pagination pagination;

  TransactionData({
    required this.summary,
    required this.transactions,
    required this.pagination,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      summary: Summary.fromJson(json['summary']),
      transactions: List<TransactionItem>.from(
        json['transactions'].map((x) => TransactionItem.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Summary {
  final RevenueSummary totalRevenue;
  final int activePlansTotalAmount;

  Summary({
    required this.totalRevenue,
    required this.activePlansTotalAmount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalRevenue: RevenueSummary.fromJson(json['totalRevenue']),
      activePlansTotalAmount: json['activePlansTotalAmount'],
    );
  }
}

class RevenueSummary {
  final int totalRevenue;
  final int totalUsers;
  final int averageRevenuePerUser;

  RevenueSummary({
    required this.totalRevenue,
    required this.totalUsers,
    required this.averageRevenuePerUser,
  });

  factory RevenueSummary.fromJson(Map<String, dynamic> json) {
    return RevenueSummary(
      totalRevenue: json['totalRevenue'],
      totalUsers: json['totalUsers'],
      averageRevenuePerUser: json['averageRevenuePerUser'],
    );
  }
}

class TransactionItem {
  final String transactionId;
  final int amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String userName;
  final String userEmail;
  final String planName;

  TransactionItem({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.userName,
    required this.userEmail,
    required this.planName,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      transactionId: json['transactionId'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userName: json['userName'] ?? 'Unknown',
      userEmail: json['userEmail'] ?? '',
      planName: json['planName'] ?? '',
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalRecords,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      totalRecords: json['totalRecords'],
      totalPages: json['totalPages'],
    );
  }
}
