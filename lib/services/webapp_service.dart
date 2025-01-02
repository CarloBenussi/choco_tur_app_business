// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/utils/logger.dart';
import 'package:choco_tur_app_business/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum HttpRequestMethod {
  get,
  post,
}

class WebappService {
  static const String webAppUrl = String.fromEnvironment('WEBAPP_URL');
  static const String invitationValidationEndpoint = "/business/validateInvitation";
  static const String registrationEndpoint = "/business/registration";
  static const String confirmEmailEndpoint = "/business/registrationConfirmation";
  static const String resendEmailVerificationNumberEndpoint = "/business/resendEmailVerificationNumber";
  static const String loginEndpoint = "/business/login";
  static const String loginWithTokenEndpoint = "/business/loginWithToken";
  static const String refreshTokenEndpoint = "/business/refreshToken";
  static const String resetPasswordEndpoint = "/business/resetPassword";
  static const String resetPasswordTestEndpoint = "/business/resetPasswordTest";
  static const String changePasswordEndpoint = "/business/changePassword";

  static const String userToursEndpoint = "/tours/user/tours";
  static const String activateUserTourEndpoint = "/tours/user/activateTour";
  static const String deactivateUserTourEndpoint = "/tours/user/deactivateTour";
  static const String advanceUserTourEndpoint = "/tours/user/advanceTour";
  static const String revertUserTourEndpoint = "/tours/user/revertTour";
  static const String toursEndpoint = "/tours/tours";
  static const String tourStopsEndpoint = "/tours/tourStops";
  static const String tourStopStoriesEndpoint = "/tours/tourStopStories";

  static List<int> tokenExpiredStatusCodes = [401, 403];

  static HttpClient? _client;

  static Future<void> init() async {
    SecurityContext securityContext = SecurityContext.defaultContext;
    _client = HttpClient(context: securityContext);
    _client!.connectionTimeout = const Duration(seconds: 5);
    _client!.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  static Future<bool> validateInvitation(BuildContext context, String email, String invitationToken) async {
    Uri uri = _buildUri(invitationValidationEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    String body = jsonEncode({'email': email, 'invitationToken': invitationToken});
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger.e('Got error response for registration: ${response.statusCode}, $responseBody');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.invitationValidationFailed,
        description: responseBody,
        dismissable: true,
      );

      return false;
    }

    return true;
  }

  static Future<String?> registerBusiness(
    BuildContext context,
    String email,
    String password,
    String matchingPassword,
  ) async {
    Uri uri = _buildUri(registrationEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    String body = jsonEncode({
      'email': email,
      'password': password,
      'matchingPassword': matchingPassword,
    });
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger.e('Got error response for registration: ${response.statusCode}, $responseBody');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.registrationFailed,
        description: responseBody,
        dismissable: true,
      );

      return null;
    }

