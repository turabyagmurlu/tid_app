import 'package:flutter/material.dart';

/// Erişilebilirlik odaklı, yüksek kontrastlı renk paleti.
/// Sağır/işitme engelli kullanıcılar ve tercüman adayları için
/// WCAG AA kontrast oranları göz önünde bulundurulmuştur.
class AppColors {
  AppColors._();

  // Ana renkler (Bölüm 6 kod taslağındaki teal esas alındı, koyulaştırıldı)
  static const Color primary = Color(0xFF00695C); // Koyu teal
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color accent = Color(0xFFFFA000); // Amber — vurgu / streak

  // Nötr — Açık tema
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF3F5F5);
  static const Color lightOnSurface = Color(0xFF121212);

  // Nötr — Koyu tema
  static const Color darkBackground = Color(0xFF0E1413);
  static const Color darkSurface = Color(0xFF1B2422);
  static const Color darkOnSurface = Color(0xFFF5F5F5);

  // Durum renkleri (geri bildirim)
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1565C0);

  // Bölgesel varyant etiketleri
  static const Color istanbulTag = Color(0xFF1565C0);
  static const Color ankaraTag = Color(0xFF6A1B9A);

  // Mimik / overlay geri bildirim kutuları (yüksek görünürlük)
  static const Color handBox = Color(0xFF00E5FF);
  static const Color faceBox = Color(0xFFFFEA00);
}
