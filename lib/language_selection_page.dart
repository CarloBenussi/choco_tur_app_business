import 'package:choco_tur_app_business/widgets/language_selection_dropdown_menu.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.redShade,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                "CHOCO TUR",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Styles.onRedShade),
              ),
            ),
            LanguageSelectionDropdownMenu(
              afterSelection: (context) => {Navigator.pushReplacementNamed(context, RouteNames.home)},
            ),
          ],
        ),
      ),
    );
  }
}