    // The returned body is the email verification number itself: return it so we can call "resendEmailVerificationNumber".
    return responseBody;
  }

  static Future<bool> confirmEmail(BuildContext context, String email, String numberSequence) async {
    var params = {
      'email': email,
      'number': numberSequence,
    };
    Uri uri = _buildUri(confirmEmailEndpoint, params);
    HttpClientRequest request = await _client!.getUrl(uri);
    HttpClientResponse response = await request.close();
    if (response.statusCode != 200) {
      String reason = await response.transform(utf8.decoder).join();
      LoggerInstance.logger.e('Got error response for email confirmation: ${response.statusCode}, $reason');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.registrationConfirmationFailed,
        description: reason,
        dismissable: true,
      );

      return false;
    }

    Map<String, dynamic> body = jsonDecode(await response.transform(utf8.decoder).join());
    Provider.of<ChocoTurBusiness>(context, listen: false).saveLoginInfo(
      email,
      body["accessToken"],
      body["refreshToken"],
      true,
    );
    return true;
  }

  static Future<String?> resendEmailVerificationCode(
    BuildContext context,
    String email,
    String number,
  ) async {
    var params = {
      'email': email,
      'number': number,
    };
    Uri uri = _buildUri(resendEmailVerificationNumberEndpoint, params);
    HttpClientRequest request = await _client!.getUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    HttpClientResponse response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger
          .e('Got error response for resend email verification code request:${response.statusCode}, $responseBody');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.resendEmailVerificaionCodeFailed,
        description: responseBody,
        dismissable: true,
      );

      return null;
    }

    // The returned body is the email verification number itself: return it so we can call "resendEmailVerificationNumber" again.
    return responseBody;
  }

  static Future<bool> loginBusiness(BuildContext context, String email, String password, bool rememberBusiness) async {
    Uri uri = _buildUri(loginEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    String body = jsonEncode({'email': email, 'password': password});
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    if (response.statusCode != 200) {
      String reason = await response.transform(utf8.decoder).join();
      LoggerInstance.logger.e('Got error response for registration: ${response.statusCode}, $reason');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.loginFailed,
        description: reason,
        dismissable: true,
      );

      return false;
    }

    Map<String, dynamic> returnBody = jsonDecode(await response.transform(utf8.decoder).join());
    Provider.of<ChocoTurBusiness>(context, listen: false).saveLoginInfo(
      email,
      returnBody["accessToken"],
      returnBody["refreshToken"],
      rememberBusiness,
    );

    return true;
  }

  static Future<dynamic> loginBusinessWithToken(String email, String accessToken, String? refreshToken) async {
    Uri uri = _buildUri(loginWithTokenEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    String body = jsonEncode({'email': email, 'accessToken': accessToken});
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      LoggerInstance.logger.d("Login with token successful");

      return jsonDecode(await response.transform(utf8.decoder).join());
    } else if (tokenExpiredStatusCodes.contains(response.statusCode)) {
      LoggerInstance.logger.d("Expired access token, trying to use refresh token.");

      if (refreshToken == null) {
        LoggerInstance.logger.w("No refresh token save on user preferences.");
        return null;
      }

      return _refreshToken(email, refreshToken);
    } else {
      LoggerInstance.logger.e('Got error response for registration: ${response.statusCode}, ${response.reasonPhrase}');
      return null;
    }
  }

  static Future<bool> resetPassword(
    BuildContext context,
    String email,
  ) async {
    Uri uri = _buildUri(resetPasswordEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.add(utf8.encode(email));
    HttpClientResponse response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger.e('Got error response for password reset: ${response.statusCode}, $responseBody');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.passwordResetFailed,
        description: responseBody,
        dismissable: true,
      );

      return false;
    }

    return true;
  }

  static Future<bool> resetPasswordTest(BuildContext context, String email, String numberSequence) async {
    var params = {
      'email': email,
      'number': numberSequence,
    };
    Uri uri = _buildUri(resetPasswordTestEndpoint, params);
    HttpClientRequest request = await _client!.getUrl(uri);
    HttpClientResponse response = await request.close();
    if (response.statusCode != 200) {
      String reason = await response.transform(utf8.decoder).join();
      LoggerInstance.logger.e('Got error response for password reset test: ${response.statusCode}, $reason');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.passwordResetTestFailed,
        description: reason,
        dismissable: true,
      );

      return false;
    }

    return true;
  }

  static Future<bool> changePassword(
    BuildContext context,
    String email,
    String number,
    String password,
    String matchingPassword,
  ) async {
    Uri uri = _buildUri(changePasswordEndpoint);
    HttpClientRequest request = await _client!.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    String body = jsonEncode({
      'email': email,
      'passwordRecoveryNumber': number,
      'password': password,
      'matchingPassword': matchingPassword,
    });
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger.e('Got error response for password change: ${response.statusCode}, $responseBody');

      showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.passwordChangeFailed,
        description: responseBody,
        dismissable: true,
      );

      return false;
    }

    return true;
  }

  /*---------------------------------------------------------------------------*/

  static Uri _buildUri(String endpoint, [dynamic params]) {
    bool ssl = const bool.fromEnvironment('SSL_ENABLED');
    if (ssl) {
      return Uri.https(webAppUrl, endpoint, params);
    } else {
      return Uri.http(webAppUrl, endpoint, params);
    }
  }

  static Future<HttpClientResponse?> _redoRequestWithRefreshedToken(
      BuildContext context, Uri uri, HttpRequestMethod method,
      [String? body]) async {
    String? email = Provider.of<ChocoTurBusiness>(context, listen: false).loginEmail;
    String? refreshToken = Provider.of<ChocoTurBusiness>(context, listen: false).loginRefreshToken;
    if ((email == null) || (refreshToken == null)) {
      LoggerInstance.logger.e("No email or refresh token stored for user, cannot download tours info.");
      return null;
    }

    var refreshResponse = await _refreshToken(email, refreshToken);
    if (refreshResponse == null) {
      LoggerInstance.logger.e("Failed to refresh user token.");
      return null;
    }

    // Save refreshed user tokens.
    Provider.of<ChocoTurBusiness>(context, listen: false).loginAccessToken = refreshResponse["accessToken"];
    Provider.of<ChocoTurBusiness>(context, listen: false).loginRefreshToken = refreshResponse["refreshToken"];

    // Redo request.
    HttpClientRequest newRequest =
        (method == HttpRequestMethod.get) ? await _client!.getUrl(uri) : await _client!.postUrl(uri);
    if (method == HttpRequestMethod.post) newRequest.add(utf8.encode(body!));
    newRequest.headers
        .set('Authorization', "Bearer ${Provider.of<ChocoTurBusiness>(context, listen: false).loginAccessToken}");
    return await newRequest.close();
  }

  static Future<dynamic> _refreshToken(String email, String refreshToken) async {
    var params = {
      'email': email,
      'refreshToken': refreshToken,
    };
    Uri uri = _buildUri(refreshTokenEndpoint, params);
    HttpClientRequest request = await _client!.getUrl(uri);
    HttpClientResponse response = await request.close();
    String body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      LoggerInstance.logger.w('Got error response for refresh token: ${response.statusCode}, $body');
      return null;
    }

    return jsonDecode(body);
  }
}
