import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: Styles.redShade,
      size: size ?? 60,
    );
  }
}
