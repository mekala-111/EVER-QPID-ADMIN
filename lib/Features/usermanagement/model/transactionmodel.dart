class TransactionResponse {
  final List<TransactionModel> data;

  TransactionResponse({required this.data});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionModel {
  final String transactionId;
  final DateTime date;
  final String plan;
  final int amount;
  final String status;
  final String planType;

  TransactionModel({
    required this.transactionId,
    required this.date,
    required this.plan,
    required this.amount,
    required this.status,
    required this.planType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'] ?? '',
      date: DateTime.parse(json['date']),
      plan: json['plan'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      planType: json['planType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'date': date.toIso8601String(),
      'plan': plan,
      'amount': amount,
      'status': status,
      'planType': planType,
    };
  }
}
