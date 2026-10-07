class ChatListResponse {
  final List<ChatItem> chats;
  final int totalCount;
  final bool hasNext;

  ChatListResponse({
    required this.chats,
    required this.totalCount,
    required this.hasNext,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      chats: (json['chats'] as List).map((e) => ChatItem.fromJson(e)).toList(),
      totalCount: json['totalCount'],
      hasNext: json['hasNext'],
    );
  }
}

class ChatItem {
  final String userId;
  final LastMessage lastMessage;
  final int unreadCount;
  final User user;

  ChatItem({
    required this.userId,
    required this.lastMessage,
    required this.unreadCount,
    required this.user,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      userId: json['userId'],
      lastMessage: LastMessage.fromJson(json['lastMessage']),
      unreadCount: json['unreadCount'] ?? 0,
      user: User.fromJson(json['user']),
    );
  }
}

class LastMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String type;
  final String content;
  final String mediaUrl;
  final bool isRead;
  final DateTime sentAt;
  final bool documentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedBy;
  final int version;
  final String userId;

  LastMessage({
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
    required this.userId,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
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
      userId: json['userId'],
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String profileImageUrl;
  final String locationString;
  final List<String> otherLanguages;
  final bool isOnline;
  final DateTime? lastActive; // ✅ Make nullable

  User({
    required this.id,
    required this.fullName,
    required this.profileImageUrl,
    required this.locationString,
    required this.otherLanguages,
    required this.isOnline,
    this.lastActive, // ✅ Make optional
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      locationString: json['locationString'] ?? '',
      otherLanguages: List<String>.from(json['otherLanguages'] ?? []),
      isOnline: json['isOnline'] ?? false,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null, // ✅ Handle null safely
    );
  }
}
