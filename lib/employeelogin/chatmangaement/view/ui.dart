import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/chatsection.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/filter.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/view/widgets/messagelistwidget.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeChatManagementPage extends StatefulWidget {
  const EmployeeChatManagementPage({super.key});

  @override
  State<EmployeeChatManagementPage> createState() =>
      _EmployeeChatManagementPageState();
}

class _EmployeeChatManagementPageState
    extends State<EmployeeChatManagementPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<EmployeeChatManagementViewModel>();

      // Load all filter options first
      await Future.wait([
        vm.getHostLanguages(),
        vm.getHostLocations(),
      ]);

      // Then initialize with first employee (which will load chats)
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
            const EmployeeChatfilter(),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 340,
                    child: EmployeeMessageListSection(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: EmployeeChatSection(),
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
