// chathistorymodel.dart
class ChatHistoryResponse {
  final List<ChatMessage> data;

  ChatHistoryResponse({required this.data});

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      data: (json['data'] as List).map((e) => ChatMessage.fromJson(e)).toList(),
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String type; // text | image | audio
  final String content;
  final String mediaUrl;
  final bool isRead;
  final DateTime sentAt;
  final bool documentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedBy;
  final int version;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.content,
    required this.mediaUrl,
    required this.isRead,
    required this.sentAt,
    required this.documentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedBy,
    required this.version,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      type: json['type'],
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      isRead: json['isRead'] ?? false,
      sentAt: DateTime.parse(json['sentAt']),
      documentStatus: json['documentStatus'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedBy: json['deletedBy'],
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'content': content,
      'mediaUrl': mediaUrl,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      'documentStatus': documentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedBy': deletedBy,
      '__v': version,
    };
  }
}
