class TicketDetailsResponse {
  final TicketData data;

  TicketDetailsResponse({required this.data});

  factory TicketDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TicketDetailsResponse(
      data: TicketData.fromJson(json['data']),
    );
  }
}

class TicketData {
  final Ticket ticket;
  final SideProfileDetails? sideProfileDetails;
  final bool isClosed;

  TicketData({
    required this.ticket,
    this.sideProfileDetails,
    required this.isClosed,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticket: Ticket.fromJson(json['ticket']),
      sideProfileDetails: json['sideProfileDetails'] != null
          ? SideProfileDetails.fromJson(json['sideProfileDetails'])
          : null,
      isClosed: json['isClosed'] ?? false,
    );
  }
}

class Ticket {
  final String ticketId;
  final bool documentStatus;
  final String? userId;
  final String email;
  final String? firstName;
  final String category;
  final String subject;
  final String description;
  final List<String> attachments;
  final String status;
  final AssignedTo? assignedTo; // ✅ Changed from String? to AssignedTo?
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
      userId: json['userId'],
      email: json['email'] ?? '',
      firstName: json['firstName'],
      category: json['category'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      status: json['status'] ?? '',
      assignedTo: json['assignedTo'] != null
          ? AssignedTo.fromJson(json['assignedTo'])
          : null, // ✅ Parse as object
      priority: json['priority'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// ✅ New class for assignedTo
class AssignedTo {
  final String id;
  final String name;
  final String email;

  AssignedTo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class SideProfileDetails {
  final String fullName;
  final DateTime? joinedDate;
  final DateTime? lastActive;
  final String phoneNo;
  final String email;
  final bool isVerified;
  final bool isSubscribed;
  final int totalMatches;
  final int totalSpend;
  final int openTickets;
  final DateTime? lastChatOn;

  SideProfileDetails({
    required this.fullName,
    this.joinedDate,
    this.lastActive,
    required this.phoneNo,
    required this.email,
    required this.isVerified,
    required this.isSubscribed,
    required this.totalMatches,
    required this.totalSpend,
    required this.openTickets,
    this.lastChatOn,
  });

  factory SideProfileDetails.fromJson(Map<String, dynamic> json) {
    return SideProfileDetails(
      fullName: json['fullName'] ?? '',
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : null,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      totalMatches: json['totalMatches'] ?? 0,
      totalSpend: json['totalSpend'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      lastChatOn: json['lastChatOn'] != null
          ? DateTime.parse(json['lastChatOn'])
          : null,
    );
  }
}
