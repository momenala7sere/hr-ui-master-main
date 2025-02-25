// router.dart
import 'package:flutter/material.dart';
import 'package:hr/features/screens/Login_page.dart';
import 'package:hr/features/screens/Track_My_Request.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:hr/screens/ResetPasswordPage.dart';
import 'package:hr/screens/VacationRequeste.dart';         // Vacation Request screen
import 'package:hr/screens/Leave_Requeste.dart';            // Leave Request screen
import 'package:hr/screens/Vacation_History.dart';          // Vacation History screen
import 'package:hr/screens/Leave_History.dart';             // Leave History screen
import 'package:hr/screens/hr/Hr_Requeste.dart';            // HR Request screen
import 'package:hr/features/screens/Hr_History.dart';       // HR Requests History screen

class RouterUtil {
  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    required Function(Locale) onChangeLanguage,
    required Locale currentLocale,
  }) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            onChangeLanguage: onChangeLanguage,
            currentLocale: currentLocale,
          ),
        );
      case '/reset-password':
        return MaterialPageRoute(
          builder: (_) => ResetPasswordPage(
            currentLocale: currentLocale,
          ),
        );
      case '/HomePage':
        return MaterialPageRoute(
          builder: (_) => HomePage(
            currentLocale: currentLocale,
            token: '', // Pass a valid token if needed.
          ),
        );
      case '/vacation-request':
        return MaterialPageRoute(
          builder: (_) => const VacationRequestForm(),
        );
      case '/leave-request':
        return MaterialPageRoute(
          builder: (_) => const LeaveRequestForm(),
        );
      case '/vacation-history':
        return MaterialPageRoute(
          builder: (_) => const VacationHistoryScreen(),
        );
      case '/leaves-history':
        return MaterialPageRoute(
          builder: (_) => const LeaveHistoryScreen(),
        );
      case '/hr-request':
        return MaterialPageRoute(
          builder: (_) => const HrRequestForm(),
        );
      case '/hr-requests-history':
        return MaterialPageRoute(
          builder: (_) => const HrHistoryRequestScreen(),
        );
      case '/track-my-request':
        return MaterialPageRoute(
          builder: (_) => const TrackMyRequest(),
        );
      default:
        // Fallback to LoginPage if route is not found.
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            onChangeLanguage: onChangeLanguage,
            currentLocale: currentLocale,
          ),
        );
    }
  }
}
