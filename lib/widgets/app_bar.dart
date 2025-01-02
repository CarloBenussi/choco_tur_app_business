import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';

class ChocoTurAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChocoTurAppBar({super.key, this.tabBar});

  final TabBar? tabBar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.onRedShade,
      foregroundColor: Styles.redShade,
      bottom: tabBar,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
