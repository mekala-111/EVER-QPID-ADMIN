import 'dart:typed_data';

import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Settings/constants/app_url.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/chathistorymodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/hostmodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/recentchatmodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/userdetailsmodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/repo/repo.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/socketservice/socketservice.dart';
import 'package:flutter/material.dart';

class EmployeeChatManagementViewModel extends ChangeNotifier {
  final EmployeeChatManagementRepo repo =
      EmployeeChatManagementRepo(NetworkApiServiceV2());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int pageSize = 10;

  int totalCount = 0;
  bool hasNext = false;

  List<ChatItem> chats = [];

  // Selected chat tracking
  int? selectedChatIndex;
  ChatItem? selectedChat;
  List<ChatMessage> messages = [];

  // Store selected host ID only (no host details in response)
  String? selectedHostId;

  // Filter state
  String? _filterHostId;
  String? _filterCity;
  String? _filterLanguage;

  String? get filterHostId => _filterHostId;
  String? get filterCity => _filterCity;
  String? get filterLanguage => _filterLanguage;

  // Typing indicator state
  bool _isUserTyping = false;
  bool get isUserTyping => _isUserTyping;

  // Socket initialization flag
  bool _isSocketInitialized = false;

  // Media upload state
  bool _isUploadingMedia = false;
  bool get isUploadingMedia => _isUploadingMedia;

  /// Initialize socket connection and set up listeners
  Future<void> initializeSocket() async {
    if (_isSocketInitialized) {
      return;
    }

    final currentUserId = LoggedInUser.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      return;
    }

