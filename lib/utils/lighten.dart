import 'package:flutter/material.dart';

Color lighten(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return lightened.toColor();
}
