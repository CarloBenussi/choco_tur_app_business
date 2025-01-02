import 'dart:math' as math;

import 'package:choco_tur_app_business/utils/styles.dart';
import 'package:flutter/material.dart';

class HomePageBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pinkPaint = Paint()
      ..color = Styles.pinkShade
      ..style = PaintingStyle.fill;
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), whitePaint);
    canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: size.width / 2), _degreesToRadians(0),
        _degreesToRadians(90), true, pinkPaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(size.width, size.height), radius: size.width / 3),
        _degreesToRadians(90), _degreesToRadians(270), false, pinkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  // Helper function to convert degrees to radians
  double _degreesToRadians(double degrees) => degrees * math.pi / 180;
}
