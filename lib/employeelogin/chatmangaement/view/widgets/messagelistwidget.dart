// Add this helper method to your LastMessage class or create a utility class

import 'package:everqpidadmin/employeelogin/chatmangaement/model/recentchatmodel.dart'
    show LastMessage;
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/messagetile.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageHelper {
  /// Returns a user-friendly display text for the last message
  static String getLastMessageDisplay(LastMessage message) {
    switch (message.type.toLowerCase()) {
      case 'text':
        return message.content.isNotEmpty ? message.content : 'Message';

      case 'audio':
        return '🎤 Audio message';

      case 'image':
        return '📷 Photo';

      case 'video':
        return '🎥 Video';

      case 'document':
      case 'file':
        return '📄 Document';

      case 'location':
        return '📍 Location';

      case 'contact':
        return '👤 Contact';

      default:
        return message.content.isNotEmpty ? message.content : 'Message';
    }
  }
}

// Then update your EmployeeMessageListSection widget:

class EmployeeMessageListSection extends StatelessWidget {
  const EmployeeMessageListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeChatManagementViewModel>(
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

                      return EmployeeMessagetile(
                        name: chat.user.fullName,
                        lastMessage: MessageHelper.getLastMessageDisplay(
                            chat.lastMessage), // ✅ Use helper
                        unreadCount: chat.unreadCount,
                        isSelected: viewModel.selectedChatIndex == index,
                        profileImageUrl: chat.user.profileImageUrl,
                        onTap: () {
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

// Alternative: Add a getter directly to LastMessage class

extension LastMessageDisplay on LastMessage {
  String get displayText {
    switch (type.toLowerCase()) {
      case 'text':
        return content.isNotEmpty ? content : 'Message';

      case 'audio':
        return '🎤 Audio message';

      case 'image':
        return '📷 Photo';

      case 'video':
        return '🎥 Video';

      case 'document':
      case 'file':
        return '📄 Document';

      case 'location':
        return '📍 Location';

      case 'contact':
        return '👤 Contact';

      default:
        return content.isNotEmpty ? content : 'Message';
    }
  }
}

// If using the extension approach, update the widget like this:
// lastMessage: chat.lastMessage.displayText,
