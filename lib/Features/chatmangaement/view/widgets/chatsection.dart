import 'package:everqpidadmin/Features/chatmangaement/view/widgets/chatbubble.dart';
import 'package:everqpidadmin/Features/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // void _sendMessage(ChatManagementViewModel viewModel) {
  //   final message = _messageController.text.trim();

  //   if (message.isEmpty) return;

  //   final chatMeta = viewModel.chatMeta;
  //   if (chatMeta == null) return;

  //   // Send the message
  //   viewModel.sendPrivatemessage(
  //     recieverId: chatMeta
  //         .user.id, // or chatMeta.host.id depending on who should receive
  //     message: message,
  //   );

  //   // Clear the input field
  //   _messageController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatManagementViewModel>(
      builder: (context, viewModel, child) {
        // No chat selected
        if (viewModel.selectedChatIndex == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "Select a chat to view messages",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        final chatMeta = viewModel.chatMeta;
        final messages = viewModel.messages;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              // Header
              if (chatMeta != null)
                Row(
                  children: [
                    // User Section (Left)
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: chatMeta.user.profileImageUrl.isNotEmpty
                          ? NetworkImage(chatMeta.user.profileImageUrl)
                          : null,
                      child: chatMeta.user.profileImageUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatMeta.user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          chatMeta.user.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                              fontSize: 12,
                              color: chatMeta.user.isOnline
                                  ? Colors.green
                                  : Colors.blueGrey),
                        ),
                      ],
                    ),

                    const Spacer(), // Pushes host info to the right

                    // Host Section (Right)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chatMeta.host.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          chatMeta.host.place,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: chatMeta.host.profileImageUrl.isNotEmpty
                          ? NetworkImage(chatMeta.host.profileImageUrl)
                          : null,
                      child: chatMeta.host.profileImageUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                  ],
                ),
              const Divider(height: 30),

              // Messages
              Expanded(
                child: viewModel.isLoading && messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : messages.isEmpty
                        ? const Center(child: Text("No messages yet"))
                        : ListView.builder(
                            reverse: false,
                            itemCount: messages.length + 1,
                            itemBuilder: (context, index) {
                              // Header showing chat assignment
                              if (index == 0 && chatMeta != null) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      "Chat Assigned to ${chatMeta.host.name} (Host)",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final message = messages[index - 1];
                              final isSender = message.sender.role == 'user';

                              return ChatBubble(
                                message: message.content,
                                isSender: isSender,
                                time: message.sentAt,
                                senderName: message.sender.name,
                              );
                            },
                          ),
              ),

              // Load more button
              if (viewModel.hasNext)
                TextButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () {
                          viewModel.nextPage();
                          if (viewModel.selectedChat != null) {
                            viewModel.loadMoreMessages(
                              viewModel.selectedChat!,
                            );
                          }
                        },
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Load more messages"),
                ),

              // Input
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   decoration: BoxDecoration(
              //     color: const Color(0xffF3F4F6),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           controller: _messageController,
              //           decoration: const InputDecoration(
              //             hintText: "Type your message...",
              //             border: InputBorder.none,
              //           ),
              //           onSubmitted: (_) => _sendMessage(viewModel),
              //         ),
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.send, color: Colors.grey),
              //         onPressed: () => _sendMessage(viewModel),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
