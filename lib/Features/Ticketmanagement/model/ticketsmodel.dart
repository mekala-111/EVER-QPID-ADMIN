class TicketResponse {
  final List<Ticket> tickets;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final bool hasNext;

  TicketResponse({
    required this.tickets,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasNext,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }
}

class Ticket {
  final String ticketId;
  final bool documentStatus;
  final TicketUser? userId;
  final String email;
  final String? firstName;
  final String category;
  final String subject;
  final String description;
  final List<String> attachments;
  final String status;
  final AssignedEmployee? assignedTo;
  final String priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ticket({
    required this.ticketId,
    required this.documentStatus,
    this.userId,
    required this.email,
    this.firstName,
    required this.category,
    required this.subject,
    required this.description,
    required this.attachments,
    required this.status,
    this.assignedTo,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticketId'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      userId:
          json['userId'] != null ? TicketUser.fromJson(json['userId']) : null,
      email: json['email'] ?? '',
      firstName: json['firstName'],
      category: json['category'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
      status: json['status'] ?? '',
      assignedTo: json['assignedTo'] != null
          ? AssignedEmployee.fromJson(json['assignedTo'])
          : null,
      priority: json['priority'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class TicketUser {
  final String id;
  final String email;

  TicketUser({
    required this.id,
    required this.email,
  });

  factory TicketUser.fromJson(Map<String, dynamic> json) {
    return TicketUser(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class AssignedEmployee {
  final String id;
  final String name;
  final String email;

  AssignedEmployee({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AssignedEmployee.fromJson(Map<String, dynamic> json) {
    return AssignedEmployee(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
