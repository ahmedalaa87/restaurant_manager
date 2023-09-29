import 'package:flutter/material.dart';
import 'package:restaurant_manager/presentation/admin_home/pages/MealPage.dart';
import 'package:restaurant_manager/presentation/admin_home/pages/QrReaderPage.dart';
import 'package:restaurant_manager/presentation/authentication/pages/login_landing_page.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';
import 'package:restaurant_manager/router/routes.dart';

import '../infrastructure/auth/AuthInfo.dart';
import '../presentation/admin_home/pages/AdminHomePage.dart';
import '../presentation/admin_home/pages/StudentPage.dart';
import '../presentation/admin_home/pages/StudentsSearchPage.dart';
import '../presentation/authentication/pages/login_page.dart';
import '../presentation/student_home/pages/StudentHomePage.dart';
import '../themes/dark_theme.dart';

class AppRouter {
  static ThemeMode themeMode = ThemeMode.light;

  static Route? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget? screen = getScreenFromRouteName(settings.name, args);
    if (screen == null) return null;

    return MaterialPageRoute(builder: (context) {
      return CurrentThemeWrapper(
        child: screen,
      );
    });
  }

  static Widget? getScreenFromRouteName(String? name, dynamic args) {
    print(name);
    switch (name) {
      case Routes.root:
        if (AuthInfo.tokenModel != null && AuthInfo.user != null) {
          return getScreenFromRouteName(Routes.home, args);
        }
        return getScreenFromRouteName(Routes.loginLanding, args);
      case Routes.home:
        return AuthInfo.loginType == LoginTypes.student ?  const StudentHomePage() : const AdminHomePage();
      case Routes.loginLanding:
        return const LoginLandingPage();
      case Routes.login:
        return LoginPage(loginType: args.loginType);
      case Routes.meal:
        return MealPage(mealId: args.mealId);
      case Routes.student:
        return StudentPage(student: args.student);
      case Routes.studentSearch:
        return const StudentsSearchPage();
      case Routes.qrCodeReader:
        return const QrReaderPage();
      default:
        return null;
    }
  }
}

class CurrentThemeWrapper extends StatelessWidget {
  final Widget child;

  const CurrentThemeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DarkThemeWrapper(child: child);
  }
}
