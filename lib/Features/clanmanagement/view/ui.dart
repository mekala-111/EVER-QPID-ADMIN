import 'package:everqpidadmin/Features/clanmanagement/view/widgets/usertable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:everqpidadmin/Features/clanmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';

class ClanManagementScreen extends StatefulWidget {
  const ClanManagementScreen({super.key});

  @override
  State<ClanManagementScreen> createState() => _ClanManagementScreenState();
}

class _ClanManagementScreenState extends State<ClanManagementScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ClanManagementViewModel>();
      vm.getClanUsers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            textWidget(
              text: "Clan Management",
              fontweight: FontWeight.w700,
              fontsize: 20,
            ),

            const SizedBox(height: 16),

            /// Table + Filter
            const Expanded(
              child: ClanUserTable(),
            ),
          ],
        ),
      ),
    );
  }
}
