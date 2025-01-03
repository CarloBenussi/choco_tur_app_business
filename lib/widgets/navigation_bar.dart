import 'package:choco_tur_app_business/services/tutorial_coach_mark_service.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ChocoTurNavigationBar extends StatelessWidget {
  const ChocoTurNavigationBar({super.key, this.selectedIndex = 0});

  static final Map<int, String> indexToRouteNames = {
    0: RouteNames.home,
    1: RouteNames.validation,
  };
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    // Reassign global keys on every rebuild: they need to be unique.
    TutorialCoachMarkService.globalKeysMap[TutorialCoachMarkService.NAVIGATOR_HOME_BUTTON_KEY] = GlobalKey();
    TutorialCoachMarkService.globalKeysMap[TutorialCoachMarkService.NAVIGATOR_VALIDATION_BUTTON_KEY] = GlobalKey();
    return NavigationBarTheme(
      data: const NavigationBarThemeData(
        labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Styles.onRedShade)),
      ),
      child: NavigationBar(
          backgroundColor: Styles.redShade,
          indicatorColor: Styles.onRedShade,
          destinations: <Widget>[
            NavigationDestination(
              key: TutorialCoachMarkService.globalKeysMap[TutorialCoachMarkService.NAVIGATOR_HOME_BUTTON_KEY],
              selectedIcon: Icon(
                Icons.home_rounded,
                color: Styles.redShade,
              ),
              icon: const Icon(
                Icons.home_outlined,
                color: Styles.onRedShade,
              ),
              label: AppLocalizations.of(context)!.homeButton,
            ),
            NavigationDestination(
              key: TutorialCoachMarkService.globalKeysMap[TutorialCoachMarkService.NAVIGATOR_VALIDATION_BUTTON_KEY],
              selectedIcon: Icon(
                Icons.check_rounded,
                color: Styles.redShade,
              ),
              icon: const Icon(
                Icons.check_outlined,
                color: Styles.onRedShade,
              ),
              label: AppLocalizations.of(context)!.validationButton,
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            String? routeName = indexToRouteNames[index];
            if (routeName != null) Navigator.pushNamed(context, routeName);
          }),
    );
  }
}
