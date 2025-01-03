import 'package:choco_tur_app_business/account_page.dart';
import 'package:choco_tur_app_business/business_home_page.dart';
import 'package:choco_tur_app_business/language_selection_page.dart';
import 'package:choco_tur_app_business/login_page.dart';
import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/password_recovery_process_page.dart';
import 'package:choco_tur_app_business/registration_process_page.dart';
import 'package:choco_tur_app_business/services/firebase_service.dart';
import 'package:choco_tur_app_business/services/webapp_service.dart';
import 'package:choco_tur_app_business/settings_page.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/validation_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var businessUser = await ChocoTurBusiness.init();
  await WebappService.init();
  await FirebaseService.init();
  FlutterNativeSplash.remove();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => businessUser,
      ),
    ],
    child: ChocoTurBusinessApp(business: businessUser),
  ));
}

class ChocoTurBusinessApp extends StatelessWidget {
  const ChocoTurBusinessApp({super.key, required this.business});

  final ChocoTurBusiness business;

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.red);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.red, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Choco Tur Business App',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        home: (business.language == null)
            ? const LanguageSelection()
            : (business.loggedIn)
                ? const BusinessHomePage()
                : const LoginPage(),
        locale: Provider.of<ChocoTurBusiness>(context).locale,
        routes: {
          RouteNames.languageSelection: (context) => const LanguageSelection(),
          RouteNames.login: (context) => const LoginPage(),
          RouteNames.home: (context) => const BusinessHomePage(),
          RouteNames.account: (context) => const AccountPage(),
          RouteNames.settings: (context) => const SettingsPage(),
          RouteNames.registrationProcess: (context) => const RegistrationProcessPage(),
          RouteNames.passwordRecoveryProcess: (context) => const PasswordRecoveryProcessPage(),
          RouteNames.validation: (context) => const ValidationPage(),
        },
      );
    });
  }
}
