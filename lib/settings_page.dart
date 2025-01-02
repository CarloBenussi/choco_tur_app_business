import 'package:choco_tur_app_business/models/choco_tur_business.dart';
import 'package:choco_tur_app_business/utils/lang_codes.dart';
import 'package:choco_tur_app_business/utils/route_names.dart';
import 'package:choco_tur_app_business/widgets/app_bar.dart';
import 'package:choco_tur_app_business/widgets/navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ChocoTurAppBar(),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.generalSettingsSection,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.languageSetting),
              subtitle:
                  Text(LanguageCodes.langCodeToLabel(Provider.of<ChocoTurBusiness>(context, listen: true).language!)!),
              onTap: () => {Navigator.pushNamed(context, RouteNames.languageSelection)}),
        ],
      ),
      bottomNavigationBar: const ChocoTurNavigationBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
