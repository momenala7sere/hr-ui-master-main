import 'package:flutter/material.dart';
import 'package:hr/features/home/forms/VacationRequestForm.dart';
import 'package:hr/features/screens/Login_page.dart';
import 'package:hr/features/screens/ResetPasswordPage.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:hr/screens/home/forms/LeaveRequestForm.dart';
import 'package:hr/screens/home/forms/VacationHistoryApp.dart';
import 'package:hr/screens/hr/Hr_Requeste.dart';

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
            currentLocale: currentLocale, // Pass the current locale
          ),
        );
      case '/HomePage':
        return MaterialPageRoute(
          builder: (context) => HomePage(
            currentLocale: currentLocale, token: '', // Pass current locale
          ),
        );
      case '/vacation-request':
        return MaterialPageRoute(builder: (_) => const VacationRequestForm());
      case '/leave-request':
        return MaterialPageRoute(builder: (_) => const LeaveRequestForm());
      case '/Hr-request':
        return MaterialPageRoute(builder: (_) => const HrRequestForm());
      case '/vacation-history':
        return MaterialPageRoute(builder: (_) => const VacationHistoryApp());
      default:
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            onChangeLanguage: onChangeLanguage,
            currentLocale: currentLocale,
          ),
        );
    }
  }
}
