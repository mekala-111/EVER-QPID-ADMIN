import 'package:everqpidadmin/Features/chatmangaement/view/widgets/messagetile.dart';
import 'package:everqpidadmin/Features/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageListSection extends StatelessWidget {
  const MessageListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatManagementViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Message",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              /// 🔄 Loading
              if (viewModel.isLoading && viewModel.chats.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )

              /// 📭 Empty
              else if (viewModel.chats.isEmpty)
                const Expanded(
                  child: Center(child: Text("No messages found")),
                )

              /// 📩 Chat List
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.chats.length,
                    itemBuilder: (context, index) {
                      final chat = viewModel.chats[index];

                      return MessageTile(
                        name: chat.user.fullName,
                        lastMessage: chat.lastMessage.content,
                        unreadCount: chat.unreadCount,
                        isSelected: viewModel.selectedChatIndex == index,
                        profileImageUrl: chat.user.profileImageUrl,
                        onTap: () {
                          // Load chat history when tapped
                          viewModel.selectChat(index, chat);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
