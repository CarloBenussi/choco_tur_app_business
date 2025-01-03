import 'package:choco_tur_app_business/widgets/app_bar.dart';
import 'package:choco_tur_app_business/widgets/drawer.dart';
import 'package:choco_tur_app_business/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

class ValidationPage extends StatelessWidget {
  const ValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChocoTurAppBar(),
      drawer: ChocoTurDrawer(),
      body: Placeholder(),
      bottomNavigationBar: ChocoTurNavigationBar(
        selectedIndex: 1,
      ),
    );
  }
}
