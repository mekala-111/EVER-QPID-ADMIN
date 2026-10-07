import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/chatmangaement/model/employeesmodel.dart';
import 'package:everqpidadmin/Features/chatmangaement/model/hostmodel.dart'
    show HostsResponse, Hostmodel;
import 'package:everqpidadmin/Features/chatmangaement/model/recentchatmodel.dart';
import 'package:everqpidadmin/Features/chatmangaement/repo/repo.dart';
import 'package:everqpidadmin/Features/chatmangaement/model/chathistorymodel.dart';
import 'package:flutter/material.dart';

class ChatManagementViewModel extends ChangeNotifier {
  final ChatManagementRepo repo = ChatManagementRepo(NetworkApiServiceV2());
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
  ChatMeta? chatMeta;
  List<Message> messages = [];

  // Filter state - NOW REQUIRED
  String? _filterEmployeeId;
  String? _filterHostId;
  String? _filterCity;
  String? _filterLanguage;

  String? get filterEmployeeId => _filterEmployeeId;
  String? get filterHostId => _filterHostId;
  String? get filterCity => _filterCity;
  String? get filterLanguage => _filterLanguage;

  // ChatManagementViewModel() {
  //   _initializeSocketListeners();
  // }

  /// Initialize socket listeners for real-time updates
  // void _initializeSocketListeners() {
  //   _socketService.setChatEventCallbacks(
  //     onNewMessage: (data) {
  //       _handleIncomingMessage(data);
  //     },
  //   );
  // }

  /// Handle incoming messages from socket

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
    notifyListeners();

    await getChatHistory(
      hostId: _filterHostId!,
      userId: chat.userId,
    );
  }

  /// ---------- Load More Messages ----------
  Future<void> loadMoreMessages(ChatItem chat) async {
    if (!hasNext || _isLoading) return;

    _currentPage++;

    await getChatHistory(
      hostId: _filterHostId!,
      userId: chat.userId,
    );
  }

  /// Apply filters and reload chats
  Future<void> applyFilters({
    required String employeeId,
    required String hostId,
    String? city,
    String? language,
  }) async {
    _filterEmployeeId = employeeId;
    _filterHostId = hostId;
    _filterCity = city;
    _filterLanguage = language;

    _currentPage = 1;

    selectedChatIndex = null;
    selectedChat = null;
    messages.clear();

    notifyListeners();

    await getChats();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    // Reset to first employee and host if available
    if (employees.isNotEmpty) {
      _filterEmployeeId = employees.first.id;

      // Load hosts for first employee
      await getAssignedHosts(employeeId: _filterEmployeeId!);

      if (hosts.isNotEmpty) {
        _filterHostId = hosts.first.id;
      } else {
        _filterHostId = null;
      }
    } else {
      _filterEmployeeId = null;
      _filterHostId = null;
    }

    _filterCity = null;
    _filterLanguage = null;

    _currentPage = 1;

    selectedChatIndex = null;
    selectedChat = null;
    messages.clear();

    notifyListeners();

    await getChats();
  }

  /// Initialize with first employee and host
  Future<void> initializeWithFirstEmployee() async {
    if (employees.isNotEmpty) {
      _filterEmployeeId = employees.first.id;

      // Load hosts for first employee
      await getAssignedHosts(employeeId: _filterEmployeeId!);

      if (hosts.isNotEmpty) {
        _filterHostId = hosts.first.id;

        // Load chats with first employee and host
        await getChats();
      } else {}
    } else {}
  }

  /// ---------- API: Get Recent Chats ----------
  Future<void> getChats() async {
    // Check if both employeeId and hostId are provided
    if (_filterEmployeeId == null || _filterHostId == null) {
      chats.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await repo.getRecentChats(
        employeeId: _filterEmployeeId!,
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

      if (result['statusCode'] == 200 && result['data'] != null) {
        final ChatResponse response = ChatResponse.fromJson(result);

        final chatData = response.data;

        chatMeta = chatData.chatMeta;
        totalCount = chatData.totalCount;
        hasNext = chatData.hasNext;

        if (_currentPage == 1) {
          messages = chatData.messages;
        } else {
          messages.addAll(chatData.messages);
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

  // ---------- Employees ----------
  bool _isEmployeesLoading = false;
  bool get isEmployeesLoading => _isEmployeesLoading;

  List<Employee> employees = [];

  Future<void> getChatEmployees() async {
    try {
      _isEmployeesLoading = true;
      notifyListeners();

      final result = await repo.getchatEmployees();

      if (result['statusCode'] == 200 && result['data'] != null) {
        final EmployeeResponse response = EmployeeResponse.fromJson(result);

        employees = response.data?.employees ?? [];
      } else {
        employees.clear();
      }
    } catch (e) {
      employees.clear();
    } finally {
      _isEmployeesLoading = false;
      notifyListeners();
    }
  }

  bool _isHostLoading = false;
  bool get isHostLoading => _isHostLoading;

  List<Hostmodel> hosts = [];

  Future<void> getAssignedHosts({
    required String employeeId,
  }) async {
    try {
      _isHostLoading = true;
      notifyListeners();

      final result = await repo.getHost(employeeId: employeeId);

      if (result['statusCode'] == 200 && result['data'] != null) {
        final HostsResponse response = HostsResponse.fromJson(result);

        hosts = response.data?.hosts ?? [];
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
}
