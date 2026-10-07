// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

/* -------------------------------------------------------------------------- */
/*                                LIST MODEL                                  */
/* -------------------------------------------------------------------------- */

class NotificationListModel {
  final bool success;
  final List<NotificationModel> notifications;

  NotificationListModel({
    required this.success,
    required this.notifications,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return NotificationListModel(
      success: json['status'] ?? false,
      notifications: data != null &&
              data['notifications'] != null &&
              data['notifications'] is List
          ? (data['notifications'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

// COMPLETE MODEL UPDATE - Add interval to NotificationModel

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String type;

  final String? url;
  final String? image;

  final bool isPaused;

  final Schedule schedule;
  final int interval; // ✅ Add interval field

  final List<String> recipients;

  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.url,
    this.image,
    required this.isPaused,
    required this.schedule,
    required this.interval, // ✅ Required parameter
    required this.recipients,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? url,
    String? image,
    bool? isPaused,
    Schedule? schedule,
    int? interval,
    List<String>? recipients,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      image: image ?? this.image,
      isPaused: isPaused ?? this.isPaused,
      schedule: schedule ?? this.schedule,
      interval: interval ?? this.interval,
      recipients: recipients ?? this.recipients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['notificationType'] ?? json['type'] ?? '',
      url: json['link']?.toString() ?? json['url']?.toString(),
      image: json['imageUrl']?.toString() ?? json['image']?.toString(),
      isPaused: json['paused'] ?? json['isPaused'] ?? false,
      schedule: Schedule.fromApiJson(json),
      interval: json['interval'] as int? ?? 1, // ✅ Parse interval from API
      recipients: json['recipients'] is List
          ? List<String>.from(json['recipients'])
          : [],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      version: json['__v'] ?? 0,
    );
  }
}

// ----------------------------------------------------------------------
// SCHEDULE
// ----------------------------------------------------------------------

class Schedule {
  final DateTime startDate;
  final DateTime endDate;
  final String? time;

  Schedule({
    required this.startDate,
    required this.endDate,
    this.time,
  });

  /// Builds schedule directly from API response
  factory Schedule.fromApiJson(Map<String, dynamic> json) {
    return Schedule(
      startDate: DateTime.parse(
        json['fromDate'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['toDate'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      time: json['time']?.toString(),
    );
  }
}

// ----------------------------------------------------------------------
// RECIPIENT
// ----------------------------------------------------------------------

class Recipient {
  final String userId;
  final String timezone;
  final bool isRead;
  final String? sentAt;
  final String id;

  Recipient({
    required this.userId,
    required this.timezone,
    required this.isRead,
    this.sentAt,
    required this.id,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        userId: json["userId"] ?? "",
        timezone: json["timezone"] ?? "",
        isRead: json["isRead"] ?? false,
        sentAt: json["sentAt"]?.toString(),
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "timezone": timezone,
        "isRead": isRead,
        if (sentAt != null) "sentAt": sentAt,
        "_id": id,
      };
}
