class ChatLogsResponse {
  final List<ChatLogModel> data;

  ChatLogsResponse({required this.data});

  factory ChatLogsResponse.fromJson(Map<String, dynamic> json) {
    return ChatLogsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatLogModel.fromJson(e))
          .toList(),
    );
  }
}

class ChatLogModel {
  final int chatCount;
  final String fullName;
  final bool status;

  ChatLogModel({
    required this.chatCount,
    required this.fullName,
    required this.status,
  });

  factory ChatLogModel.fromJson(Map<String, dynamic> json) {
    return ChatLogModel(
      chatCount: json['chatCount'] ?? 0,
      fullName: json['fullName'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatCount': chatCount,
      'fullName': fullName,
      'status': status,
    };
  }
}
