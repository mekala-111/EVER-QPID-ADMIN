import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/model/employeemodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/model/ticketsmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/repo/repo.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/error_msg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsViewModel extends ChangeNotifier {
  // -------------------- STATE --------------------
  bool loading = false;
  String? error;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  int totalPages = 0;

  List<Ticket> tickets = [];
  List<Employee> employees = [];

  // -------------------- FILTERS --------------------
  String? status;
  String? priority;
  String? searchKeyword;

  final TextEditingController searchController = TextEditingController();

  // -------------------- REPO --------------------
  final Ticketrepo repo = Ticketrepo(NetworkApiServiceV2());

  String ticketId = '';
  String userId = '';

  // -------------------- APPLY FILTERS --------------------
  void applyFilters(
    BuildContext context, {
    String? search,
    String? statusFilter,
    String? priorityFilter,
  }) {
    // Reset to page 1
    currentPage = 1;

    // Store filter values (convert empty strings to null)
    searchKeyword = (search == null || search.isEmpty) ? null : search;
    status =
        (statusFilter == null || statusFilter.isEmpty) ? null : statusFilter;
    priority = (priorityFilter == null || priorityFilter.isEmpty)
        ? null
        : priorityFilter;

    // Update search controller
    searchController.text = search ?? '';

    // Fetch tickets with new filters
    getAllTicketsFn(context);
  }

  // -------------------- CLEAR FILTERS --------------------
  void clearFilters(BuildContext context) {
    currentPage = 1;
    searchKeyword = null;
    status = null;
    priority = null;

    searchController.clear();

    getAllTicketsFn(context);
  }

  // -------------------- API CALL --------------------
  Future<void> getAllTicketsFn(BuildContext context) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      const int pageSize = 10;

      // Use stored filter values
      final result = await repo.getTickets(
        pageNumber: currentPage,
        pageSize: pageSize,
        search: searchKeyword,
        status: status,
        priority: priority,
      );

      if (result['statusCode'] == 200 && result['status'] == true) {
        final data = result['data'];

        if (data != null && data['tickets'] != null) {
          final List list = data['tickets'];

          tickets = list.map((e) => Ticket.fromJson(e)).toList();

          totalPages = data['totalCount'] != null
              ? (data['totalCount'] / pageSize).ceil()
              : 1;
        } else {
          tickets = [];
          error = 'No tickets found';
        }
      } else {
        tickets = [];
        error = result['message'] ?? 'Failed to fetch tickets';
      }
    } catch (e) {
      tickets = [];
      error = e.toString();
    } finally {
      loading = false;

      if (context.mounted) {
        notifyListeners();
        if (error != null) {
          ErrorMsg.showSnakError(context, error!);
        }
      }
    }
  }

  // -------------------- PAGINATION --------------------
  // These now maintain filters when changing pages
  void nextPage(BuildContext context) {
    if (currentPage < totalPages) {
      currentPage++;
      getAllTicketsFn(context);
    }
  }

  void prevPage(BuildContext context) {
    if (currentPage > 1) {
      currentPage--;
      getAllTicketsFn(context);
    }
  }

  // -------------------- ASSIGN TICKET --------------------
  Future<void> assignTicket(
    BuildContext context, {
    required String ticketId,
    required String assigneeName,
  }) async {
    if (!context.mounted) return;

    try {
      loading = true;
      notifyListeners();

      final result = await repo.assignTicket(
        ticketId: ticketId,
        employeeId: assigneeName,
      );

      if (result['statusCode'] == 200 && result['status'] == true) {
        if (!context.mounted) return;
        // Refresh with current filters maintained
        getAllTicketsFn(context);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket assigned successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        error = result['message'] ?? 'Failed to assign ticket';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
      }
    } catch (e) {
      error = e.toString();
      if (context.mounted) {
        ErrorMsg.showSnakError(context, error!);
      }
    } finally {
      loading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  // -------------------- CREATE TICKET --------------------
  Future<bool> createTicket(
    BuildContext context, {
    required String adminId,
    required String email,
    required String category,
    required String subject,
    required String description,
  }) async {
    if (!context.mounted) return false;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.createTicket(
        adminId: adminId,
        email: email,
        category: category,
        subject: subject,
        description: description,
      );

      if (result['statusCode'] == 201 && result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!context.mounted) return false;
        await getAllTicketsFn(context);

        return true;
      } else {
        error = result['message'] ?? 'Failed to create ticket';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();
      if (context.mounted) {
        ErrorMsg.showSnakError(context, error!);
      }
      return false;
    } finally {
      loading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  // -------------------- CLOSE TICKET --------------------
  Future<bool> closeTicket(BuildContext context) async {
    if (!context.mounted) return false;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.closeTicket(ticketId: ticketId);

      // Changed from 201 to 200 to match the actual API response
      if (result['status'] == 200 && result['message'] != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket closed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!context.mounted) return false;
        await getAllTicketsFn(context);

        // Navigate after refresh is complete
        if (context.mounted) {
          context
              .read<WrapperViewModel>()
              .updatePageIndex(GetWrapperPageViewStatus.tickets);
        }
        return true;
      } else {
        error = result['message'] ?? 'Failed to close ticket';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();
      if (context.mounted) {
        ErrorMsg.showSnakError(context, error!);
      }
      return false;
    } finally {
      loading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  Future<bool> cancelTicket(BuildContext context) async {
    if (!context.mounted) return false;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.cancelTicket(ticketId: ticketId);

      // Changed from 201 to 200 to match the actual API response
      if (result['status'] == 200 && result['message'] != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!context.mounted) return false;
        await getAllTicketsFn(context);

        // Navigate after refresh is complete
        if (context.mounted) {
          context
              .read<WrapperViewModel>()
              .updatePageIndex(GetWrapperPageViewStatus.tickets);
        }
        return true;
      } else {
        error = result['message'] ?? 'Failed to cancel ticket';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, error!);
        }
        return false;
      }
    } catch (e) {
      error = e.toString();
      if (context.mounted) {
        ErrorMsg.showSnakError(context, error!);
      }
      return false;
    } finally {
      loading = false;
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  // -------------------- GET EMPLOYEES --------------------
  Future<void> getCustomerSupportEmployees(BuildContext context) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.getAllEmployees(
        role: 'Customer Support',
      );

      if (result['statusCode'] == 200 && result['status'] == true) {
        final data = result['data'];

        if (data != null && data['employees'] != null) {
          final List list = data['employees'];

          employees = list.map((e) => Employee.fromJson(e)).toList();
        } else {
          employees = [];
          error = 'No employees found';
        }
      } else {
        employees = [];
        error = result['message'] ?? 'Failed to fetch employees';
      }
    } catch (e) {
      employees = [];
      error = e.toString();
    } finally {
      loading = false;
      if (context.mounted) {
        notifyListeners();
        if (error != null) {
          ErrorMsg.showSnakError(context, error!);
        }
      }
    }
  }

  String? deactivateUserError;

  Future<void> deActivateUserFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      deactivateUserError =
          null; // you may rename this to deactivateError later
      notifyListeners();

      final result = await repo.deActivateUser(
        userId: userId,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'User suspended successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (!context.mounted) return;
        getAllTicketsFn(context);
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.users);
      } else {
        deactivateUserError = result['message'] ?? 'Failed to suspend user';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, deactivateUserError!);
        }
      }
    } catch (e) {
      deactivateUserError = 'Error suspending user: ${e.toString()}';

      if (context.mounted) {
        notifyListeners();
        ErrorMsg.showSnakError(context, deactivateUserError!);
      }
    }
  }

  String? activateUserError;

  Future<void> activateUserFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      activateUserError = null; // you may rename this to deactivateError later
      notifyListeners();

      final result = await repo.activateUser(
        userId: userId,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'User suspended successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (!context.mounted) return;
        getAllTicketsFn(context);
        context
            .read<WrapperViewModel>()
            .updatePageIndex(GetWrapperPageViewStatus.tickets);
      } else {
        activateUserError = result['message'] ?? 'Failed to suspend user';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, activateUserError!);
        }
      }
    } catch (e) {
      activateUserError = 'Error suspending user: ${e.toString()}';

      if (context.mounted) {
        notifyListeners();
        ErrorMsg.showSnakError(context, activateUserError!);
      }
    }
  }

  bool _sendingMessage = false;
  bool get sendingMessage => _sendingMessage;
  String? _sendMessageError;
  String? get sendMessageError => _sendMessageError;

  Future<void> sentMessage(
    BuildContext context, {
    required String userId,
    required String content,
  }) async {
    if (!context.mounted) return;

    try {
      _sendingMessage = true;
      _sendMessageError = null;
      notifyListeners();

      final result = await repo.sentMessage(
        userId: userId,
        content: content,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        _sendMessageError = result['message'] ?? 'Failed to send message';
      }
    } catch (e) {
      _sendMessageError = e.toString();
    } finally {
      _sendingMessage = false;

      if (context.mounted) {
        notifyListeners();

        if (_sendMessageError != null) {
          ErrorMsg.showSnakError(context, _sendMessageError!);
        }
      }
    }
  }
}
