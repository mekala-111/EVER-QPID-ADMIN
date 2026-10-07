class ChatResponse {
  final ChatData data;

  ChatResponse({required this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      data: ChatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class ChatData {
  final ChatMeta chatMeta;
  final List<Message> messages;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final bool hasNext;

  ChatData({
    required this.chatMeta,
    required this.messages,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasNext,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatMeta: ChatMeta.fromJson(json['chatMeta']),
      messages:
          (json['messages'] as List).map((e) => Message.fromJson(e)).toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatMeta': chatMeta.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'hasNext': hasNext,
    };
  }
}

class ChatMeta {
  final Host host;
  final User user;

  ChatMeta({required this.host, required this.user});

  factory ChatMeta.fromJson(Map<String, dynamic> json) {
    return ChatMeta(
      host: Host.fromJson(json['host']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host.toJson(),
      'user': user.toJson(),
    };
  }
}

class Host {
  final String id;
  final String name;
  final String profileImageUrl;
  final int age;
  final String place;
  final String? assignedEmployeeName; // Nullable

  Host({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.age,
    required this.place,
    this.assignedEmployeeName, // Optional
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      age: json['age'] ?? 0,
      place: json['place'] ?? '',
      assignedEmployeeName: json['assignedEmployeeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'age': age,
      'place': place,
      'assignedEmployeeName': assignedEmployeeName,
    };
  }
}

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final bool isOnline; // Add this field

  User({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.isOnline, // Add this
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      isOnline: json['isOnline'] ?? false, // Add this with default false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'isOnline': isOnline, // Add this
    };
  }
}

class Message {
  final String id;
  final String type;
  final String content;
  final String mediaUrl;
  final bool isRead;
  final DateTime sentAt;
  final Sender sender;
  final Sender receiver;

  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.mediaUrl,
    required this.isRead,
    required this.sentAt,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'text',
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      isRead: json['isRead'] ?? false,
      sentAt: DateTime.parse(json['sentAt']),
      sender: Sender.fromJson(json['sender']),
      receiver: Sender.fromJson(json['receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'content': content,
      'mediaUrl': mediaUrl,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
    };
  }
}

class Sender {
  final String id;
  final String name;
  final String profileImageUrl;
  final String role;
  // final String isOnline;

  Sender({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.role,
    // required this.isOnline
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      role: json['role'] ?? '',
      // isOnline: json['isOnline']??''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role,
      // 'isOnline':isOnline
    };
  }
}
