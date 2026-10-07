import 'package:everqpidadmin/Features/auth/services/auth_service.dart';
import 'package:everqpidadmin/Settings/common/widgets/custom_alert_dialog.dart';
import 'package:everqpidadmin/Settings/utils/p_pages.dart';
import 'package:flutter/material.dart';
import '../../utils/p_colors.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(color: PColors.primaryColor),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading: GestureDetector(
          //   onTap: () {
          //     context.read<WrapperViewModel>().updateMenuVisibilty(true);
          //   },
          //   child: Icon(Icons.menu, color: PColors.colorFFFFFF),
          // ),
          centerTitle: false,
          title: Text(
            'Everqpid',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 1.20,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Log out',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDailog(
                    title: "Log Out",
                    titleColor: Color(0xFF091128),
                    content: "Do you want to log out?",
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
            ),
          ],
        ),
      ),
    );
  }
}
