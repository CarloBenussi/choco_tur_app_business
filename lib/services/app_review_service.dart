import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:choco_tur_app_business/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_review/in_app_review.dart';

class AppReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;

  static _review() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      _inAppReview.openStoreListing();
    }
  }

  static review(BuildContext context) async {
    showChocoTurDialog(
        context: context,
        title: AppLocalizations.of(context)!.askForReviewTitle,
        description: AppLocalizations.of(context)!.askForReviewDescription,
        dismissable: false,
        actions: [
          TextButton(
              onPressed: () => {Navigator.pop(context)},
              child: Text(
                AppLocalizations.of(context)!.noButton,
                style: const TextStyle(color: Styles.onRedShade),
              )),
          TextButton(
              onPressed: () => {AppReviewService._review()},
              child: Text(
                AppLocalizations.of(context)!.yesButton,
                style: const TextStyle(color: Styles.onRedShade),
              )),
        ]);
  }
}
