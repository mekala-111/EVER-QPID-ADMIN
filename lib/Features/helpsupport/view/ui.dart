import 'package:everqpidadmin/Features/helpsupport/view/widgets/helpview.dart';
import 'package:everqpidadmin/Features/helpsupport/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpUi extends StatefulWidget {
  const HelpUi({super.key});

  @override
  State<HelpUi> createState() => _HelpUiState();
}

class _HelpUiState extends State<HelpUi> {
  @override
  void initState() {
    super.initState();

    /// Fetch email once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HelpViewModel>().fetchEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PColors.scaffoldColor2,
      padding: const EdgeInsets.only(left: 17, right: 20),
      height: MediaQuery.of(context).size.height,
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelpSupportBody(),
          ],
        ),
      ),
    );
  }
}
