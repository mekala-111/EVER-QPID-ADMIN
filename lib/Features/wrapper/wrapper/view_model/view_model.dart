import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Settings/utils/p_pages.dart';

/// Maps browser paths to wrapper pages so major admin sections have real
/// URLs that survive refresh and back/forward navigation on the web.
class WrapperPagePaths {
  WrapperPagePaths._();

  static const Map<String, String> pathToView = {
    PPages.dashboard: GetWrapperPageViewStatus.dashboard,
    PPages.users: GetWrapperPageViewStatus.users,
    PPages.chat: GetWrapperPageViewStatus.chat,
    PPages.notifications: GetWrapperPageViewStatus.notification,
    PPages.revenue: GetWrapperPageViewStatus.revenue,
    PPages.plans: GetWrapperPageViewStatus.plans,
    PPages.transactions: GetWrapperPageViewStatus.transaction,
    PPages.tickets: GetWrapperPageViewStatus.tickets,
    PPages.employees: GetWrapperPageViewStatus.employees,
    PPages.clans: GetWrapperPageViewStatus.clan,
    PPages.hosts: GetWrapperPageViewStatus.allhost,
    PPages.email: GetWrapperPageViewStatus.email,
  };

  static String? viewFor(String? path) => pathToView[path];

  static String? pathFor(String view) {
    for (final entry in pathToView.entries) {
      if (entry.value == view) return entry.key;
    }
    return null;
  }
}

class GetWrapperPageViewStatus {
  static const String users = 'All Users';
  static const String dashboard = 'Dashboard';

  static const String userDetails = 'User Details';
  static const String maleusers = 'Male Users';
  static const String femaleusers = 'Female Users';
  static const String reported = 'Reported Accounts';
  static const String reporteduserDetails = 'Reported User Details';

  static const String allhost = 'All Hosts';
  static const String activehost = 'Active Hosts';
  static const String inactivehost = 'Inactive Hosts';

  static const String hostDetails = 'Host Details';
  static const String addHost = 'Create Host';
  // static const String transactiondetails = 'Transaction Details';

  static const String tickets = 'Tickets';
  static const String ticketDetails = 'Ticket Details';

  static const String notification = 'Notification';
  static const String addnotification = 'Add Notification';
  static const String chat = 'Chat Management';
  static const String employeechat = 'Employee Chat Management';

  static const String clan = 'Clan Management';
  static const String settings = 'Settings';
  static const String employees = 'Employees';

  static const String transaction = 'Transactions';
  static const String transactionDeatils = 'Transaction Details';

  static const String revenue = 'Revenue';
  static const String plans = 'Plans';
  static const String addPlan = 'Add Plan';
  static const String editPlan = 'Edit Plan';
  // static const String ticket = 'Tickets';
  static const String email = 'Email';

  static const String callLogs = 'Call Logs';
  static const String addCallLogs = 'Add Call Logs';
  static const String editCallLogs = 'Edit Call Logs';
  static const String callDetails = 'Call Details';
  static const String userProfileImage = 'Profile Image Management';
  static const String profileImage = 'Profile Images';
  static const String adduserProfile = 'Add Profile Image';
  static const String edituserProfile = 'Edit Profile Image';
  static const String coinSettings = 'Coin withdraw';
  static const String userCoinSettings = 'User Coin';
  static const String withdraw = 'Withdraw';
  static const String requestDeatils = 'Request Details';
  static const String banners = 'Banners';
  static const String addBanner = 'Add Banner';
  static const String editBanner = 'Edit Banner';
  static const String gifts = 'Gifts';
  static const String addGift = 'Add Gift';
  static const String editGift = 'Edit Gift';
  static List<String> get getAll => [];
}

class WrapperViewModel extends ChangeNotifier {
  String viewStatus = GetWrapperPageViewStatus.dashboard;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String drawer = "";

  bool menuVisibilty = true;
  int pageIndex = 0;
  updateDrawer(String drawerName) {
    drawer = drawerName;
    notifyListeners();
  }

  void updatePageIndex(String view, {bool syncUrl = true}) {
    viewStatus = view;
    notifyListeners();
    if (syncUrl && kIsWeb) {
      final path = WrapperPagePaths.pathFor(view);
      if (path != null) {
        SystemNavigator.routeInformationUpdated(uri: Uri(path: path));
      }
    }
  }

  updateMenuVisibilty() {
    menuVisibilty = !menuVisibilty;
    notifyListeners();
  }
}
