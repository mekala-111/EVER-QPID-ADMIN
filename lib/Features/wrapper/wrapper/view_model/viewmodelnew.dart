import 'package:flutter/material.dart';

class GetWrapperPageViewStatus {
  static const String employeechat = 'Employee Chat Management';
  static const String employyedetails = 'Employee Details';
  static const String recievedLikes = 'Recieved Likes';
}

class WrapperViewModelNew extends ChangeNotifier {
  String viewStatus = GetWrapperPageViewStatus.employeechat;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String drawer = "";

  bool menuVisibilty = true;
  int pageIndex = 0;
  updateDrawer(String drawerName) {
    drawer = drawerName;
    notifyListeners();
  }

  updatePageIndex(
    String view,
  ) {
    viewStatus = view;
    notifyListeners();
  }

  updateMenuVisibilty() {
    menuVisibilty = !menuVisibilty;
    notifyListeners();
  }

  // Future<void> logOut() async {
  //   try {
  //     await LoggedInUser.clearUserData();
  //     Navigator.pushNamedAndRemoveUntil(
  //         navigatorKey.currentContext!, PPages.login, (route) => false);
  //   } catch (e) {
  //     ErrorMsg.showSnakError(navigatorKey.currentContext!, e.toString());
  //   }
  // }
}
