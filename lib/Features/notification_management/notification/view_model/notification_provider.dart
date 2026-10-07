import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../repository/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final _repo = NotificationRepo();
  String _formatDateOnly(String isoDate) {
    if (isoDate.isEmpty) return "";
    final date = DateTime.parse(isoDate);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String searchTag = "";
  String fromDate = "";
  String toDate = "";
  String type = "";

  Future<void> fetchEvents({
    String search = "",
    String startDate = "",
    String endDate = "",
    String type = "",
    int pageNumber = 1,
    int pageSize = 12,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final fetchedNotification = await _repo.getAllNotification(
        pageNumber: pageNumber,
        pageSize: pageSize,
        fromDate: _formatDateOnly(startDate),
        toDate: _formatDateOnly(endDate),
        type: type,
        searchTag: search,
      );

      notifications = fetchedNotification;
      searchTag = search;
      fromDate = startDate;
      toDate = endDate;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    searchTag = "";
    fromDate = "";
    toDate = "";
    fetchEvents();
  }

  Future<void> toggleNotification({
    required String notificationId,
    required bool isPaused,
  }) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);

    if (index == -1) return;

    // 🔥 optimistic UI update
    notifications[index] = notifications[index].copyWith(isPaused: isPaused);
    notifyListeners();

    try {
      await _repo.toggleNotificationPause(
        notificationId: notificationId,
        isPaused: isPaused,
      );

      Fluttertoast.showToast(
        msg: isPaused
            ? "Notification paused successfully"
            : "Notification resumed successfully",
      );
    } catch (e) {
      // ❌ rollback on failure
      notifications[index] = notifications[index].copyWith(isPaused: !isPaused);
      notifyListeners();

      Fluttertoast.showToast(
        msg: "Failed to update notification",
        backgroundColor: Colors.red,
      );
    }
  }
}
