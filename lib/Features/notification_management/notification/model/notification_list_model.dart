// import 'dart:convert';

// import 'dart:convert';

// NotificationListModel notificationListModelFromJson(String str) =>
//     NotificationListModel.fromJson(json.decode(str));

// String notificationListModelToJson(NotificationListModel data) =>
//     json.encode(data.toJson());

// class NotificationListModel {
//   bool status;
//   int statusCode;
//   List<NotificationModel> notifications;

//   NotificationListModel({
//     required this.status,
//     required this.statusCode,
//     required this.notifications,
//   });

//   factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
//       NotificationListModel(
//         status: json["status"] ?? false,
//         statusCode: json["statusCode"] ?? 0,
//         notifications: json["data"] != null
//             ? List<NotificationModel>.from(
//                 json["data"].map((x) => NotificationModel.fromJson(x)),
//               )
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "statusCode": statusCode,
//     "data": List<dynamic>.from(notifications.map((x) => x.toJson())),
//   };
// }

// class NotificationModel {
//   Schedule schedule;
//   String id;
//   String title;
//   String type;
//   String description;
//   String? url;
//   String? image;
//   String targetUsers;
//   bool? isPaused; // nullable and fixed
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;

//   NotificationModel({
//     required this.schedule,
//     required this.id,
//     required this.title,
//     required this.type,
//     required this.description,
//     this.url,
//     this.image,
//     required this.targetUsers,
//     this.isPaused,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   factory NotificationModel.fromJson(Map<String, dynamic> json) =>
//       NotificationModel(
//         schedule: Schedule.fromJson(json["schedule"]),
//         id: json["_id"] ?? '',
//         title: json["title"] ?? '',
//         type: json["type"] ?? '',
//         description: json["description"] ?? '',
//         url: json["url"],
//         image: json["image"],
//         targetUsers: json["targetUsers"] ?? '',
//         isPaused: json["isPaused"] as bool?,
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         v: json["__v"] ?? 0,
//       );

//   Map<String, dynamic> toJson() => {
//         "schedule": schedule.toJson(),
//         "_id": id,
//         "title": title,
//         "type": type,
//         "description": description,
//         "url": url,
//         "image": image,
//         "targetUsers": targetUsers,
//         "isPaused": isPaused,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "__v": v,
//       };
// }

// class Schedule {
//   DateTime startDate;
//   DateTime endDate;

//   Schedule({required this.startDate, required this.endDate});

//   factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
//         startDate: DateTime.parse(json["startDate"]),
//         endDate: DateTime.parse(json["endDate"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "startDate": startDate.toIso8601String(),
//         "endDate": endDate.toIso8601String(),
//       };
// }
