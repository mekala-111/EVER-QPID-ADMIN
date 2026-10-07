import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Features/auth/services/auth_service.dart';
import '../../Features/auth/view/login_screen.dart';
import '../../Features/splash/view/splash_screen.dart';
import '../../Features/wrapper/employeewrpper/ui.dart';
import '../../Features/wrapper/wrapper/view/ui.dart';
import '../../Features/wrapper/wrapper/view_model/view_model.dart';
import '../common/widgets/no_internet.dart';
import 'p_pages.dart';

class Routes {
  static Route<dynamic> genericRoute(RouteSettings settings) {
    Widget page;
    final wrapperView = WrapperPagePaths.viewFor(settings.name);
    if (wrapperView != null) {
      page = ProtectedRoute(wrapperPage: wrapperView);
    } else {
      switch (settings.name) {
        case '/':
        case PPages.splash:
          page = const SplashScreen();
          break;
        case PPages.login:
          page = const LoginScreen();
          break;
        case PPages.noInternet:
          page = const NoInternetWidget();
          break;
        case PPages.mainScreen:
          page = const ProtectedRoute(
            wrapperPage: GetWrapperPageViewStatus.dashboard,
          );
          break;
        case PPages.chatScreen:
          page = const ProtectedRoute(
            wrapperPage: GetWrapperPageViewStatus.chat,
          );
          break;
        case PPages.profile:
        case PPages.profileScreen:
        case PPages.settings:
        case PPages.settingsScreen:
          page = const ProtectedRoute();
          break;
        case PPages.mainScreen2:
          page = const ProtectedRoute(employee: true);
          break;
        default:
          page = const LoginScreen();
      }
    }
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}

class ProtectedRoute extends StatefulWidget {
  const ProtectedRoute({
    super.key,
    this.employee = false,
    this.wrapperPage,
  });

  final bool employee;
  final String? wrapperPage;

  @override
  State<ProtectedRoute> createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
  late final Future<bool> _authenticated = AuthService.restoreSession();
  bool _pageApplied = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authenticated,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data != true) return const LoginScreen();

        final wrapperPage = widget.wrapperPage;
        if (wrapperPage != null && !_pageApplied) {
          _pageApplied = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // The browser URL already points at this page; avoid pushing a
              // duplicate history entry.
              context
                  .read<WrapperViewModel>()
                  .updatePageIndex(wrapperPage, syncUrl: false);
            }
          });
        }
        return widget.employee
            ? const EmployeewrapperUi()
            : const WrapperPageUi();
      },
    );
  }
}
