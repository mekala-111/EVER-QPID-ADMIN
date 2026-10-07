import '../../../Data/LocaStorage/loggedin_user.dart';
import '../../../Data/Network/network_api_service_v2.dart';
import '../../../Settings/constants/app_url.dart';
import '../../../employeelogin/chatmangaement/socketservice/socketservice.dart';

class AuthService {
  AuthService._();

  static Future<bool> restoreSession() {
    return NetworkApiServiceV2.ensureValidSession();
  }

  static Future<void> logout() async {
    // Best-effort server-side logout; local cleanup must happen regardless.
    if (LoggedInUser.accessToken?.isNotEmpty ?? false) {
      try {
        await NetworkApiServiceV2().getPostApiResponse(
          AppUrl.userLogout,
          body: {'refreshToken': LoggedInUser.refreshToken},
        );
      } catch (_) {
        // Ignore network failures during logout.
      }
    }
    await SocketService.instance.dispose();
    await LoggedInUser.clearUserData();
  }
}
