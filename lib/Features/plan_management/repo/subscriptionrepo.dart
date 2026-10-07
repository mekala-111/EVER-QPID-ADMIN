import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:http/http.dart' as http;

class Subscriptionrepo {
  final BaseApiService apiService;
  Subscriptionrepo(this.apiService);

  getSubscriptions({
    required String pageNumber,
    required String pageSize,
  }) async {
    try {
      var result = await apiService.getGetApiResponse(
        AppUrl.getAllSub,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        },
      );

      if (result == null) {
        throw "Null result received from API";
      }

      if (result['status'] == false) {
        throw result['message'];
      }

      if (result['data'] == null) {
      } else {
        if (result['data']['subscriptions'] != null &&
            result['data']['subscriptions'] is List) {
        } else {}
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createSubscription({
    required Map<String, dynamic> planData,
  }) async {
    try {
      var result = await apiService.getPostApiResponse(
        AppUrl.createSub, // Make sure this endpoint exists in AppUrl
        token: LoggedInUser.accessToken,
        body: planData,
      );

      if (result == null) {
        throw "Null result received from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to create subscription";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Update existing subscription plan
  Future<dynamic> updateSubscription({
    required String subscriptionId,
    required Map<String, dynamic> planData,
  }) async {
    try {
      var result = await apiService.getPutApiResponse(
        "${AppUrl.updateSub}/$subscriptionId", // Adjust endpoint as needed
        token: LoggedInUser.accessToken,
        body: planData,
      );

      if (result == null) {
        throw "Null result received from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to update subscription";
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Delete subscription plan
  Future<dynamic> deleteSubscription({
    required String subscriptionId,
  }) async {
    try {
      var result = await apiService.getDeleteApiResponse(
        "${AppUrl.deleteSub}/$subscriptionId",
        token: LoggedInUser.accessToken,
      );

      if (result == null) {
        throw "Null result received from API";
      }

      if (result['status'] == false) {
        throw result['message'] ?? "Failed to delete subscription";
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
}
