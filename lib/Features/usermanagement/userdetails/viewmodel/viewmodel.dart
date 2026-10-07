import 'package:everqpidadmin/Features/usermanagement/model/chatlogmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/model/helpsupport.dart';
import 'package:everqpidadmin/Features/usermanagement/model/notesmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/model/transactionmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/model/userdetailsmodel.dart'
    hide Note;
import 'package:everqpidadmin/Features/usermanagement/model/usermatchesmodel.dart';
import 'package:flutter/material.dart';
import 'package:everqpidadmin/Features/usermanagement/repo/repo.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import '../../../../../Settings/common/widgets/error_msg.dart';

class UserDetailsViewModel extends ChangeNotifier {
  // -------------------- STATE --------------------
  bool loading = false;
  String? error;
  UserProfile? userProfile;

  // -------------------- REPO --------------------
  final UserManagementRepository repo =
      UserManagementRepository(NetworkApiServiceV2());
  String? userId;

  // -------------------- API CALL --------------------
  SideProfileDetails? sideProfileDetails;

  Future<void> getUserDetailsFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      loading = true;
      error = null;
      notifyListeners();

      final result = await repo.getUserDetails(userId: userId);

      if (result['status'] == true &&
          result['statusCode'] == 200 &&
          result['data'] != null) {
        // Parse both userProfile and sideProfileDetails
        if (result['data']['userProfile'] != null) {
          userProfile = UserProfile.fromJson(result['data']['userProfile']);
        }

        if (result['data']['sideProfileDetails'] != null) {
          sideProfileDetails =
              SideProfileDetails.fromJson(result['data']['sideProfileDetails']);
        }
      } else {
        userProfile = null;
        sideProfileDetails = null;
        error = result['message'] ?? 'Failed to load user details';
      }
    } catch (e) {
      userProfile = null;
      sideProfileDetails = null;
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

  // -------------------- CLEAR --------------------
  void clearUserDetails() {
    userProfile = null;
    error = null;
    notifyListeners();
  }

  // -------------------- PHOTOS --------------------
  bool photosLoading = false;
  String? photosError;
  List<String> userPhotos = [];

  Future<void> getUserPhotosFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      photosLoading = true;
      photosError = null;
      notifyListeners();

      final result = await repo.getUserphotos(userId: userId);

      if (result['status'] == true && result['photos'] != null) {
        userPhotos = List<String>.from(result['photos']);
      } else {
        userPhotos = [];
        photosError = result['message'] ?? 'Failed to load user photos';
      }
    } catch (e) {
      userPhotos = [];
      photosError = e.toString();
    } finally {
      photosLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (photosError != null) {
          ErrorMsg.showSnakError(context, photosError!);
        }
      }
    }
  }

  Future<void> deleteUserPhotoFn(
    BuildContext context, {
    required String userId,
    required int photoIndex,
  }) async {
    if (!context.mounted) return;

    try {
      final result = await repo.deleteUserPhoto(
        userId: userId,
        photoIndex: photoIndex,
      );

      if (result['status'] == true) {
        userPhotos.removeAt(photoIndex);
        notifyListeners();

        // Show success toast
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo removed successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw result['message'] ?? 'Failed to delete photo';
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMsg.showSnakError(context, e.toString());
      }
    }
  }

  Future<void> deleteAllUserPhotosFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      final result = await repo.deleteAllPhoto(userId: userId);

      if (result['status'] == true) {
        userPhotos.clear();
        notifyListeners();

        // Show success toast
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All photos removed successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw result['message'] ?? 'Failed to delete all photos';
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMsg.showSnakError(context, e.toString());
      }
    }
  }

  // -------------------- MATCHES --------------------
  bool matchesLoading = false;
  String? matchesError;
  List<UserMatch> userMatches = [];
  bool hasNextMatches = false;
  int totalMatches = 0;
  Future<void> getUserMatchesFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      matchesLoading = true;
      matchesError = null;
      notifyListeners();

      final result = await repo.getUsermatches(userId: userId);

      if (result['status'] == true &&
          result['data'] != null &&
          result['data']['matches'] != null) {
        final data = MatchesData.fromJson(result['data']);

        userMatches = data.matches;
        totalMatches = data.totalCount;
        hasNextMatches = data.hasNext;
      } else {
        userMatches = [];
        matchesError = result['message'] ?? 'Failed to load matches';
      }
    } catch (e) {
      userMatches = [];
      matchesError = e.toString();
    } finally {
      matchesLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (matchesError != null) {
          ErrorMsg.showSnakError(context, matchesError!);
        }
      }
    }
  }

  void clearUserMatches() {
    userMatches = [];
    totalMatches = 0;
    hasNextMatches = false;
    matchesError = null;
    notifyListeners();
  }

