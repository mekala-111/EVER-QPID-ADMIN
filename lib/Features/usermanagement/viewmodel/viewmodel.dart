import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/usermanagement/model/allusermodel.dart';
import 'package:everqpidadmin/Features/usermanagement/model/reportedusermodel.dart'
    hide User;
import 'package:everqpidadmin/Features/usermanagement/repo/repo.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/common/widgets/error_msg.dart';

class UsersViewModel extends ChangeNotifier {
  // -------------------- STATE --------------------
  bool loading = false;
  String? error;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  int totalPages = 0;

  List<User> userList = [];

  // -------------------- FILTERS --------------------
  String? searchKeyword;
  String? status;
  String? gender;

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();

  // -------------------- REPO --------------------
  final repo = UserManagementRepository(NetworkApiServiceV2());

  // -------------------- DATE HANDLERS --------------------
  void updateFrom(DateTime date) {
    fromDate = date;
    fromTextController.text =
        formatDateFromDate(dateTime: date, format: 'yyyy-MM-dd');
    notifyListeners();
  }

  void updateTo(DateTime date) {
    toDate = date;
    toTextController.text =
        formatDateFromDate(dateTime: date, format: 'yyyy-MM-dd');
    notifyListeners();
  }

  // -------------------- APPLY FILTERS --------------------
  void applyFilters(
    BuildContext context, {
    required String search,
    required String statusFilter,
    DateTime? fromDateFilter,
    DateTime? toDateFilter,
  }) {
    currentPage = 1;
    searchKeyword = search.isEmpty ? null : search;
    status = statusFilter.isEmpty ? null : statusFilter;
    fromDate = fromDateFilter;
    toDate = toDateFilter;

    // Update text controllers
    searchTextController.text = search;
    fromTextController.text = fromDateFilter != null
        ? formatDateFromDate(dateTime: fromDateFilter, format: 'yyyy-MM-dd')
        : '';
    toTextController.text = toDateFilter != null
        ? formatDateFromDate(dateTime: toDateFilter, format: 'yyyy-MM-dd')
        : '';

    getAllUsersFn(context);
  }

  // -------------------- CLEAR FILTERS --------------------
  void clearFilters(BuildContext context) {
    currentPage = 1;
    searchKeyword = null;
    status = null;
    fromDate = null;
    toDate = null;

    searchTextController.clear();
    fromTextController.clear();
    toTextController.clear();

    getAllUsersFn(context);
  }

  // -------------------- SET GENDER FILTER --------------------
  void setGenderFilter(String? genderFilter) {
    gender = genderFilter;
  }

// Add these fields to UsersViewModel class
  int totalUsers = 0;
  int totalActiveUsers = 0;
  int newSignupsThisMonth = 0;
  // -------------------- API CALL --------------------
  Future<void> getAllUsersFn(BuildContext context) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      const int pageSize = 10;

      final result = await repo.getAllUsers(
        searchTag: searchKeyword ?? "",
        pageNumber: currentPage.toString(),
        pageSize: pageSize.toString(),
        fromDate: fromDate != null
            ? formatDateFromDate(dateTime: fromDate!, format: 'yyyy-MM-dd')
            : "",
        toDate: toDate != null
            ? formatDateFromDate(dateTime: toDate!, format: 'yyyy-MM-dd')
            : "",
        status: status ?? "",
        gender: gender ?? "",
      );