    try {
      await SocketService.instance
          .initialize(currentUserId, serverUrl: AppUrl.baseurl);

      SocketService.instance.setChatEventCallbacks(
        onNewMessage: _handleIncomingMessage,
        onTyping: _handleUserTyping,
        onStopTyping: _handleUserStopTyping,
        onReadStatus: _handleReadStatusUpdate,
        onUserStatus: _handleUserStatusChange,
      );

      _isSocketInitialized = true;

      SocketService.instance.joinUserRoom(currentUserId);
    } catch (_) {
      _isSocketInitialized = false;
    }
  }

  /// Handle typing indicator
  void _handleUserTyping(String senderId, String receiverId) {
    try {
      if (selectedChat != null && senderId == selectedChat!.userId) {
        _isUserTyping = true;
        notifyListeners();
      }
    } catch (_) {
      _isUserTyping = false;
    }
  }

  /// Handle stop typing indicator
  void _handleUserStopTyping(String senderId, String receiverId) {
    try {
      if (selectedChat != null && senderId == selectedChat!.userId) {
        _isUserTyping = false;
        notifyListeners();
      }
    } catch (_) {
      _isUserTyping = false;
    }
  }

  /// Handle read status update
  void _handleReadStatusUpdate(Map<String, dynamic> data) {}

  /// Handle user status change (online/offline)
  void _handleUserStatusChange(String userId, bool isOnline) {
    try {
      if (selectedChat != null && userId == selectedChat!.userId) {
        notifyListeners();
      }

      final chatIndex = chats.indexWhere((chat) => chat.userId == userId);
      if (chatIndex != -1) {
        getChats();
      }
    } catch (_) {
      _isSocketInitialized = false;
    }
  }

  Future<bool> uploadAndSendAudio({
    required BuildContext context,
    required Uint8List audioBytes,
    required String fileName,
  }) async {
    if (selectedChat == null || selectedHostId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No chat selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    try {
      _isUploadingMedia = true;
      notifyListeners();

      // Get signed URL for audio
      final signedUrl = await repo.profileSignedUrl(
        fileName: fileName,
        fieldName: 'chatMedia',
      );

      // Upload to S3 with correct audio content type
      await repo.uploadToSignedUrl(
        signedUrl: signedUrl,
        bytes: audioBytes,
        contentType: 'audio/webm', // Changed from audio/mp4
      );

      // Extract the actual file URL (without query parameters)
      final mediaUrl = signedUrl.split('?').first;

      // Send message with audio type - FIXED: Use 'audio' type explicitly
      await sendMessage('', mediaUrl, messageType: 'audio');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice message sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send voice message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      _isUploadingMedia = false;
      notifyListeners();
    }
  }

  /// Update the sendMessage method to handle audio type
  Future<void> sendMessage(String content, String mediaUrl,
      {String? messageType}) async {
    if (selectedChat == null || selectedHostId == null) {
      return;
    }

    if (content.trim().isEmpty && mediaUrl.trim().isEmpty) {
      return;
    }

    final currentEmployeeId = LoggedInUser.id;
    if (currentEmployeeId == null) {
      return;
    }

    try {
      // Determine message type if not explicitly provided
      String finalMessageType = messageType ?? 'text';

      if (messageType == null && mediaUrl.isNotEmpty) {
        // Auto-detect type from URL
        final lowerUrl = mediaUrl.toLowerCase();
        if (lowerUrl.contains('.webm') ||
            lowerUrl.contains('.m4a') ||
            lowerUrl.contains('.mp3') ||
            lowerUrl.contains('.wav') ||
            lowerUrl.contains('audio')) {
          finalMessageType = 'audio';
        } else if (lowerUrl.contains('.jpg') ||
            lowerUrl.contains('.jpeg') ||
            lowerUrl.contains('.png') ||
            lowerUrl.contains('.gif') ||
            lowerUrl.contains('image')) {
          finalMessageType = 'image';
        }
      }

      SocketService.instance.sendPrivateMessage(
        receiverId: selectedHostId!,
        senderId: selectedChat!.userId,
        content: content,
        messageType: finalMessageType,
        mediaUrl: mediaUrl,
      );

      // Wait for socket to process
      await Future.delayed(const Duration(milliseconds: 800));

      // Reload messages
      await _reloadCurrentChatMessages();
    } catch (_) {
      rethrow;
    }
  }

  /// UPDATED uploadAndSendMedia to use new sendMessage signature
  Future<bool> uploadAndSendMedia({
    required BuildContext context,
    required Uint8List imageBytes,
    required String fileName,
    String caption = '',
  }) async {
    if (selectedChat == null || selectedHostId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No chat selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    try {
      _isUploadingMedia = true;
      notifyListeners();

      // Determine content type
      String contentType = 'image/jpeg';
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      }

      // Get signed URL
      final signedUrl = await repo.profileSignedUrl(
        fileName: fileName,
        fieldName: 'chatMedia',
      );

      // Upload to S3
      await repo.uploadToSignedUrl(
        signedUrl: signedUrl,
        bytes: imageBytes,
        contentType: contentType,
      );

      // Extract the actual file URL (without query parameters)
      final mediaUrl = signedUrl.split('?').first;

      // Send message with explicit image type
      await sendMessage(caption, mediaUrl, messageType: 'image');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      _isUploadingMedia = false;
      notifyListeners();
    }
  }

  /// Handle incoming messages from socket
  void _handleIncomingMessage(Map<String, dynamic> data) {
    try {
      if (selectedChat != null && selectedHostId != null) {
        final senderId = data['senderId'] as String?;
        final receiverId = data['receiverId'] as String?;

        final chatUserId = selectedChat!.userId;
        final chatHostId = selectedHostId!;

        final isUserToHost =
            (senderId == chatUserId && receiverId == chatHostId);
        final isHostToUser =
            (senderId == chatHostId && receiverId == chatUserId);
        final isForCurrentChat = isUserToHost || isHostToUser;

        if (isForCurrentChat) {
          _reloadCurrentChatMessages();
        } else {}
      } else {}

      getChats();
    } catch (_) {
      return;
    }
  }

  /// Send typing indicator
  void sendTypingIndicator() {
    if (selectedChat == null || selectedHostId == null) return;
    SocketService.instance.sendTypingIndicator(selectedChat!.userId);
  }

  /// Send stop typing indicator
  void sendStopTypingIndicator() {
    if (selectedChat == null || selectedHostId == null) return;
    SocketService.instance.sendStopTypingIndicator(selectedChat!.userId);
  }

  /// Mark message as read
  void markMessageAsRead(String messageId, String senderId) {
    SocketService.instance.sendMessageRead(
      messageId: messageId,
      senderId: senderId,
    );
  }

  /// Reload messages for current chat
  Future<void> _reloadCurrentChatMessages() async {
    if (selectedChat == null || selectedHostId == null) return;

    _currentPage = 1;
    await getChatHistory(
      hostId: selectedHostId!,
      userId: selectedChat!.userId,
    );
  }

  /// ---------- Pagination ----------
  void nextPage() {
    if (hasNext) {
      _currentPage++;
      notifyListeners();
    }
  }

  void prevPage() {
    if (_currentPage > 1) {
      _currentPage--;
      getChats();
    }
  }

  void setPage(int page) {
    _currentPage = page;
    getChats();
  }

  void resetPagination() {
    _currentPage = 1;
    messages.clear();
  }

  /// ---------- Chat Selection ----------
  Future<void> selectChat(int index, ChatItem chat) async {
    selectedChatIndex = index;
    selectedChat = chat;
    resetPagination();
    _isUserTyping = false;
    notifyListeners();

    try {
      SocketService.instance.joinUserRoom(chat.userId);

      if (selectedHostId != null) {
        SocketService.instance.joinUserRoom(selectedHostId!);
      }
    } catch (_) {
      _isSocketInitialized = false;
    }

    if (selectedHostId != null) {
      await getChatHistory(
        hostId: selectedHostId!,
        userId: chat.userId,
      );
    }
  }

  /// ---------- Load More Messages ----------
  Future<void> loadMoreMessages(ChatItem chat) async {
    if (!hasNext || _isLoading || selectedHostId == null) return;

    _currentPage++;

    await getChatHistory(
      hostId: selectedHostId!,
      userId: chat.userId,
    );
  }

  /// Apply filters and reload chats
  Future<void> applyFilters({
    required String hostId,
    String? city,
    String? language,
  }) async {
    _filterHostId = hostId;
    _filterCity = city;
    _filterLanguage = language;

    selectedHostId = hostId;

    _currentPage = 1;

    selectedChatIndex = null;
    selectedChat = null;
    messages.clear();

    notifyListeners();

    try {
      SocketService.instance.joinUserRoom(hostId);
    } catch (_) {
      _isSocketInitialized = false;
    }

    await getChats();
  }

  /// ---------- API: Get Recent Chats ----------
  Future<void> getChats() async {
    if (_filterHostId == null) {
      chats.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await repo.getRecentChats(
        hostId: _filterHostId!,
        pageNumber: _currentPage.toString(),
        pageSize: pageSize.toString(),
        city: _filterCity,
        language: _filterLanguage,
      );

      if (result['statusCode'] == 200 && result['data'] != null) {
        final ChatListResponse response =
            ChatListResponse.fromJson(result['data']);

        chats = response.chats;
        totalCount = response.totalCount;
        hasNext = response.hasNext;
      } else {
        chats.clear();
      }
    } catch (e) {
      chats.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------- API: Get Chat History ----------
  Future<void> getChatHistory({
    required String hostId,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await repo.getChatHistoryByAdmin(
        hostId: hostId,
        userId: userId,
        pageNumber: _currentPage.toString(),
        pageSize: pageSize.toString(),
      );

      if (result != null && result['statusCode'] == 200) {
        final ChatHistoryResponse response =
            ChatHistoryResponse.fromJson(result);

        if (_currentPage == 1) {
          messages = response.data;
        } else {
          messages.addAll(response.data);
        }
      } else {
        messages.clear();
      }
    } catch (e) {
      messages.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    SocketService.instance.dispose();
    _isSocketInitialized = false;
    super.dispose();
  }

  bool _isHostLoading = false;
  bool get isHostLoading => _isHostLoading;

  List<Hostmodel> hosts = [];

  Future<void> getAssignedHosts() async {
    try {
      _isHostLoading = true;
      notifyListeners();

      final result = await repo.getHost();

      if (result['statusCode'] == 200 && result['data'] != null) {
        final HostsResponse response = HostsResponse.fromJson(result);

        hosts = response.data ?? [];
      } else {
        hosts.clear();
      }
    } catch (e) {
      hosts.clear();
    } finally {
      _isHostLoading = false;
      notifyListeners();
    }
  }

  bool _isHostLanguageLoading = false;
  bool get isHostLanguageLoading => _isHostLanguageLoading;

  List<String> hostLanguages = [];

  Future<void> getHostLanguages() async {
    try {
      _isHostLanguageLoading = true;
      notifyListeners();

      final result = await repo.getHostLanguages();

      if (result['status'] == true && result['data'] != null) {
        hostLanguages = List<String>.from(result['data']);
      } else {
        hostLanguages.clear();
      }
    } catch (e) {
      hostLanguages.clear();
    } finally {
      _isHostLanguageLoading = false;
      notifyListeners();
    }
  }

  bool _isHostLocationLoading = false;
  bool get isHostLocationLoading => _isHostLocationLoading;

  List<String> hostLocations = [];

  Future<void> getHostLocations() async {
    try {
      _isHostLocationLoading = true;
      notifyListeners();

      final result = await repo.getHostLocations();

      if (result['status'] == true && result['data'] != null) {
        hostLocations = List<String>.from(result['data'])
            .where((e) => e.trim().isNotEmpty)
            .toList();
      } else {
        hostLocations.clear();
      }
    } catch (e) {
      hostLocations.clear();
    } finally {
      _isHostLocationLoading = false;
      notifyListeners();
    }
  }

  bool _isUserDetailsLoading = false;
  bool get isUserDetailsLoading => _isUserDetailsLoading;

  UserData? _selectedUserDetails;
  UserData? get selectedUserDetails => _selectedUserDetails;

  String? _userDetailsError;
  String? get userDetailsError => _userDetailsError;
  Future<void> getUserDetailsById(String userId) async {
    try {
      _isUserDetailsLoading = true;
      _userDetailsError = null;
      notifyListeners();

      final result = await repo.getUserDetails(userId: userId);

      if (result['success'] == true && result['data'] != null) {
        _selectedUserDetails = UserData.fromJson(result['data']);
      } else {
        _selectedUserDetails = null;
        _userDetailsError = result['message'] ?? 'Failed to load user details';
      }
    } catch (e) {
      _selectedUserDetails = null;
      _userDetailsError = e.toString();
    } finally {
      _isUserDetailsLoading = false;
      notifyListeners();
    }
  }
}
