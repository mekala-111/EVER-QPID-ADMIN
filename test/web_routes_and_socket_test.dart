import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Features/auth/view_model/login_view_model.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_pages.dart';
import 'package:everqpidadmin/Settings/utils/p_routes.dart';
import 'package:everqpidadmin/employeelogin/chatmangaement/socketservice/socketservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LoggedInUser.clearUserData();
    await SocketService.instance.dispose();
  });

  testWidgets('login screen renders', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
        child: const MaterialApp(home: LoginScreenForTest()),
      ),
    );

    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('protected dashboard redirects an unauthenticated user',
      (tester) async {
    final route = Routes.genericRoute(
      const RouteSettings(name: PPages.dashboard),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => WrapperViewModel()),
        ],
        child: MaterialApp(onGenerateRoute: (_) => route),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });

  test('socket initialization without authentication fails safely', () async {
    await SocketService.instance.initialize('employee-1');

    expect(
      SocketService.instance.connectionState,
      SocketConnectionState.failed,
    );
    expect(SocketService.instance.isConnected, isFalse);
  });
}

class LoginScreenForTest extends StatelessWidget {
  const LoginScreenForTest({super.key});

  @override
  Widget build(BuildContext context) {
    final route = Routes.genericRoute(
      const RouteSettings(name: PPages.login),
    );
    return Navigator(onGenerateRoute: (_) => route);
  }
}