// -------------------- CHAT LOGS --------------------
  bool chatLogsLoading = false;
  String? chatLogsError;
  List<ChatLogModel> chatLogs = [];
  Future<void> getChatLogsFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      chatLogsLoading = true;
      chatLogsError = null;
      notifyListeners();

      final result = await repo.getChatlog(userId: userId);

      if (result['status'] == true &&
          result['data'] != null &&
          result['data'] is List) {
        chatLogs = (result['data'] as List)
            .map((e) => ChatLogModel.fromJson(e))
            .toList();
      } else {
        chatLogs = [];
        chatLogsError = result['message'] ?? 'Failed to load chat logs';
      }
    } catch (e) {
      chatLogs = [];
      chatLogsError = e.toString();
    } finally {
      chatLogsLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (chatLogsError != null) {
          ErrorMsg.showSnakError(context, chatLogsError!);
        }
      }
    }
  }

  void clearChatLogs() {
    chatLogs.clear();
    chatLogsError = null;
    notifyListeners();
  }

  bool transactionsLoading = false;
  String? transactionsError;
  List<TransactionModel> transactions = [];

  Future<void> getTransactionsFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      transactionsLoading = true;
      transactionsError = null;
      notifyListeners();

      final result = await repo.getTransactions(userId: userId);

      if (result['status'] == true &&
          result['data'] != null &&
          result['data'] is List) {
        transactions = (result['data'] as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
      } else {
        transactions = [];
        transactionsError = result['message'] ?? 'Failed to load transactions';
      }
    } catch (e) {
      transactions = [];
      transactionsError = e.toString();
    } finally {
      transactionsLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (transactionsError != null) {
          ErrorMsg.showSnakError(context, transactionsError!);
        }
      }
    }
  }

  void clearTransactions() {
    transactions.clear();
    transactionsError = null;
    notifyListeners();
  }

  bool ticketsLoading = false;
  String? ticketsError;
  List<TicketModel> tickets = [];

  Future<void> getTicketsFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      ticketsLoading = true;
      ticketsError = null;
      notifyListeners();

      final result = await repo.getSupport(userId: userId);

      if (result['status'] == true &&
          result['data'] != null &&
          result['data'] is List) {
        tickets = (result['data'] as List)
            .map((e) => TicketModel.fromJson(e))
            .toList();
      } else {
        tickets = [];
        ticketsError = result['message'] ?? 'Failed to load tickets';
      }
    } catch (e) {
      tickets = [];
      ticketsError = e.toString();
    } finally {
      ticketsLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (ticketsError != null) {
          ErrorMsg.showSnakError(context, ticketsError!);
        }
      }
    }
  }

  void clearTickets() {
    tickets.clear();
    ticketsError = null;
    notifyListeners();
  }

// -------------------- REPORTED USER DETAILS --------------------
  bool reportedUserLoading = false;
  String? reportedUserError;

  bool notesLoading = false;
  String? notesError;
  NotesData? notesData;
  // In your getUserNotesFn, add these logs:
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
