import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBlue1 = Color(0xFF1a1a2e);
  static const Color darkBlue2 = Color(0xFF16213e);
  static const Color purple1 = Color(0xFF533483);
  static const Color purple2 = Color(0xFF8b5fbf);

  static const Color white = Colors.white;
  static const Color lightBlue = Color(0xFF4a9eff);
  static const Color lightPurple = Color(0xFFa78bfa);
  static const Color lightPink = Color(0xFFf472b6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBlue1, darkBlue2, purple1],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [lightBlue, lightPink],
  );

  static const Color activeNavColor = lightBlue;

  static const Color cardBackground = Color(0x1AFFFFFF);

  static const Color starColor = Color(0xFFFFFFFF);
}
