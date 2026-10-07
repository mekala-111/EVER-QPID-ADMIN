class ChatListResponse {
  final int totalCount;
  final bool hasNext;
  final List<ChatItem> chats;

  ChatListResponse({
    required this.totalCount,
    required this.hasNext,
    required this.chats,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      totalCount: json['totalCount'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      chats: (json['chats'] as List<dynamic>? ?? [])
          .map((e) => ChatItem.fromJson(e))
          .toList(),
    );
  }
}

class ChatItem {
  final LastMessage lastMessage;
  final int unreadCount;
  final ChatUser user;
  final String userId;

  ChatItem({
    required this.lastMessage,
    required this.unreadCount,
    required this.user,
    required this.userId,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      lastMessage: LastMessage.fromJson(json['lastMessage']),
      unreadCount: json['unreadCount'] ?? 0,
      user: ChatUser.fromJson(json['user']),
      userId: json['userId'] ?? '',
    );
  }
}

class LastMessage {
  final String content;
  final String type;
  final DateTime? sentAt;

  LastMessage({
    required this.content,
    required this.type,
    this.sentAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }
}

class ChatId {
  final String user1;
  final String user2;

  ChatId({
    required this.user1,
    required this.user2,
  });

  factory ChatId.fromJson(Map<String, dynamic> json) {
    return ChatId(
      user1: json['user1'] ?? '',
      user2: json['user2'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user1': user1,
      'user2': user2,
    };
  }
}

class ChatUser {
  final String id;
  final String fullName;
  final String profileImageUrl;
  final bool isOnline;
  final String location;

  ChatUser({
    required this.id,
    required this.fullName,
    required this.profileImageUrl,
    required this.isOnline,
    required this.location,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
      location: json['locationString'] ?? '',
    );
  }
}
