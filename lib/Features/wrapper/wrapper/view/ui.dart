import 'package:everqpidadmin/Features/wrapper/wrapper/view/widgets/new_wrapper_body.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view/widgets/new_wrapper_menu.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/common_appbar.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class WrapperPageUi extends StatefulWidget {
  const WrapperPageUi({super.key});

  @override
  State<WrapperPageUi> createState() => _WrapperPageUiState();
}

class _WrapperPageUiState extends State<WrapperPageUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        //   Future.microtask(() {
        //     final vm = Provider.of<UsersViewModel>(navigatorKey.currentContext!,
        //         listen: false);
        //     vm.getPorfileStatusCount(); // or any logic
        //     Provider.of<WithdrawalViewModel>(navigatorKey.currentContext!,
        //             listen: false)
        //         .getWithdrawalCount();
        //   });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<WrapperViewModel>(
      builder: (context, value, child) => Scaffold(
        key: scaffoldKey,
        // endDrawer: value.drawer == 'plan' ? PlanPreviewDrawer() : Container(),
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60), child: CustomAppbar()),
        backgroundColor: PColors.colorFFFFFF,
        body: Row(
          children: [
            Consumer<WrapperViewModel>(
              builder: (context, value, child) => Visibility(
                visible: value.menuVisibilty,
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey))),
                  width: size.width * 0.21,
                  child: const WrapperMenuSectionUi(),
                ),
              ),
            ),
            const Expanded(child: WrapperBodySection())
          ],
        ),
      ),
    );
  }
}
