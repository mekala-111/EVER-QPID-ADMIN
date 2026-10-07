import 'package:everqpidadmin/Features/auth/services/auth_service.dart';
import 'package:everqpidadmin/Settings/common/widgets/custom_alert_dialog.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:everqpidadmin/Settings/utils/p_pages.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PColors.primaryColor,
      // leading: GestureDetector(
      //   onTap: () {
      //     context.read<WrapperViewModel>().updateMenuVisibilty();
      //   },
      //   child: Icon(
      //     Icons.menu,
      //     color: PColors.white,
      //   ),
      // ),
      centerTitle: false,
      title: textWidget(
          text: "Home Service",
          fontsize: 20,
          fontweight: FontWeight.w400,
          color: PColors.colorFFFFFF),
      actions: [
        IconButton(
          tooltip: 'Log out',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDailog(
                title: "Logout",
                titleColor: PColors.color000000,
                content: "Are you sure want to logout?",
                onTap: () async {
                  await AuthService.logout();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PPages.login,
                    (_) => false,
                  );
                },
              ),
            );
          },
          icon: CircleAvatar(
            backgroundColor: PColors.colorFFFFFF,
            child: const Icon(Icons.logout),
          ),
        )
      ],
    );
  }
}
