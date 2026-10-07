import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/hostmanagement/model/hostdetailsmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/model/hostmatchesmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/model/sendlikemodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/repo/repo.dart';
import 'package:everqpidadmin/Features/usermanagement/model/chatlogmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/model/notesmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/error_msg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hostdetailsviewmodel extends ChangeNotifier {
  final HostManagementRepository repo =
      HostManagementRepository(NetworkApiServiceV2());

  bool chatLogsLoading = false;
  String? chatLogsError;
  List<ChatLogModel> chatLogs = [];
  String? userId;

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

      if (result['status'] == true) {
        if (result['data'] != null && result['data'] is List) {
          chatLogs = (result['data'] as List)
              .map((e) => ChatLogModel.fromJson(e))
              .toList();
        } else {
          chatLogs = [];
        }
      } else {
        chatLogs = [];
        chatLogsError = result['message'] ?? 'Failed to load chat logs';
      }
    } catch (e) {
      chatLogs = [];
      chatLogsError = 'Error loading chat logs: ${e.toString()}';
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

  bool hostDetailsLoading = false;
  String? hostDetailsError;
  HostDetailsResponse? hostDetails;
  SideProfileDetails? sideProfileDetails;

  Future<void> getHostDetailsFn(
    BuildContext context, {
    required String hostId,
  }) async {
    if (!context.mounted) return;

    try {
      hostDetailsLoading = true;
      hostDetailsError = null;
      notifyListeners();

      final result = await repo.getHostDetails(hostId: hostId);

      if (result['status'] == true && result['data'] != null) {
        hostDetails = HostDetailsResponse.fromJson(result);
        if (result['data']['sideProfileDetails'] != null) {
          sideProfileDetails =
              SideProfileDetails.fromJson(result['data']['sideProfileDetails']);
        }
      } else {
        hostDetails = null;
        hostDetailsError = result['message'] ?? 'Failed to load host details';
      }
    } catch (e) {
      hostDetails = null;
      hostDetailsError = 'Error loading host details: ${e.toString()}';
    } finally {
      hostDetailsLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (hostDetailsError != null) {
          ErrorMsg.showSnakError(context, hostDetailsError!);
        }
      }
    }
  }

  void clearHostDetails() {
    hostDetails = null;
    hostDetailsError = null;
    notifyListeners();
  }

  bool photosLoading = false;
  String? photosError;
  List<String> userPhotos = [];

  Future<void> getHostPhotosFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      photosLoading = true;
      photosError = null;
      notifyListeners();

      final result = await repo.getUserphotos(hostId: userId);

      if (result['status'] == true) {
        if (result['data'] != null && result['data'] is List) {
          userPhotos = (result['data'] as List)
              .where((e) => e != null && e is String && e.isNotEmpty)
              .cast<String>()
              .toList();
        } else {
          userPhotos = [];
        }
      } else {
        userPhotos = [];
        photosError = result['message'] ?? 'Failed to load photos';
      }
    } catch (e) {
      userPhotos = [];
      photosError = 'Error loading photos: ${e.toString()}';
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

  Future<void> deleteHostPhotoFn(
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
        if (photoIndex >= 0 && photoIndex < userPhotos.length) {
          userPhotos.removeAt(photoIndex);
          notifyListeners();
        }

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

  Future<void> deleteAllHostPhotosFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      final result = await repo.deleteAllPhoto(userId: userId);

      if (result['status'] == true) {
        userPhotos.clear();
        notifyListeners();

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

  bool matchesLoading = false;
  String? matchesError;
  List<UserMatch> userMatches = [];
  bool hasNextMatches = false;
  int totalMatches = 0;

  Future<void> getHostMatchesFn(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      matchesLoading = true;
      matchesError = null;
      notifyListeners();

      final result = await repo.getUsermatches(hostId: userId);

      if (result['status'] == true && result['data'] != null) {
        final data = MatchesData.fromJson(result['data']);

        userMatches = data.matches;
        totalMatches = data.totalCount;
        hasNextMatches = data.hasNext;
      } else {
        userMatches = [];
        totalMatches = 0;
        hasNextMatches = false;
        matchesError = result['message'] ?? 'Failed to load matches';
      }
    } catch (e) {
      userMatches = [];
      totalMatches = 0;
      hasNextMatches = false;
      matchesError = 'Error loading matches: ${e.toString()}';
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

  // ================= SENT LIKES =================

  bool sentLikesLoading = false;
  String? sentLikesError;

  List<SentLikeUser> sentLikes = [];
  bool hasNextSentLikes = false;
  int totalSentLikes = 0;

  Future<void> sendLikeFn(
    BuildContext context, {
    required String hostId,
    required String toUserId,
  }) async {
    if (!context.mounted) return;

    try {
      sentLikesError = null;
      notifyListeners();

      final result = await repo.sendLike(
        hostId: hostId,
        toUser: toUserId,
      );

      if (result['status'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Like sent successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        sentLikesError = result['message'] ?? 'Failed to send like';
        if (context.mounted) {
          ErrorMsg.showSnakError(context, sentLikesError!);
        }
      }
    } catch (e) {
      sentLikesError = 'Error sending like: ${e.toString()}';

      if (context.mounted) {
        notifyListeners();
        ErrorMsg.showSnakError(context, sentLikesError!);
      }
    }
  }

  Future<void> getHostSentLikesFn(
    BuildContext context, {
    required String hostId,
    required int pageNumber,
    required int pageSize,
    bool loadMore = false,
  }) async {
    if (!context.mounted) return;

    try {
      sentLikesLoading = true;
      sentLikesError = null;
      notifyListeners();

      final result = await repo.getHostlikes(
        hostId: hostId,
        pageNumber: pageNumber.toString(),
        pageSize: pageSize.toString(),
      );

      if (result['status'] == true && result['data'] != null) {
        final data = SentLikesData.fromJson(result['data']);

        if (loadMore) {
          sentLikes.addAll(data.sentLikes);
        } else {
          sentLikes = data.sentLikes;
        }

        totalSentLikes = data.totalCount;
        hasNextSentLikes = data.hasNext;
      } else {
        if (!loadMore) {
          sentLikes = [];
          totalSentLikes = 0;
          hasNextSentLikes = false;
        }
        sentLikesError = result['message'] ?? 'Failed to load sent likes';
      }
    } catch (e) {
      if (!loadMore) {
        sentLikes = [];
        totalSentLikes = 0;
        hasNextSentLikes = false;
      }
      sentLikesError = 'Error loading sent likes: ${e.toString()}';
    } finally {
      sentLikesLoading = false;

      if (context.mounted) {
        notifyListeners();

        if (sentLikesError != null) {
          ErrorMsg.showSnakError(context, sentLikesError!);
        }
      }
    }
  }

  void clearSentLikes() {
    sentLikes.clear();
    totalSentLikes = 0;
    hasNextSentLikes = false;
    sentLikesError = null;
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

  Future<void> deleteHost(
    BuildContext context, {
    required String userId,
  }) async {
    if (!context.mounted) return;

    try {
      addNoteLoading = true;
      addNoteError = null;
      notifyListeners();

      final result = await repo.deleteHost(
        hostId: userId,
      );

      if (result['status'] == true) {
        // Optionally update local notes immediately

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Host deleted successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context
              .read<WrapperViewModel>()
              .updatePageIndex(GetWrapperPageViewStatus.allhost);
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
