import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class ClanManagementrepo {
  final BaseApiService apiService;
  ClanManagementrepo(this.apiService);

  getClanusers({
    required String pageNumber,
    required String pageSize,
  }) async {
    try {
      var result = await apiService.getGetApiResponse(
        AppUrl.getclanUsers,
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
}
