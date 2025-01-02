import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, this.clearNavigator = false});

  final bool clearNavigator;

  void _onPressed(BuildContext context) {
    if (clearNavigator) {
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Styles.redShade,
      ),
      onPressed: () => _onPressed(context),
      icon: const Icon(
        Icons.login_rounded,
        color: Styles.onRedShade,
      ),
      label: Text(
        AppLocalizations.of(context)!.signInButtonLabel,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Styles.onRedShade),
      ),
    );
  }
}
