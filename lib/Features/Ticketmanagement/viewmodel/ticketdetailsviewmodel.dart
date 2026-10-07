import 'package:everqpidadmin/Features/Ticketmanagement/model/ticketdetailsmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/repo/repo.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/usermanagement/model/notesmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/error_msg.dart';
import 'package:flutter/material.dart';

class TicketDetailsViewModel extends ChangeNotifier {
  // -------------------- STATE --------------------
  bool loading = false;
  String? error;

  Ticket? ticket;
  SideProfileDetails? sideProfileDetails;
  String? tcketId;

  // -------------------- REPO --------------------
  final Ticketrepo repo = Ticketrepo(NetworkApiServiceV2());
  bool isClosed = false; // ✅ added

  // -------------------- FETCH TICKET DETAILS --------------------
  Future<void> getTicketDetails(
    BuildContext context, {
    required String ticketId,
  }) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.getTicketdetaisl(ticketId: ticketId);

      if (result['statusCode'] == 200 && result['status'] == true) {
        final data = result['data'];

        if (data != null) {
          ticket = Ticket.fromJson(data['ticket']);
          isClosed = data['isClosed'] ?? false;

          sideProfileDetails = data['sideProfileDetails'] != null
              ? SideProfileDetails.fromJson(data['sideProfileDetails'])
              : null;
        }
      } else {
        error = result['message'];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  bool get ticketIsClosed => isClosed;

  // -------------------- CLEAR DATA --------------------
  void clear() {
    ticket = null;
    sideProfileDetails = null;
    error = null;
    notifyListeners();
  }

  bool notesLoading = false;
  String? notesError;
  NotesData? notesData;
  Future<void> getUserNotesFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      notesLoading = true;
      notesError = null;
      notifyListeners();

      final result = await repo.getNotes(userId: userId);

      if (result['status'] == true && result['data'] != null) {
        notesData = NotesData.fromJson(result['data']);
      } else {
        notesData = null;
        notesError = result['message'] ?? 'Failed to load notes';
      }
    } catch (e) {
      notesData = null;
      notesError = e.toString();
    } finally {
      notesLoading = false;

      if (context.mounted) {
        notifyListeners();
        if (notesError != null) {
          ErrorMsg.showSnakError(context, notesError!);
        }
      }
    }
  }

  void clearUserNotes() {
    notesData = null;
    notesError = null;
    notifyListeners();
  }

  bool addNoteLoading = false;
  String? addNoteError;

  Future<void> addUserNoteFn(
    BuildContext context, {
    required String userId,
    required String note,
  }) async {
    if (!context.mounted) return;

    try {
      addNoteLoading = true;
      addNoteError = null;
      notifyListeners();

      final result = await repo.addNote(
        userId: userId,
        note: note,
      );

      if (result['status'] == true) {
        /// ✅ Preserve existing notes
        final existingNotes = List<Note>.from(
          notesData?.notes ?? [],
        );

        /// ✅ Add new note (optimistic)
        existingNotes.add(
          Note(
            note: note,
            addedBy: userId, // or "admin"
            createdAt: DateTime.now().toUtc(),
          ),
        );

        notesData = NotesData(
          notes: existingNotes,
          updatedAt: DateTime.now().toUtc(),
        );

        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note added successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        addNoteError = result['message'] ?? 'Failed to add note';
      }
    } catch (e) {
      addNoteError = e.toString();
    } finally {
      addNoteLoading = false;

      if (context.mounted) {
        notifyListeners();
        if (addNoteError != null) {
          ErrorMsg.showSnakError(context, addNoteError!);
        }
      }
    }
  }
}
