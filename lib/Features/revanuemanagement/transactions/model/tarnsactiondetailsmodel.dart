class TransactionResponse {
  final Transaction transaction;
  final PaymentDetails paymentDetails;

  TransactionResponse({
    required this.transaction,
    required this.paymentDetails,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      transaction: Transaction.fromJson(json['transaction']),
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction.toJson(),
      'paymentDetails': paymentDetails.toJson(),
    };
  }
}

class Transaction {
  final String transactionId;
  final String date;
  final String time;
  final String userName;
  final String planName;
  final String status;

  Transaction({
    required this.transactionId,
    required this.date,
    required this.time,
    required this.userName,
    required this.planName,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      userName: json['userName'] ?? '',
      planName: json['planName'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'date': date,
      'time': time,
      'userName': userName,
      'planName': planName,
      'status': status,
    };
  }
}

class PaymentDetails {
  final String paymentMethod;
  final String paymentReference;
  final int planAmount;
  final int totalAmount;

  PaymentDetails({
    required this.paymentMethod,
    required this.paymentReference,
    required this.planAmount,
    required this.totalAmount,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentMethod: json['paymentMethod'] ?? '',
      paymentReference: json['paymentReference'] ?? '',
      planAmount: json['planAmount'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'paymentReference': paymentReference,
      'planAmount': planAmount,
      'totalAmount': totalAmount,
    };
  }
}
