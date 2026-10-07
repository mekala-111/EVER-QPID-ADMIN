import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/clanmanagement/model/usersmodel.dart';
import 'package:everqpidadmin/Features/clanmanagement/repo/repo.dart';
import 'package:flutter/material.dart';

class ClanManagementViewModel extends ChangeNotifier {
  final repo = ClanManagementrepo(NetworkApiServiceV2());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int pageSize = 10;

  int totalCount = 0;
  int totalPages = 0;

  List<User> clanUsers = [];

  /// ---------- Pagination ----------
  void nextPage(BuildContext context) {
    if (_currentPage < totalPages) {
      _currentPage++;
      getClanUsers(context);
    }
  }

  void prevPage(BuildContext context) {
    if (_currentPage > 1) {
      _currentPage--;
      getClanUsers(context);
    }
  }

  void setPage(int page) {
    _currentPage = page;
    getClanUsers(null);
  }

  /// ---------- API ----------
  Future<void> getClanUsers(
    BuildContext? context, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading = true;
        notifyListeners();
      }

      clanUsers.clear();
      notifyListeners();

      final result = await repo.getClanusers(
        pageNumber: _currentPage.toString(),
        pageSize: pageSize.toString(),
      );

      // ✅ CHECK CORRECT KEY
      if (result['success'] == true) {
        totalCount = result['totalCount'] ?? 0;
        totalPages = (totalCount / pageSize).ceil();

        if (result['users'] is List) {
          clanUsers =
              (result['users'] as List).map((e) => User.fromJson(e)).toList();
        } else {
          clanUsers.clear();
        }
      } else {
        clanUsers.clear();
      }
    } catch (e) {
      clanUsers.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
