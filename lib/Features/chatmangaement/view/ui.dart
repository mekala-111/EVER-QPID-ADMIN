import 'package:everqpidadmin/Features/chatmangaement/view/widgets/chatsection.dart';
import 'package:everqpidadmin/Features/chatmangaement/view/widgets/filter.dart';
import 'package:everqpidadmin/Features/chatmangaement/view/widgets/messagelistwidget.dart';
import 'package:everqpidadmin/Features/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatManagementPage extends StatefulWidget {
  const ChatManagementPage({super.key});

  @override
  State<ChatManagementPage> createState() => _ChatManagementPageState();
}

class _ChatManagementPageState extends State<ChatManagementPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ChatManagementViewModel>();

      // Load all filter options first
      await Future.wait([
        vm.getChatEmployees(),
        vm.getHostLanguages(),
        vm.getHostLocations(),
      ]);

      // Then initialize with first employee (which will load chats)
      await vm.initializeWithFirstEmployee();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat Management',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Chatfilter(),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 340,
                    child: MessageListSection(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ChatSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
