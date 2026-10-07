import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';

class LikeManagementRepo {
  final BaseApiService apiService;
  LikeManagementRepo(this.apiService);

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

  Future<Map<String, dynamic>> getReceivedLikes(String hostId) async {
    try {
      final result = await apiService.getGetApiResponse(
        'api/v1/matching/host/$hostId/received-likes',
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null response from received likes API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Received likes API error";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> likeBackuser({
    required String hostId,
    required String userId,
  }) async {
    try {
      final result = await apiService.getPostApiResponse(
          'api/v1/matching/host/$hostId/like-back',
          token: LoggedInUser.accessToken,
          body: {
            "toUserId": userId,
          });

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
