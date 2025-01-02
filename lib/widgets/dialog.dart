import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChocoTurAlertDialog extends StatelessWidget {
  ChocoTurAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.actions,
  });

  final String title;
  final String content;
  final Icon? icon;
  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    actions ??= [
      TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: Text(
            AppLocalizations.of(context)!.dismiss,
            style: const TextStyle(color: Styles.onRedShade),
          ))
    ];
    return AlertDialog(
      backgroundColor: Styles.redShade,
      icon: (icon != null) ? icon : const Icon(Icons.warning_rounded),
      iconColor: Styles.onRedShade,
      title: Text(
        title,
        style: const TextStyle(color: Styles.onRedShade),
      ),
      content: Text(content, style: const TextStyle(color: Styles.onRedShade)),
      elevation: 24.0,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      actions: actions,
    );
  }
}

Future<T?> showChocoTurDialog<T>({
  required BuildContext context,
  required String title,
  required String description,
  Icon? icon,
  required bool dismissable,
  List<Widget>? actions,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return ChocoTurAlertDialog(
        title: title,
        content: description,
        icon: icon,
        actions: actions,
      );
    },
    barrierDismissible: dismissable,
    barrierLabel: dismissable ? "Bareer" : null,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: ChocoTurAlertDialog(
            title: title,
            content: description,
            icon: icon,
            actions: actions,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
