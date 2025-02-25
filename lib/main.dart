import 'package:flutter/material.dart';
import 'package:hr/presentation/router/Router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state_management/locale_provider.dart';
import 'state_management/localization_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state_management/generic_bloc.dart';


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
            localeResolutionCallback: LocalizationService.localeResolutionCallback,
            // Use onGenerateRoute to delegate route creation to RouterUtil
            onGenerateRoute: (settings) => RouterUtil.generateRoute(
              settings,
              onChangeLanguage: (locale) => Provider.of<LocaleProvider>(context, listen: false)
                  .setLocale(locale),
              currentLocale: localeProvider.locale,
            ),
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
