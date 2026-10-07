import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class ChatManagementRepo {
  final BaseApiService apiService;
  ChatManagementRepo(this.apiService);

  // Update the getRecentChats method in ChatManagementRepo class

  Future<dynamic> getRecentChats({
    required String employeeId,
    required String hostId,
    required String pageNumber,
    required String pageSize,
    String? city,
    String? language,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      // Add optional filters
      if (city != null && city.isNotEmpty) {
        queryParams['locationString'] = city;
      }
      if (language != null && language.isNotEmpty) {
        queryParams['otherLanguages'] = language;
      }

      // Build URL with path parameters and query parameters
      final uri = Uri.parse(
              'api/v1/employee/employees/$employeeId/hosts/$hostId/recent-chats')
          .replace(queryParameters: queryParams);

      final response = await apiService.getGetApiResponse(uri.toString());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getChatHistoryByAdmin({
    required String hostId,
    required String userId,
    required String pageNumber,
    required String pageSize,
  }) async {
    try {
      final url = "${AppUrl.chatHistoryByAdmin}/$hostId/$userId";

      final result = await apiService.getGetApiResponse(
        url,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        },
      );

      if (result == null) {
        throw "Null response from chat history API";
      }

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getchatEmployees() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/chat-support-employees', // 🔁 replace with correct API
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from chat API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Chat API error";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHost({required String employeeId}) async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/employees/$employeeId/assigned-hosts', // 🔁 replace with correct API
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from chat API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Chat API error";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostLanguages() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/host-languages',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from host-languages API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Host languages API error";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostLocations() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/host-locations',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from host-locations API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Host locations API error";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
