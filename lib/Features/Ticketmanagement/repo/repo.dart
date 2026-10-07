import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';

class Ticketrepo {
  final BaseApiService apiService;
  Ticketrepo(this.apiService);

  Future<Map<String, dynamic>> getTickets({
    required int pageNumber,
    required int pageSize,
    String? search,
    String? status,
    String? priority,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      if (priority != null && priority.isNotEmpty) {
        queryParams['priority'] = priority;
      }

      // Convert query params to URL string
      final queryString = queryParams.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final result = await apiService.getGetApiResponse(
        '${AppUrl.getAllTickets}?$queryString',
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

  Future<dynamic> assignTicket({
    required String ticketId,
    required String employeeId,
  }) async {
    try {
      final response = await apiService.getPutApiResponse(
          'api/v1/tickets/assign-ticket/$ticketId',
          body: {'employeeId': employeeId});

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAllEmployees({
    required String role,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        '${AppUrl.getAllEmployees}?role=$role',
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

  Future<Map<String, dynamic>> createTicket({
    required String adminId,
    required String email,
    required String category,
    required String subject,
    required String description,
  }) async {
    try {
      final body = {
        'adminId': adminId,
        'email': email,
        'category': category,
        'subject': subject,
        'description': description,
      };

      final response = await apiService.getPostApiResponse(
        'api/v1/tickets/create-ticket',
        body: body,
        token: LoggedInUser.accessToken,
      );

      if (response['status'] == false) {
        throw response['message'];
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTicketdetaisl({
    required String ticketId,
  }) async {
    try {
      final result = await apiService.getGetApiResponse(
        '${AppUrl.getticketDetails}/$ticketId',
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

  Future<Map<String, dynamic>> closeTicket({required String ticketId}) async {
    try {
      final response = await apiService.getPutApiResponse(
        'api/v1/tickets/close-ticket/$ticketId',
        token: LoggedInUser.accessToken,
      );

      if (response['status'] == false) {
        throw response['message'];
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> cancelTicket({required String ticketId}) async {
    try {
      final response = await apiService.getPutApiResponse(
        'api/v1/tickets/cancel-ticket/$ticketId',
        token: LoggedInUser.accessToken,
      );

      if (response['status'] == false) {
        throw response['message'];
      }

      return response;
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
