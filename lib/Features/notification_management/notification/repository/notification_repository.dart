import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class NotificationRepo {
  final _apiService = NetworkApiServiceV2();

  /// Fetch all Notification (paginated, searchable, and optionally filtered by date)
  Future<List<NotificationModel>> getAllNotification({
    int pageNumber = 1,
    int pageSize = 12,
    String fromDate = "",
    String toDate = "",
    String searchTag = "",
    String type = "",
  }) async {
    try {
      final url =
          "${AppUrl.allNotification}?pageNumber=$pageNumber&pageSize=$pageSize&fromDate=$fromDate&toDate=$toDate&searchTag=$searchTag&notificationType=$type";

      final response = await _apiService.getGetApiResponse(
        url,
        token: LoggedInUser.accessToken,
      );

      final notificationListModel = NotificationListModel.fromJson(response);

      return notificationListModel.notifications;
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationModel> toggleNotificationPause({
    required String notificationId,
    required bool isPaused,
  }) async {
    final apiUrl = "${AppUrl.toggleNotification}/$notificationId";

    final body = {"paused": isPaused};

    final response = await _apiService.getPatchApiResponse(
      apiUrl,
      token: LoggedInUser.accessToken,
      body: body,
    );

    if (response != null && response['data'] != null) {
      return NotificationModel.fromJson(response['data']);
    }

    throw Exception("Failed to toggle notification pause");
  }
}
