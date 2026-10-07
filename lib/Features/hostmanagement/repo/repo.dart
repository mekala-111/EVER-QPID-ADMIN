import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:http/http.dart' as http;

class HostManagementRepository {
  final BaseApiService apiService;
  HostManagementRepository(this.apiService);
  Future<Map<String, dynamic>> getAllHosts({
    required String pageNumber,
    required String pageSize,
    required String searchTag,
    required String toDate,
    required String fromDate,
    required String status,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getHsot,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "search": searchTag,
          "startDate": fromDate,
          "endDate": toDate,
          'status': status,
        },
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostDetails({
    required String hostId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getHsotdetails,
        token: LoggedInUser.accessToken,
        appned: hostId,
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserphotos({
    required String hostId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getHsotdetails,
        token: LoggedInUser.accessToken,
        appned: '$hostId/photos',
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteUserPhoto({
    required String userId,
    required int photoIndex,
  }) async {
    try {
      final result = await apiService.getDeleteApiResponse(
        '${AppUrl.deleteUserPhoto}/$userId/$photoIndex',
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

  Future<Map<String, dynamic>> deleteAllPhoto({
    required String userId,
  }) async {
    try {
      final result = await apiService.getDeleteApiResponse(
        '${AppUrl.deleteAllphoto}/$userId',
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

  Future<Map<String, dynamic>> getUsermatches({
    required String hostId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getHsotMatches,
        token: LoggedInUser.accessToken,
        appned: '$hostId/match',
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getChatlog({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getChatlog,
        token: LoggedInUser.accessToken,
        appned: userId,
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendLike({
    required String hostId,
    required String toUser,
  }) async {
    try {
      final result = await apiService.getPostApiResponse(
          '${AppUrl.getHsot}/$hostId/send-like',
          token: LoggedInUser.accessToken,
          body: {'toUserId': toUser});

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostlikes({
    required String hostId,
    required String pageNumber,
    required String pageSize,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(AppUrl.getHsotMatches,
          token: LoggedInUser.accessToken,
          appned: '$hostId/sent-likes',
          queryParameters: {
            "pageNumber": pageNumber,
            "pageSize": pageSize,
          });

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
  //create and updte
  // Add these functions to your HostManagementRepository class

// Add this to your repository file

  Future<Map<String, dynamic>> createHost({
    required Map<String, dynamic> hostData,
  }) async {
    try {
      final result = await apiService.getPostApiResponse(
        AppUrl.adminHost, // api/v1/host/admin-host
        token: LoggedInUser.accessToken,
        body: hostData,
      );

      // Don't throw on false status, let the viewmodel handle it
      return result;
    } catch (e) {
      // Return error response instead of rethrowing
      return {
        'status': false,
        'statusCode': 500,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateHost({
    required String hostId,
    required Map<String, dynamic> hostData,
  }) async {
    try {
      final endpoint = '${AppUrl.adminHost}/$hostId';

      final result = await apiService.getPutApiResponse(
        endpoint,
        token: LoggedInUser.accessToken,
        body: hostData,
      );

      // Don't throw on false status, let the viewmodel handle it
      return result;
    } catch (e) {
      // Return error response instead of rethrowing
      return {
        'status': false,
        'statusCode': 500,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteHost({
    required String hostId,
  }) async {
    try {
      final result = await apiService.getDeleteApiResponse(
        '${AppUrl.adminHost}/$hostId',
        token: LoggedInUser.accessToken,
      );

      return result;
    } catch (e) {
      return {
        'status': false,
        'statusCode': 500,
        'message': 'Network error: ${e.toString()}',
      };
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

  Future<Map<String, dynamic>> getNotes({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/profile/admin/notes',
        token: LoggedInUser.accessToken,
        appned: userId,
      );

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addNote(
      {required String userId, required String note}) async {
    try {
      final result = await apiService.getPostApiResponse(
          'api/v1/profile/admin/add-notes',
          token: LoggedInUser.accessToken,
          body: {"userId": userId, "notes": note});

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
}
