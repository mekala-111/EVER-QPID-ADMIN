import 'dart:async';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/viewmodelnew.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/model/chathistorymodel.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/chatbubble.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/messageinput.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeChatSection extends StatefulWidget {
  const EmployeeChatSection({super.key});

  @override
  State<EmployeeChatSection> createState() => _EmployeeChatSectionState();
}

class _EmployeeChatSectionState extends State<EmployeeChatSection> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // Initialize socket when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<EmployeeChatManagementViewModel>();
      viewModel.initializeSocket();
    });

    // Listen to text changes for typing indicator
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final viewModel = context.read<EmployeeChatManagementViewModel>();

    if (_messageController.text.isNotEmpty && !_isTyping) {
      // User started typing
      _isTyping = true;
      viewModel.sendTypingIndicator();
    }

    // Cancel previous timer
    _typingTimer?.cancel();

    // Set new timer - if user stops typing for 2 seconds, send stop typing
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _isTyping = false;
        viewModel.sendStopTypingIndicator();
      }
    });
  }

  void _sendMessage() {
    final viewModel = context.read<EmployeeChatManagementViewModel>();
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    // Send text message with empty mediaUrl
    viewModel.sendMessage(message, '', messageType: 'text');

    // Clear input
    _messageController.clear();

    // Send stop typing indicator
    _isTyping = false;
    viewModel.sendStopTypingIndicator();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeChatManagementViewModel>(
      builder: (context, viewModel, _) {
        // No chat selected
        if (viewModel.selectedChatIndex == null ||
            viewModel.selectedChat == null ||
            viewModel.selectedHostId == null) {
          return const Center(
            child: Text(
              "Select a chat to view messages",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final chatMeta = viewModel.selectedChat!;
        final hostId = viewModel.selectedHostId!;
        final List<ChatMessage> messages = viewModel.messages;

        return Column(
          children: [
            // ================= HEADER =================
            _ChatHeader(
                chatMeta: chatMeta,
                hostId: hostId,
                isUserTyping: viewModel.isUserTyping,
                userId: chatMeta.user.id.toString()),

            const Divider(height: 1),

            // ================= MESSAGES =================
            Expanded(
              child: viewModel.isLoading && messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "No messages yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          reverse: true, // Show latest at bottom
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            // Check if message is from host
                            final bool isFromHost = message.senderId == hostId;

                            return EmployeeChatBubble(
                              message: message.content,
                              isSender: isFromHost,
                              time: message.sentAt.toLocal(),
                              senderName:
                                  isFromHost ? "Host" : chatMeta.user.fullName,
                              messageType: message.type,
                              mediaUrl: message.mediaUrl.isNotEmpty
                                  ? message.mediaUrl
                                  : null,
                            );
                          },
                        ),
            ),

            // ================= LOAD MORE =================
            if (viewModel.hasNext)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton.icon(
                  onPressed: viewModel.isLoading
                      ? null
                      : () {
                          viewModel.nextPage();
                          viewModel.loadMoreMessages(chatMeta);
                        },
                  icon: viewModel.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(
                    viewModel.isLoading ? "Loading..." : "Load older messages",
                  ),
                ),
              ),

            // ================= MESSAGE INPUT =================
            MessageInput(
              controller: _messageController,
              focusNode: _messageFocusNode,
              onSend: _sendMessage,
            ),
          ],
        );
      },
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final dynamic chatMeta;
  final String hostId;
  final String userId;

  final bool isUserTyping;

  const _ChatHeader({
    required this.chatMeta,
    required this.hostId,
    required this.userId,
    required this.isUserTyping,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context
            .read<EmployeeChatManagementViewModel>()
            .getUserDetailsById(userId);
        context
            .read<WrapperViewModelNew>()
            .updatePageIndex(GetWrapperPageViewStatus.employyedetails);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // User Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: chatMeta.user.profileImageUrl.isNotEmpty
                      ? NetworkImage(chatMeta.user.profileImageUrl)
                      : null,
                  child: chatMeta.user.profileImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 28)
                      : null,
                ),
                if (chatMeta.user.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatMeta.user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Show typing indicator or online status
                  isUserTyping
                      ? Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "typing...",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          chatMeta.user.isOnline ? "Online" : "Offline",
                          style: TextStyle(
                            fontSize: 13,
                            color: chatMeta.user.isOnline
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                ],
              ),
            ),

            // Host Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Row(
                  children: [
                    Icon(Icons.support_agent, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "Host",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "ID: ${hostId.substring(0, 8)}...",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
