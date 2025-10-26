import 'package:flutter/material.dart';

/// QuizWiz uygulaması için renk paleti
/// Görsellerden alınan karanlık cosmic tema renkleri
class AppColors {
  // Gradyan renkleri (Arka plan için)
  static const Color darkBlue1 = Color(0xFF1a1a2e); // En koyu mavi
  static const Color darkBlue2 = Color(0xFF16213e);
  static const Color purple1 = Color(0xFF533483);
  static const Color purple2 = Color(0xFF8b5fbf);

  // Aksan renkleri
  static const Color white = Colors.white;
  static const Color lightBlue = Color(0xFF4a9eff);
  static const Color lightPurple = Color(0xFFa78bfa);
  static const Color lightPink = Color(0xFFf472b6);

  // Gradyan renk geçişleri
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBlue1, darkBlue2, purple1],
  );

  // Buton gradyanı (Mavi'den Pembe'ye)
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [lightBlue, lightPink],
  );

  // Navigation aktif renk
  static const Color activeNavColor = lightBlue;

  // Kart arka planı (hafif şeffaf beyaz)
  static const Color cardBackground = Color(0x1AFFFFFF);

  // Yıldız/Sparkle efekti için
  static const Color starColor = Color(0xFFFFFFFF);
}
