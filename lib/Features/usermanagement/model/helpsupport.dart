class TicketResponse {
  final List<TicketModel> data;

  TicketResponse({required this.data});

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TicketModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketModel {
  final String ticketId;
  final DateTime createdAt;
  final String reason;
  final String priority;
  final String status;

  TicketModel({
    required this.ticketId,
    required this.createdAt,
    required this.reason,
    required this.priority,
    required this.status,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticketId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      reason: json['reason'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'createdAt': createdAt.toIso8601String(),
      'reason': reason,
      'priority': priority,
      'status': status,
    };
  }
}
