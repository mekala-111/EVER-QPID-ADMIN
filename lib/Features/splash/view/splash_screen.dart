import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    final authenticated = await AuthService.restoreSession();
    if (!mounted) return;

    if (authenticated) {
      if (LoggedInUser.isAdmin) {
        Navigator.pushNamedAndRemoveUntil(
            context, PPages.mainScreen, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, PPages.mainScreen2, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, PPages.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.primaryColor,
      body: Center(
          child: Text("Loading...",
              style: const TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}
