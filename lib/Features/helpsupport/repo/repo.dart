import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class HelpRepo {
  final BaseApiService apiService;
  HelpRepo(this.apiService);
  getEmail() async {
    try {
      var result = await apiService.getGetApiResponse(
        AppUrl.getEmail,
        token: LoggedInUser.accessToken,
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

  updateEmail({required String email}) async {
    try {
      var result = await apiService.getPutApiResponse(AppUrl.updateEmail,
          token: LoggedInUser.accessToken, body: {'email': email});

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
