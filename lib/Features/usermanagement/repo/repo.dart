import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class UserManagementRepository {
  final BaseApiService apiService;
  UserManagementRepository(this.apiService);
  Future<Map<String, dynamic>> getAllUsers(
      {required String pageNumber,
      required String pageSize,
      required String searchTag,
      required String toDate,
      required String fromDate,
      required String status,
      required String gender}) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getAllUsers,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "searchTag": searchTag,
          "endDate": toDate,
          "startDate": fromDate,
          'status': status,
          'gender': gender
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

  Future<Map<String, dynamic>> getUserDetails({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getUserDetails,
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

  Future<Map<String, dynamic>> getUserphotos({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getUserPhotos,
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
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getUsermatches,
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

  Future<Map<String, dynamic>> getSupport({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getSupport,
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

  Future<Map<String, dynamic>> getTransactions({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getTransaction,
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

  Future<Map<String, dynamic>> getReportedUsers(
      {required String pageNumber,
      required String pageSize,
      required String searchTag,
      required String toDate,
      required String fromDate,
      required String status,
      required String gender}) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getReportedUSers,
        token: LoggedInUser.accessToken,
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "search": searchTag,
          "endDate": toDate,
          "startDate": fromDate,
          'status': status,
          'gender': gender
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

  Future<Map<String, dynamic>> getReportedUserDetails({
    required String userId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        AppUrl.getReporteduserdetails,
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

  Future<Map<String, dynamic>> deActivateUser({
    required String userId,
  }) async {
    try {
      final result = await apiService.getPostApiResponse(
        'api/v1/report/suspend-user/$userId',
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

  Future<Map<String, dynamic>> activateUser({
    required String userId,
  }) async {
    try {
      final result = await apiService.getPostApiResponse(
        'api/v1/report/activate-user/$userId',
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

  Future<Map<String, dynamic>> sentMessage(
      {required String userId, required String content}) async {
    try {
      final result = await apiService.getPostApiResponse(
          'api/v1/message/admin/send-message',
          token: LoggedInUser.accessToken,
          body: {"userId": userId, "content": content});

      if (result['status'] == false) {
        throw result['message'];
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
