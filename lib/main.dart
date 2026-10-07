import 'dart:ui';

import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Settings/helper/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'Settings/utils/p_colors.dart';
import 'Settings/utils/p_pages.dart';
import 'Settings/utils/p_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) debugPrint('$error\n$stack');
    return true;
  };
  ErrorWidget.builder = (_) => const Material(
        child: Center(child: Text('Something went wrong. Please reload.')),
      );
  NetworkApiServiceV2.onAuthenticationFailed = () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        PPages.login,
        (_) => false,
      );
    });
  };
  configLoading();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'EverQpid Admin',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: PColors.colorFFFFFF,
        colorScheme: ColorScheme.fromSeed(seedColor: PColors.primaryColor),
        iconTheme: IconThemeData(color: PColors.colorFFFFFF),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: PColors.colorFFFFFF,
          surfaceTintColor: PColors.primaryColor,
          foregroundColor: PColors.colorFFFFFF,
          centerTitle: true,
        ),
      ),
      initialRoute: PlatformDispatcher.instance.defaultRouteName,
      onGenerateRoute: Routes.genericRoute,
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..maskColor = Colors.white
    ..indicatorColor = Colors.black
    ..userInteractions = false
    ..dismissOnTap = false
    ..textColor = Colors.transparent
    ..contentPadding = const EdgeInsets.all(8)
    ..textPadding = EdgeInsets.zero
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..indicatorSize = 23
    ..lineWidth = 2.2
    ..radius = 20
    ..boxShadow = <BoxShadow>[
      const BoxShadow(
        offset: Offset(2, 2),
        blurRadius: 10,
        color: Color.fromRGBO(0, 0, 0, .15),
      ),
    ];
}
