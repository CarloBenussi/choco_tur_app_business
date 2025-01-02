import 'dart:ui';

import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/services/app_review_service.dart';
import 'package:choco_tur_app_business/services/tutorial_coach_mark_service.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:choco_tur_app_business/widgets/dialog.dart';
import 'package:choco_tur_app_business/widgets/loading_animation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChocoTurDrawer extends StatefulWidget {
  const ChocoTurDrawer({super.key});

  @override
  State<ChocoTurDrawer> createState() => _ChocoTurDrawerState();
}

class _ChocoTurDrawerState extends State<ChocoTurDrawer> {
  bool _processing = false;

  void _onLogoutPressed(BuildContext context) async {
    setState(() {
      _processing = true;
    });
    await Provider.of<ChocoTurBusiness>(context, listen: false).logout();
    setState(() {
      _processing = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Drawer(
        backgroundColor: Styles.redShade,
        surfaceTintColor: Styles.onRedShade,
        shadowColor: Styles.onRedShade,
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "CHOCO TUR",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Styles.onRedShade),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Styles.onRedShade,
              ),
              title: Text(
                AppLocalizations.of(context)!.settingsButton,
                style: const TextStyle(color: Styles.onRedShade),
              ),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.settings);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
                color: Styles.onRedShade,
              ),
              title: Text(
                AppLocalizations.of(context)!.accountButton,
                style: const TextStyle(color: Styles.onRedShade),
              ),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.account);
              },
            ),
            ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Styles.onRedShade,
                ),
                title: Text(
                  AppLocalizations.of(context)!.logoutButton,
                  style: const TextStyle(color: Styles.onRedShade),
                ),
                onTap: Provider.of<ChocoTurBusiness>(context).loggedIn
                    ? () {
                        showChocoTurDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.areYouSureLogout,
                          description: AppLocalizations.of(context)!.areYouSureLogoutIndication,
                          actions: [
                            TextButton(
                                onPressed: () => {Navigator.pop(context)},
                                child: Text(
                                  AppLocalizations.of(context)!.noButton,
                                  style: const TextStyle(color: Styles.onRedShade),
                                )),
                            TextButton(
                                onPressed: () => _onLogoutPressed(context),
                                child: Text(
                                  AppLocalizations.of(context)!.yesButton,
                                  style: const TextStyle(color: Styles.onRedShade),
                                )),
                          ],
                          dismissable: true,
                        );
                      }
                    : null),
            const Divider(
              thickness: 0.5,
              color: Styles.onRedShade,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_mark_outlined,
                color: Styles.onRedShade,
              ),
              title: Text(
                AppLocalizations.of(context)!.guideButton,
                style: const TextStyle(color: Styles.onRedShade),
              ),
              onTap: () => {TutorialCoachMarkService.show(context)},
            ),
            ListTile(
              leading: const Icon(
                Icons.feedback_outlined,
                color: Styles.onRedShade,
              ),
              title: Text(
                AppLocalizations.of(context)!.feedbackButton,
                style: const TextStyle(color: Styles.onRedShade),
              ),
              onTap: () => {AppReviewService.review(context)},
            ),
            ListTile(
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Styles.onRedShade,
                ),
                title: Text(
                  AppLocalizations.of(context)!.aboutButton,
                  style: const TextStyle(color: Styles.onRedShade),
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "CHOCO TUR BUSINESS",
                    applicationVersion: "1.0.0",
                    applicationIcon: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/logo.png",
                        width: 40,
                      ),
                    ),
                    applicationLegalese: "Legalese",
                    barrierDismissible: true,
                  );
                }),
          ],
        ),
      ),
      if (_processing)
        Flexible(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const Center(
              child: LoadingAnimation(),
            ),
          ),
        ),
    ]);
  }
}
