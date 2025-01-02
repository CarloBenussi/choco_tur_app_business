import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validation {
  static RegExp invitationTokenRegex = RegExp(r"^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$");
  static RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp specialSymbol = RegExp(r'[$()?\-!@#%&_~+=]');
  static RegExp uppercaseLetter = RegExp(r'[A-Z]');
  static RegExp number = RegExp(r'[1-9]');

  static String? validateInvitationToken(BuildContext context, String? token) {
    if (token == null || token.isEmpty) {
      return AppLocalizations.of(context)!.pleaseInsertInvitationToken;
    }

    if (!invitationTokenRegex.hasMatch(token)) {
      return AppLocalizations.of(context)!.invalidInvitationToken;
    }

    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      return AppLocalizations.of(context)!.pleaseInsertEmail;
    }

    if (!emailRegex.hasMatch(email)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.pleaseInsertPassword;
    } else if (password.length < 8) {
      return AppLocalizations.of(context)!.shortPassword;
    } else if (!password.contains(specialSymbol)) {
      return AppLocalizations.of(context)!.missingSpecialSymbol;
    } else if (!password.contains(uppercaseLetter)) {
      return AppLocalizations.of(context)!.missingUppercase;
    } else if (!password.contains(number)) {
      return AppLocalizations.of(context)!.missingNumber;
    }

    return null;
  }
}
