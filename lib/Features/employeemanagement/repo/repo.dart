import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:intl/intl.dart';

class EmployeeRepo {
  final BaseApiService apiService;
  EmployeeRepo(this.apiService);

  Future<Map<String, dynamic>> getEmployees({
    required String pageNumber,
    required String pageSize,
    String? status,
    String? role,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };

      // ✅ Optional filters
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (fromDate != null) {
        queryParams['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }
      if (toDate != null) {
        queryParams['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final result = await apiService.getGetApiResponse(
        AppUrl.getEmployee,
        token: LoggedInUser.accessToken,
        queryParameters: queryParams,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to fetch employees";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteEmployee(String employeeId) async {
    try {
      final endpoint = "${AppUrl.deleteEmployee}/$employeeId";

      final result = await apiService.getDeleteApiResponse(
        endpoint,
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Failed to delete employee - no response from server";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateEmployee({
    required String employeeId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = await apiService.getPutApiResponse(
        "${AppUrl.editEmployee}/$employeeId",
        body: data,
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to update employee";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createEmployee(Map<String, dynamic> data) async {
    try {
      final result = await apiService.getPostApiResponse(
        AppUrl.addEmployee,
        body: data,
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to create employee";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
