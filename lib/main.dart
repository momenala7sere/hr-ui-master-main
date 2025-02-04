import 'package:flutter/material.dart';
import 'package:hr/features/screens/Hr_History.dart';
import 'package:hr/features/screens/Login_page.dart';
import 'package:hr/screens/Leave_History.dart';
import 'package:hr/screens/Leave_Requeste.dart';
import 'package:hr/screens/Track_My_Request.dart';
import 'package:hr/screens/VacationRequeste.dart';
import 'package:hr/screens/Vacation_History.dart';
import 'package:hr/screens/hr/Hr_Requeste.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state_management/locale_provider.dart';
import 'state_management/localization_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hr/screens/ResetPasswordPage.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'state_management/generic_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.load(const Locale('en', 'US')); // Default language
  runApp(const HRApp());
}

class HRApp extends StatelessWidget {
  const HRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(), // Manage global locale state
        ),
        BlocProvider(
          create: (_) => GenericBloc(
            submitDataCallback: (data) async {
              // Mock callback for testing
              print('Data submitted: $data');
              return Future.value(data); // Return the same data for now
            },
            fetchDataCallback: () async {
              // Mock callback for fetching data
              print('Fetching data...');
              return Future.value('Fetched Data'); // Return mock fetched data
            },
          ),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale, // Use the globally managed locale
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback:
                LocalizationService.localeResolutionCallback,
            routes: {
              '/login': (context) => LoginPage(
                    onChangeLanguage: (locale) =>
                        Provider.of<LocaleProvider>(context, listen: false)
                            .setLocale(locale),
                    currentLocale: localeProvider.locale,
                  ),
              '/HomePage': (context) => FutureBuilder<String?>(
                    future: FlutterSecureStorage().read(key: 'token'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final token = snapshot.data ?? '';
                      if (token.isEmpty) {
                        return LoginPage(
                          onChangeLanguage: (locale) =>
                              Provider.of<LocaleProvider>(context, listen: false)
                                  .setLocale(locale),
                          currentLocale: localeProvider.locale,
                        );
                      }
                      return HomePage(
                        currentLocale: localeProvider.locale,
                        token: token,
                      );
                    },
                  ),
              '/reset-password': (context) => ResetPasswordPage(
                    currentLocale: localeProvider.locale,
                  ),
              '/vacation-request': (context) => const VacationRequestForm(),
              '/leave-request': (context) => const LeaveRequestForm(),
              '/vacation-history': (context) => const VacationHistoryScreen(),
              '/leaves-history': (context) => const LeaveHistoryApp(),
              '/Hr-request': (context) => const HrRequestForm(),
              '/Hr-requests-history': (context) =>
                  const HrHistoryRequestScreen(),
              '/track-my-request': (context) => const TrackMyRequest(),
            },
            initialRoute: '/login',
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text(
                    '404: Route ${settings.name} not found!',
                    style: const TextStyle(fontSize: 24, color: Colors.red),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
