import 'package:flutter/material.dart';
import 'package:hr/screens/Reset_Password.dart';

class ResetPasswordPage extends StatelessWidget {
  final Locale currentLocale;

  const ResetPasswordPage({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResetPassword(currentLocale: currentLocale),
    );
  }
}
