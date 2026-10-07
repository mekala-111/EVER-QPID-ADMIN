import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/employeemanagement/model/model.dart';
import 'package:everqpidadmin/Features/employeemanagement/repo/repo.dart';
import 'package:flutter/material.dart';

class EmployeeViewModel extends ChangeNotifier {
  final repo = EmployeeRepo(NetworkApiServiceV2());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loading = false;
  bool get loading => _loading;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  final int pageSize = 10;

  int totalCount = 0;
  int totalPages = 1;
  bool hasNext = false;

  List<Employee> employees = [];
  String? error;

  /// 🔍 Filters
  String? selectedStatus;
  String? selectedRole;
  String? searchQuery;
  DateTime? fromDate;
  DateTime? toDate;

  /// -------- Filter setters --------
  void setStatus(String? status) {
    selectedStatus = status;
    _resetAndFetch(null);
  }

  void setRole(String? role) {
    selectedRole = role;
    _resetAndFetch(null);
  }

  void setSearch(String? query) {
    searchQuery = query;
    _resetAndFetch(null);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    fromDate = from;
    toDate = to;
    _resetAndFetch(null);
  }

  void clearFilters() {
    selectedStatus = null;
    selectedRole = null;
    searchQuery = null;
    fromDate = null;
    toDate = null;
    error = null;
    _resetAndFetch(null);
  }

  void _resetAndFetch(BuildContext? context) {
    _currentPage = 1;
    getEmployees(context);
  }

  /// -------- Pagination --------
  void nextPage(BuildContext? context) {
    if (hasNext && _currentPage < totalPages) {
      _currentPage++;
      getEmployees(context, showLoading: false);
    }
  }

  void prevPage(BuildContext? context) {
    if (_currentPage > 1) {
      _currentPage--;
      getEmployees(context, showLoading: false);
    }
  }

  /// -------- API --------
  Future<void> getEmployees(
    BuildContext? context, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading = true;
        error = null;
        notifyListeners();
      }

      employees.clear();
      notifyListeners();

      final result = await repo.getEmployees(
        pageNumber: _currentPage.toString(),
        pageSize: pageSize.toString(),
        status: selectedStatus,
        role: selectedRole,
        search: searchQuery,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (result['data'] != null) {
        final data = result['data'];

        totalCount = data['totalCount'] ?? 0;
        hasNext = data['hasNext'] ?? false;

        // Calculate total pages
        totalPages = (totalCount / pageSize).ceil();
        if (totalPages == 0) totalPages = 1;

        if (data['employees'] is List) {
          employees = (data['employees'] as List)
              .map((e) => Employee.fromJson(e))
              .toList();
        }

        error = null;
      }
    } catch (e) {
      error = e.toString();
      employees.clear();
      totalCount = 0;
      totalPages = 1;
      hasNext = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// -------- Add Employee --------
  Future<bool> addEmployee(
    BuildContext context, {
    required String name,
    required String email,
    required String role,
    required String authorityLevel,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final data = {
        'name': name,
        'email': email,
        'role': role,
        'authorityLevel': authorityLevel,
      };

      final result = await repo.createEmployee(data);

      if (result['status'] == true) {
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Employee added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!context.mounted) return false;
        await getEmployees(context, showLoading: false);
        return true;
      } else {
        throw result['message'] ?? 'Failed to add employee';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// -------- Edit Employee --------
  Future<bool> editEmployee(
    BuildContext context, {
    required String employeeId,
    required String name,
    required String email,
    required String role,
    required String authorityLevel,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final data = {
        'name': name,
        'email': email,
        'role': role,
        'authorityLevel': authorityLevel,
      };

      final result = await repo.updateEmployee(
        employeeId: employeeId,
        data: data,
      );

      if (result['status'] == true) {
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(result['message'] ?? 'Employee updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!context.mounted) return false;
        await getEmployees(context, showLoading: false);
        return true;
      } else {
        throw result['message'] ?? 'Failed to update employee';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// -------- Delete Employee --------
  /// -------- Delete Employee --------
  Future<void> deleteEmployee(BuildContext context, String employeeId) async {
    // ✅ Capture messenger BEFORE any async work
    final messenger = ScaffoldMessenger.of(context);

    try {
      _isLoading = true;
      notifyListeners();

      final result = await repo.deleteEmployee(employeeId);

      if (result['status'] == true) {
        if (!context.mounted) return;
        await getEmployees(context, showLoading: false);

        // ✅ Use captured messenger — safe after notifyListeners()
        messenger.showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Employee deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw result['message'] ?? 'Failed to delete employee';
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
