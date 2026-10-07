import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:http/http.dart' as http;

class EmployeeChatManagementRepo {
  final BaseApiService apiService;
  EmployeeChatManagementRepo(this.apiService);

  // Update the getRecentChats method in ChatManagementRepo class

  Future<dynamic> getRecentChats({
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
      final uri = Uri.parse('api/v1/employee/recent-chat/$hostId')
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
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/history/host/$hostId/user/$userId/chat',
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

  Future<Map<String, dynamic>> getHost() async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/assigned-hosts', // 🔁 replace with correct API
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
        'api/v1/employee/host-languages-employee',
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
        'api/v1/employee/host-locations-employee',
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

  Future<String> profileSignedUrl({
    required String fileName,
    required String fieldName,
  }) async {
    try {
      var result = await apiService.getPostApiResponse(
        AppUrl.getsignedUrl,
        token: LoggedInUser.accessToken,
        body: {"fileName": fileName, "fieldName": fieldName},
      );
      var json = result; //jsonDecode(result);
      if (json["status"] == false) {
        throw result['message'];
      }
      return json['data']['signedUrl'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadToSignedUrl({
    required String signedUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    final response = await http.put(
      Uri.parse(signedUrl),
      headers: {"Content-Type": contentType},
      body: bytes,
    );

    if (response.statusCode != 200) {
      throw Exception("S3 upload failed");
    }
  }

  Future<Map<String, dynamic>> getUserDetails({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/employee/$userId/details',
        token: LoggedInUser.accessToken,
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
