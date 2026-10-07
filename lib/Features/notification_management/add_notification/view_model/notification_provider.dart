import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:flutter/material.dart';

import '../model/notification_list_model.dart';
import '../repository/notification_repository.dart';
import 'dart:typed_data';

class AddNotificationProvider extends ChangeNotifier {
  final AddNotificationRepo _repo = AddNotificationRepo(NetworkApiServiceV2());

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _error;

  NotificationModel? _selectedNotification;

  int _currentPage = 1;
  final int _pageSize = 12;
  bool _hasMore = true;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  bool get hasData => _notifications.isNotEmpty;
  int get totalNotifications => _notifications.length;
  NotificationModel? get selectedNotification => _selectedNotification;

  void setSelectedNotification(NotificationModel? notification) {
    _selectedNotification = notification;
    notifyListeners();
  }

  void clearSelectedNotification() {
    _selectedNotification = null;
    notifyListeners();
  }

  void resetFields() {
    _selectedNotification = null;
    _error = null;
    notifyListeners();
  }

  Future<void> fetchNotifications({
    int pageNumber = 1,
    String fromDate = "",
    String toDate = "",
    String searchTag = "",
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _notifications.clear();
        _hasMore = true;
      }

      _isLoading = true;
      _error = null;
      notifyListeners();

      final fetchedNotifications = await _repo.getAllNotification(
        pageNumber: pageNumber,
        pageSize: _pageSize,
        fromDate: fromDate,
        toDate: toDate,
        searchTag: searchTag,
      );

      if (refresh) {
        _notifications = fetchedNotifications;
      } else {
        _notifications.addAll(fetchedNotifications);
      }

      _hasMore = fetchedNotifications.length >= _pageSize;
      _currentPage = pageNumber;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore({
    String fromDate = "",
    String toDate = "",
    String searchTag = "",
  }) async {
    if (!_hasMore || _isLoading) {
      return;
    }

    await fetchNotifications(
      pageNumber: _currentPage + 1,
      fromDate: fromDate,
      toDate: toDate,
      searchTag: searchTag,
    );
  }

  Future<void> refreshNotifications({
    String fromDate = "",
    String toDate = "",
    String searchTag = "",
  }) async {
    await fetchNotifications(
      refresh: true,
      fromDate: fromDate,
      toDate: toDate,
      searchTag: searchTag,
    );
  }

  /// Create notification - Updated to match new API
  Future<bool> createNotification({
    required String title,
    required String notificationType,
    required String description,
    String? link,
    String? imageUrl,
    Uint8List? imageBytes,
    String? imageName,
    required List<String> recipients,
    required String fromDate,
    required String toDate,
    required int interval,
    required String time,
  }) async {
    try {
      _isCreating = true;
      _error = null;
      notifyListeners();

      final notification = await _repo.createNotification(
        title: title,
        notificationType: notificationType,
        description: description,
        link: link,
        imageUrl: imageUrl,
        recipients: recipients,
        fromDate: fromDate,
        toDate: toDate,
        interval: interval,
        time: time,
      );

      _notifications.insert(0, notification);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Update notification - Updated to match new API
  Future<bool> updateNotification({
    required String notificationId,
    String? title,
    String? notificationType,
    String? description,
    String? link,
    String? imageUrl,
    Uint8List? imageBytes,
    String? imageName,
    List<String>? recipients,
    String? fromDate,
    String? toDate,
    int? interval,
    String? time,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      final updatedNotification = await _repo.updateNotification(
        notificationId: notificationId,
        title: title,
        notificationType: notificationType,
        description: description,
        link: link,
        imageUrl: imageUrl,
        recipients: recipients,
        fromDate: fromDate,
        toDate: toDate,
        interval: interval,
        time: time,
      );

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = updatedNotification;
      } else {}

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      _isDeleting = true;
      _error = null;
      notifyListeners();

      final success = await _repo.deleteNotification(
        notificationId: notificationId,
      );

      if (success) {
        // Remove from local list immediately
        _notifications.removeWhere((n) => n.id == notificationId);

        // Optionally refresh the list
        // await fetchNotifications();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<bool> toggleNotificationPause(
    String notificationId,
    bool isPaused,
  ) async {
    return await updateNotification(notificationId: notificationId);
  }

  NotificationModel? getNotificationById(String notificationId) {
    try {
      return _notifications.firstWhere((n) => n.id == notificationId);
    } catch (e) {
      return null;
    }
  }

  List<NotificationModel> searchNotifications(String query) {
    if (query.isEmpty) return _notifications;

    final lowerQuery = query.toLowerCase();
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(lowerQuery) ||
          notification.description.toLowerCase().contains(lowerQuery) ||
          notification.type.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<NotificationModel> filterByType(String type) {
    if (type.isEmpty || type == 'all') return _notifications;
    return _notifications
        .where((n) => n.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  List<NotificationModel> filterByStatus({bool? isPaused}) {
    if (isPaused == null) return _notifications;
    return _notifications.where((n) => n.isPaused == isPaused).toList();
  }

  List<NotificationModel> get activeNotifications {
    return _notifications.where((n) => !n.isPaused).toList();
  }

  List<NotificationModel> get pausedNotifications {
    return _notifications.where((n) => n.isPaused).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _notifications.clear();
    super.dispose();
  }
}
