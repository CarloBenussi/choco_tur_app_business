import 'dart:ui';

import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialCoachMarkService {
  static Map<String, GlobalKey> globalKeysMap = <String, GlobalKey>{};

  static TutorialCoachMark? _tutorial;

  static TargetFocus _createTarget(String identify, String title, String description, ContentAlign align) {
    return TargetFocus(
      identify: identify,
      keyTarget: globalKeysMap[identify],
      color: Styles.onRedShade,
      enableOverlayTab: true,
      contents: [
        TargetContent(
          align: align,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Styles.redShade, fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  description,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Styles.redShade, fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static TargetFocus _createTargetPosition(
      String identify, TargetPosition targetPosition, String title, String description, ContentAlign align) {
    return TargetFocus(
      identify: identify,
      targetPosition: targetPosition,
      color: Styles.onRedShade,
      enableOverlayTab: true,
      contents: [
        TargetContent(
          align: align,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Styles.redShade, fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  description,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Styles.redShade, fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static Future<void> _onClick(BuildContext context, TargetFocus target) async {}

  static void show(BuildContext context) {
    if (_tutorial == null) {
      List<TargetFocus> targets = [];

      _tutorial = TutorialCoachMark(
          targets: targets, // List<TargetFocus>
          colorShadow: Colors.red, // DEFAULT Colors.black
          alignSkip: Alignment.bottomRight,
          textSkip: AppLocalizations.of(context)!.skipButton,
          textStyleSkip: TextStyle(color: Styles.redShade, fontWeight: FontWeight.bold),
          paddingFocus: 10,
          opacityShadow: 0.8,
          focusAnimationDuration: const Duration(milliseconds: 500),
          unFocusAnimationDuration: const Duration(milliseconds: 500),
          pulseAnimationDuration: const Duration(milliseconds: 500),
          showSkipInLastTarget: true,
          imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          initialFocus: 0,
          useSafeArea: true,
          onFinish: () => {Navigator.pushNamed(context, RouteNames.home)},
          onClickTarget: (target) => {_onClick(context, target)},
          onClickOverlay: (target) => {_onClick(context, target)},
          onSkip: () {
            return true;
          });
    }

    Navigator.pushNamed(context, RouteNames.home);
    _tutorial!.show(context: context);
  }
}
