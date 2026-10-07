import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';

import '../../../../Data/Network/base_api_service.dart';
import '../../../Settings/constants/app_url.dart';

class AuthRepository {
  final BaseApiService apiService;
  AuthRepository(this.apiService);
  Future<Map<String, dynamic>> login({
    required String email,
    required String passwords,
  }) async {
    final result = await apiService.getPostApiResponse(
      AppUrl.login,
      body: {'email': email, 'password': passwords},
    );
    if (result['status'] != true) {
      throw result['message'];
    }
    final response = Map<String, dynamic>.from(result as Map);
    await LoggedInUser.loginFromResponse(response);
    return response;
  }

  Future<bool> forgotPass(String email) async {
    final result = await apiService.getPostApiResponse(
      AppUrl.forgot,
      body: {"email": email},
    );

    if (result['status'] != true) {
      throw result['message'];
    }

    return true;
  }

  Future<bool> verifyOtp(String email, String otp, String newPassword) async {
    final result = await apiService.getPostApiResponse(
      AppUrl.verifyOtp,
      body: {"email": email, "otp": otp},
    );

    if (result['status'] != true) {
      throw result['message'];
    }

    return true;
  }

  Future<bool> reset(
    String email,
    String confirmPassword,
    String newPassword,
  ) async {
    final result = await apiService.getPostApiResponse(
      AppUrl.reset,
      body: {
        "email": email,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
    );

    if (result['status'] == false) {
      throw result['message'];
    }

    return true;
  }
}
