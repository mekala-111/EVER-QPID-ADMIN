import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../Data/LocaStorage/loggedin_user.dart';
import '../../../Settings/constants/app_url.dart';

class SocketEvents {
  static const String joinUserRoom = 'joinUserRoom';
  static const String userStatusChanged = 'userStatusChanged';
  static const String privateMessage = 'hostMessage';
  static const String newMessage = 'newMessage';
  static const String typing = 'hostTyping';
  static const String userTyping = 'Typing';
  static const String stopTyping = 'hostStopTyping';
  static const String userStopTyping = 'userStopTyping';
  static const String messageRead = 'hostMessageRead';
  static const String readStatusUpdated = 'readStatusUpdated';
}

enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed,
}

/// Singleton Socket.IO manager. All realtime access goes through this class,
/// which isolates `socket_io_client` from the rest of the app.
///
/// WASM note: `socket_io_common` currently trips the
/// `invalid_runtime_check_with_js_interop_types` dry-run check, so release
/// builds target the JS compiler. Because this class is the only consumer,
/// swapping in a WASM-compatible transport later requires no call-site
/// changes.
class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  final _connectionState = StreamController<SocketConnectionState>.broadcast();
  io.Socket? _socket;
  String? _currentUserId;
  SocketConnectionState _state = SocketConnectionState.disconnected;

  bool get isConnected => _state == SocketConnectionState.connected;
  bool get isInitialized => _socket != null;
  String? get currentUserId => _currentUserId;
  SocketConnectionState get connectionState => _state;
  Stream<SocketConnectionState> get connectionStates => _connectionState.stream;

  void Function(Map<String, dynamic>)? onNewMessageReceived;
  void Function(String senderId, String receiverId)? onUserTyping;
  void Function(String senderId, String receiverId)? onUserStopTyping;
  void Function(Map<String, dynamic>)? onReadStatusUpdated;
  void Function(String userId, bool isOnline)? onUserStatusChanged;

  Future<void> initialize(String userId, {String? serverUrl}) async {
    if (_socket != null && _currentUserId == userId && isConnected) return;
    await dispose();

    final token = LoggedInUser.accessToken;
    if (token == null || token.isEmpty) {
      _setState(SocketConnectionState.failed);
      return;
    }

    _currentUserId = userId;
    _setState(SocketConnectionState.connecting);
    _socket = io.io(
      _secureSocketUrl(serverUrl ?? AppUrl.baseurl),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(8)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(30000)
          .setTimeout(20000)
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );
    _registerListeners();
    _socket!.connect();
  }

  String _secureSocketUrl(String value) {
    final uri = Uri.parse(value);
    final scheme = uri.scheme == 'https' || uri.scheme == 'wss' ? 'wss' : 'ws';
    return uri.replace(scheme: scheme).toString();
  }

  void _registerListeners() {
    final socket = _socket;
    if (socket == null) return;

    socket.onConnect((_) {
      _setState(SocketConnectionState.connected);
      final userId = _currentUserId;
      if (userId != null) joinUserRoom(userId);
    });
    socket.onDisconnect((_) => _setState(SocketConnectionState.disconnected));
    socket.onConnectError((_) => _setState(SocketConnectionState.failed));
    socket.onError((_) => _setState(SocketConnectionState.failed));
    socket.onReconnectAttempt(
      (_) => _setState(SocketConnectionState.reconnecting),
    );
    socket.onReconnect((_) {
      _setState(SocketConnectionState.connected);
      final userId = _currentUserId;
      if (userId != null) joinUserRoom(userId);
    });
    socket.onReconnectFailed(
      (_) => _setState(SocketConnectionState.failed),
    );
    socket.on(SocketEvents.newMessage, _handleNewMessage);
    socket.on(SocketEvents.userTyping, _handleUserTyping);
    socket.on(SocketEvents.userStopTyping, _handleUserStopTyping);
    socket.on(SocketEvents.readStatusUpdated, _handleReadStatusUpdated);
    socket.on(SocketEvents.userStatusChanged, _handleUserStatusChanged);
  }

  void _setState(SocketConnectionState state) {
    if (_state == state) return;
    _state = state;
    if (!_connectionState.isClosed) _connectionState.add(state);
  }

  void joinUserRoom(String userId) {
    if (isConnected) {
      _socket?.emit(SocketEvents.joinUserRoom, {'userId': userId});
    }
  }

  void sendPrivateMessage({
    required String receiverId,
    required String senderId,
    required String content,
    required String messageType,
    required String mediaUrl,
  }) {
    if (!isConnected) return;
    _socket?.emit(SocketEvents.privateMessage, {
      'hostId': receiverId,
      'userId': senderId,
      'content': content,
      'type': messageType,
      'mediaUrl': mediaUrl,
    });
  }

  void sendTypingIndicator(String receiverId) {
    _emitForCurrentUser(SocketEvents.typing, receiverId);
  }

  void sendStopTypingIndicator(String receiverId) {
    _emitForCurrentUser(SocketEvents.stopTyping, receiverId);
  }

  void _emitForCurrentUser(String event, String receiverId) {
    if (!isConnected || _currentUserId == null) return;
    _socket?.emit(event, {
      'senderId': _currentUserId,
      'receiverId': receiverId,
    });
  }

  void sendMessageRead({
    required String messageId,
    required String senderId,
  }) {
    if (!isConnected || _currentUserId == null) return;
    _socket?.emit(SocketEvents.messageRead, {
      'messageId': messageId,
      'userId': _currentUserId,
      'senderId': senderId,
      'readAt': DateTime.now().toIso8601String(),
    });
  }

  void _handleNewMessage(dynamic data) {
    final value = _map(data);
    if (value != null) onNewMessageReceived?.call(value);
  }

  void _handleUserTyping(dynamic data) {
    final value = _map(data);
    final senderId = value?['senderId']?.toString();
    final receiverId = value?['receiverId']?.toString();
    if (senderId != null && receiverId != null) {
      onUserTyping?.call(senderId, receiverId);
    }
  }

  void _handleUserStopTyping(dynamic data) {
    final value = _map(data);
    final senderId = value?['senderId']?.toString();
    final receiverId = value?['receiverId']?.toString();
    if (senderId != null && receiverId != null) {
      onUserStopTyping?.call(senderId, receiverId);
    }
  }

  void _handleReadStatusUpdated(dynamic data) {
    final value = _map(data);
    if (value != null) onReadStatusUpdated?.call(value);
  }

  void _handleUserStatusChanged(dynamic data) {
    final value = _map(data);
    final userId = value?['userId']?.toString();
    if (userId != null) {
      onUserStatusChanged?.call(userId, value?['isOnline'] == true);
    }
  }

  Map<String, dynamic>? _map(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  void setChatEventCallbacks({
    void Function(Map<String, dynamic>)? onNewMessage,
    void Function(String, String)? onTyping,
    void Function(String, String)? onStopTyping,
    void Function(Map<String, dynamic>)? onReadStatus,
    void Function(String, bool)? onUserStatus,
  }) {
    onNewMessageReceived = onNewMessage;
    onUserTyping = onTyping;
    onUserStopTyping = onStopTyping;
    onReadStatusUpdated = onReadStatus;
    onUserStatusChanged = onUserStatus;
  }

  Future<void> reconnect() async {
    final userId = _currentUserId;
    if (userId != null) await initialize(userId);
  }

  Future<void> dispose() async {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _currentUserId = null;
    onNewMessageReceived = null;
    onUserTyping = null;
    onUserStopTyping = null;
    onReadStatusUpdated = null;
    onUserStatusChanged = null;
    _setState(SocketConnectionState.disconnected);
  }
}
