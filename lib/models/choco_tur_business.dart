import 'package:choco_tur_app_business/services/webapp_service.dart';
import 'package:choco_tur_app_business/utils/lang_codes.dart';
import 'package:choco_tur_app_business/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChocoTurBusiness extends ChangeNotifier {
  static Future<ChocoTurBusiness> init() async {
    _prefs = await SharedPreferences.getInstance();

    bool loggedIn = false;

    String? loginEmail = _prefs.getString(_loginEmailKey);
    String? loginAccessToken = _prefs.getString(_loginAccessTokenKey);
    String? loginRefreshToken = _prefs.getString(_loginRefreshTokenKey);
    if ((loginEmail != null) && (loginAccessToken != null)) {
      var loginWithTokenResponse =
          await WebappService.loginBusinessWithToken(loginEmail, loginAccessToken, loginRefreshToken);
      if (loginWithTokenResponse != null) {
        loggedIn = true;
        // Copy eventually refreshed access token and refresh token.
        loginAccessToken = loginWithTokenResponse["accessToken"];
        _prefs.setString(_loginAccessTokenKey, loginAccessToken!);
        loginRefreshToken = loginWithTokenResponse["refreshToken"];
        _prefs.setString(_loginRefreshTokenKey, loginRefreshToken!);
      } else {
        LoggerInstance.logger.e("Failed to login with token.");
      }
    }

    return ChocoTurBusiness(
      loginEmail: loginEmail,
      loginAccessToken: loginAccessToken,
      loginRefreshToken: loginRefreshToken,
      loggedIn: loggedIn,
      language: _prefs.getString(_languageKey),
    );
  }

  ChocoTurBusiness({
    this.loginEmail,
    this.loginAccessToken,
    this.loginRefreshToken,
    required this.loggedIn,
    this.language,
  });

  // SharedPreferences keys.
  static const String _loginEmailKey = "email";
  static const String _loginAccessTokenKey = "loginAccessToken";
  static const String _loginRefreshTokenKey = "loginRefreshToken";
  static const String _languageKey = "lang";

  // User preferences to store.
  String? loginEmail;
  String? loginAccessToken;
  String? loginRefreshToken;
  bool loggedIn;
  String? language;
  static late final SharedPreferences _prefs;

  Locale _locale = const Locale(LanguageCodes.IT);

  Locale get locale {
    if (language != null) {
      _locale = Locale(language!);
    }

    return _locale;
  }

  void setLanguage(BuildContext context, String lang) {
    if (language != null && language == lang) {
      LoggerInstance.logger.d('Language set is equivalent to language saved in preferences ($lang).');
      return;
    }

    language = lang;
    _locale = Locale(lang);
    _prefs.setString(_languageKey, lang);
    notifyListeners();
  }

  void saveLoginInfo(
    String email,
    String? accessToken,
    String? refreshToken,
    bool rememberUser,
  ) async {
    loginEmail = email;
    loginAccessToken = accessToken;
    loginRefreshToken = refreshToken;
    loggedIn = true;

    if (rememberUser) {
      _prefs.setString(_loginEmailKey, email);
      if (accessToken != null) {
        _prefs.setString(_loginAccessTokenKey, accessToken);
      }
      if (refreshToken != null) {
        _prefs.setString(_loginRefreshTokenKey, refreshToken);
      }
    }

    notifyListeners();
  }

  Future<void> logout() async {
    loginEmail = null;
    loginAccessToken = null;
    loginRefreshToken = null;
    loggedIn = false;
    _prefs.remove(_loginEmailKey);
    _prefs.remove(_loginAccessTokenKey);
    _prefs.remove(_loginRefreshTokenKey);
  }
}