      if (result['statusCode'] == 200 && result['status'] == true) {
        final data = result['data'];

        if (data != null && data['users'] != null) {
          final usersList = data['users'] as List;

          // Store statistics
          totalUsers = data['totalUsers'] ?? 0;
          totalActiveUsers = data['totalActiveUsers'] ?? 0;
          newSignupsThisMonth = data['newSignupsThisMonth'] ?? 0;
          tatalMale = data['totalMaleUsers'] ?? 0;
          tatalfeMale = data['totalFemaleUsers'] ?? 0;
          newFemaleSignupsThisMonth = data['newFemaleSignupsThisMonth'] ?? 0;
          newMaleSignupsThisMonth = data['newMaleSignupsThisMonth'];
          totalActiveFemaleUsers = data['totalActiveFemaleUsers'];
          totalActiveMaleUsers = data['totalActiveMaleUsers'];

          totalPages = data['totalCount'] != null
              ? ((data['totalCount'] / pageSize) as double).ceil()
              : 1;

          userList = usersList.map((e) => User.fromJson(e)).toList();
        } else {
          userList = [];
          error = 'No user data available';
        }
      } else {
        userList = [];
        error = result['message'] ?? 'Failed to fetch users';
      }
    } catch (e) {
      userList = [];
      error = 'Error: ${e.toString()}';
    } finally {
      loading = false;

      if (context.mounted) {
        notifyListeners();

        if (error != null) {
          ErrorMsg.showSnakError(context, error!);
        }
      }
    }
  }

  // -------------------- PAGINATION --------------------
  void nextPage(BuildContext context) {
    if (currentPage < totalPages) {
      currentPage++;
      getAllUsersFn(context);
    }
  }

  void prevPage(BuildContext context) {
    if (currentPage > 1) {
      currentPage--;
      getAllUsersFn(context);
    }
  }

  // -------------------- REPORTED USERS STATE --------------------
  int totalUsersreport = 0;
  int activeUsers = 0;
  int newSignUps = 0;
  int tatalMale = 0;
  int tatalfeMale = 0;
  int totalOtherUsers = 0;
  int totalActiveFemaleUsers = 0;
  int totalActiveMaleUsers = 0;
  int reportedUsersCount = 0;
  int reportedUsersCountmale = 0;
  int reportedUsersCountfemale = 0;

  int newMaleSignupsThisMonth = 0;
  int newFemaleSignupsThisMonth = 0;

  List<Report> reportedUsers = [];
  int reportedTotalPages = 0;
  bool reportedLoading = false;
  String? reportedError;
  Future<void> getReportedUsersFn(BuildContext context) async {
    if (!context.mounted) return;

    try {
      reportedLoading = true;
      reportedError = null;
      notifyListeners();

      const int pageSize = 10;

      final result = await repo.getReportedUsers(
        pageNumber: currentPage.toString(),
        pageSize: pageSize.toString(),
        searchTag: searchKeyword ?? "",
        fromDate: fromDate != null
            ? formatDateFromDate(dateTime: fromDate!, format: 'yyyy-MM-dd')
            : "",
        toDate: toDate != null
            ? formatDateFromDate(dateTime: toDate!, format: 'yyyy-MM-dd')
            : "",
        status: status ?? "",
        gender: gender ?? "",
      );

      if (result['statusCode'] == 200 && result['status'] == true) {
        final data = result['data'];

        if (data != null) {
          // Reports list
          final reportsList = data['reports'] as List? ?? [];
          reportedUsers = reportsList.map((e) => Report.fromJson(e)).toList();

          // Pagination
          reportedTotalPages = data['totalCount'] != null
              ? (data['totalCount'] / pageSize).ceil()
              : 1;

          // Stats (NEW)
          final stats = data['stats'];
          if (stats != null) {
            totalUsersreport = stats['totalUsers'] ?? 0;
            activeUsers = stats['activeUsers'] ?? 0;
            newSignUps = stats['newSignUps'] ?? 0;
            reportedUsersCount = stats['reportedUsersCount'];
            reportedUsersCountmale = stats['reportedMaleAccounts'];
            reportedUsersCountfemale = stats['reportedFemaleAccounts'];
          }
        } else {
          reportedUsers = [];
          reportedError = 'No reported users found';
        }
      } else {
        reportedUsers = [];
        reportedError = result['message'] ?? 'Failed to load reports';
      }
    } catch (e) {
      reportedUsers = [];
      reportedError = e.toString();
    } finally {
      reportedLoading = false;

      if (context.mounted) {
        notifyListeners();
        if (reportedError != null) {
          ErrorMsg.showSnakError(context, reportedError!);
        }
      }
    }
  }

  void nextReportedPage(BuildContext context) {
    if (currentPage < reportedTotalPages) {
      currentPage++;
      getReportedUsersFn(context);
    }
  }

  void prevReportedPage(BuildContext context) {
    if (currentPage > 1) {
      currentPage--;
      getReportedUsersFn(context);
    }
  }

  String? deactivateUserError;

  Future<void> deActivateUserFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      deactivateUserError =
          null; // you may rename this to deactivateError later
      notifyListeners();

      final result = await repo.deActivateUser(
        userId: userId,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'User suspended successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (!context.mounted) return;
        getAllUsersFn(context);
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.users);
      } else {
        deactivateUserError = result['message'] ?? 'Failed to suspend user';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, deactivateUserError!);
        }
      }
    } catch (e) {
      deactivateUserError = 'Error suspending user: ${e.toString()}';

      if (context.mounted) {
        notifyListeners();
        ErrorMsg.showSnakError(context, deactivateUserError!);
      }
    }
  }

  String? activateUserError;

  Future<void> activateUserFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      activateUserError = null; // you may rename this to deactivateError later
      notifyListeners();

      final result = await repo.activateUser(
        userId: userId,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'User suspended successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (!context.mounted) return;
        getAllUsersFn(context);
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.users);
      } else {
        activateUserError = result['message'] ?? 'Failed to suspend user';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, activateUserError!);
        }
      }
    } catch (e) {
      activateUserError = 'Error suspending user: ${e.toString()}';

      if (context.mounted) {
        notifyListeners();
        ErrorMsg.showSnakError(context, activateUserError!);
      }
    }
  }
}
