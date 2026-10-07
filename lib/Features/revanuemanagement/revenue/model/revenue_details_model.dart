// To parse this JSON data, do
//
//     final revenueDetailsModel = revenueDetailsModelFromJson(jsonString);

import 'dart:convert';

RevenueDetailsModel revenueDetailsModelFromJson(String str) =>
    RevenueDetailsModel.fromJson(json.decode(str));

String revenueDetailsModelToJson(RevenueDetailsModel data) =>
    json.encode(data.toJson());

class RevenueDetailsModel {
  bool status;
  int statusCode;
  Data data;

  RevenueDetailsModel({
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory RevenueDetailsModel.fromJson(Map<String, dynamic> json) =>
      RevenueDetailsModel(
        status: json["status"],
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  int totalRevenue;
  int totalRefunded;
  int netRevenue;
  int totalUsers;
  String averageRevenuePerUser;
  Map<String, int> revenueByDate;

  Data({
    required this.totalRevenue,
    required this.totalRefunded,
    required this.netRevenue,
    required this.totalUsers,
    required this.averageRevenuePerUser,
    required this.revenueByDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRevenue: json["totalRevenue"],
        totalRefunded: json["totalRefunded"],
        netRevenue: json["netRevenue"],
        totalUsers: json["totalUsers"],
        averageRevenuePerUser: json["averageRevenuePerUser"],
        revenueByDate: Map.from(json["revenueByDate"])
            .map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "totalRevenue": totalRevenue,
        "totalRefunded": totalRefunded,
        "netRevenue": netRevenue,
        "totalUsers": totalUsers,
        "averageRevenuePerUser": averageRevenuePerUser,
        "revenueByDate": Map.from(revenueByDate)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
