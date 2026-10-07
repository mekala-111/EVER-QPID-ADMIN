import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class AddNotificationRepo {
  final BaseApiService apiService;
  AddNotificationRepo(this.apiService);

  /// ✅ Get All Notifications
  Future<List<NotificationModel>> getAllNotification({
    required int pageNumber,
    required int pageSize,
    String fromDate = "",
    String toDate = "",
    String searchTag = "",
  }) async {
    try {
      var result = await apiService.getGetApiResponse(
        AppUrl.allNotification,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "fromDate": fromDate,
          "toDate": toDate,
          "search": searchTag,
        },
      );

      if (result == null) throw "Null result received from API";
      if (result['status'] == false) throw result['message'];

      final model = NotificationListModel.fromJson(result);
      return model.notifications;
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Create Notification - Returns NotificationModel
  Future<NotificationModel> createNotification({
    required String title,
    required String notificationType,
    required String description,
    String? link,
    String? imageUrl,
    required List<String> recipients,
    required String fromDate,
    required String toDate,
    required int interval,
    required String time,
  }) async {
    try {
      final body = {
        // "adminId": LoggedInUser.id,
        "title": title,
        "notificationType": notificationType,
        "description": description,
        "link": link,
        "imageUrl": imageUrl,
        "recipients": recipients,
        "fromDate": fromDate,
        "toDate": toDate,
        "interval": interval,
        "time": time,
      };

      var result = await apiService.getPostApiResponse(
        AppUrl.createNotification,
        token: LoggedInUser.accessToken,
        body: body,
      );

      if (result == null) throw "Null result received from API";
      if (result['status'] == false) {
        throw result['message'] ?? "Failed to create notification";
      }

      // ✅ Parse the notification data from response
      if (result['data'] != null &&
          result['data']['notificationData'] != null) {
        final notificationData = result['data']['notificationData'];
        return NotificationModel.fromJson(notificationData);
      } else {
        throw "Invalid response structure: missing notificationData";
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Update Notification - Returns NotificationModel
  Future<NotificationModel> updateNotification({
    required String notificationId,
    String? title,
    String? notificationType,
    String? description,
    String? link,
    String? imageUrl,
    List<String>? recipients,
    String? fromDate,
    String? toDate,
    int? interval,
    String? time,
  }) async {
    try {
      final body = <String, dynamic>{"adminId": LoggedInUser.id};

      if (title != null) body["title"] = title;
      if (notificationType != null) body["notificationType"] = notificationType;
      if (description != null) body["description"] = description;
      if (link != null) body["link"] = link;
      if (imageUrl != null) body["imageUrl"] = imageUrl;
      if (recipients != null) body["recipients"] = recipients;
      if (fromDate != null) body["fromDate"] = fromDate;
      if (toDate != null) body["toDate"] = toDate;
      if (interval != null) body["interval"] = interval;
      if (time != null) body["time"] = time;

      var result = await apiService.getPutApiResponse(
        "${AppUrl.updateNotification}/$notificationId",
        token: LoggedInUser.accessToken,
        body: body,
      );

      if (result == null) throw "Null result received from API";
      if (result['status'] == false) {
        throw result['message'] ?? "Failed to update notification";
      }

      // ✅ Parse the updated notification data from response
      if (result['data'] != null &&
          result['data']['notificationData'] != null) {
        final notificationData = result['data']['notificationData'];
        return NotificationModel.fromJson(notificationData);
      } else {
        throw "Invalid response structure: missing notificationData";
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Delete Notification - Returns bool
  Future<bool> deleteNotification({required String notificationId}) async {
    try {
      var result = await apiService.getDeleteApiResponse(
          "${AppUrl.deleteNotification}/$notificationId",
          token: LoggedInUser.accessToken,
          body: {'adminId': LoggedInUser.id}).timeout(
        const Duration(seconds: 30), // Add timeout
        onTimeout: () {
          throw "Request timed out. Please check your connection.";
        },
      );

      if (result == null) {
        throw "No response received from server";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to delete notification";
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Pause / Resume Notification (if still needed)
  Future<NotificationModel> toggleNotificationPause({
    required String notificationId,
    required bool isPaused,
  }) async {
    final apiUrl = "api/v1/notification/pause-notification/$notificationId";

    final response = await apiService.getPatchApiResponse(
      apiUrl,
      token: LoggedInUser.accessToken,
      body: {"pause": isPaused},
    );

    if (response != null &&
        response['data'] != null &&
        response['data']['notificationData'] != null) {
      return NotificationModel.fromJson(response['data']['notificationData']);
    }

    throw Exception("Failed to toggle notification pause");
  }
}
