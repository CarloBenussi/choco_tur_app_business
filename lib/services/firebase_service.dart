// ignore_for_file: use_build_context_synchronously

import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseService {
  static const String firebaseBucket = String.fromEnvironment('FIREBASE_BUCKET');

  static FirebaseApp? _fbApp;
  static FirebaseMessaging? _firebaseMessaging;

  static Future<void> init() async {
    _fbApp = await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_APP_ID'),
      projectId: String.fromEnvironment('FIREBASE_PRJECT_ID'),
    ));
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttest,
    );

    _firebaseMessaging = FirebaseMessaging.instance;
  }

  static Future<void> recordDeviceTokenIfNotPresent(BuildContext context) async {
    // Get the device registration token if never set.
    if (Provider.of<ChocoTurBusiness>(context, listen: false).deviceRegistrationToken == null) {
      Provider.of<ChocoTurBusiness>(context, listen: false).deviceRegistrationToken =
          await _firebaseMessaging!.getToken();
    }
  }
}
