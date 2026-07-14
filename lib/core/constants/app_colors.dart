import 'package:flutter/material.dart';

/// Erişilebilirlik odaklı, yüksek kontrastlı renk paleti.
/// Sağır/işitme engelli kullanıcılar ve tercüman adayları için
/// WCAG AA kontrast oranları göz önünde bulundurulmuştur.
class AppColors {
  AppColors._();

  // Ana renkler — canlı teal marka + derinlik için koyu ton
  static const Color primary = Color(0xFF00897B); // Canlı teal
  static const Color primaryDark = Color(0xFF00695C); // Gradyan/derinlik
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color accent = Color(0xFFFFB300); // Amber — vurgu / streak

  // Nötr — Açık tema (hafif teal tonlu yüzeyler)
  static const Color lightBackground = Color(0xFFF6FAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF10201D);

  // Nötr — Koyu tema (kart ayrımı için kademeli yüzeyler)
  static const Color darkBackground = Color(0xFF0C1211);
  static const Color darkSurface = Color(0xFF15201E);
  static const Color darkSurfaceHigh = Color(0xFF1E2B28);
  static const Color darkOnSurface = Color(0xFFF3F7F6);

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

  // Seviye renk-kodlama (canlı, ilerleyen palet)
  static const Color levelA1 = Color(0xFF14B8A6); // teal
  static const Color levelA2 = Color(0xFF3B82F6); // mavi
  static const Color levelB1 = Color(0xFF8B5CF6); // mor
  static const Color levelB2 = Color(0xFFF59E0B); // turuncu
  static const Color levelC1 = Color(0xFFEC4899); // pembe
  static const Color levelC2 = Color(0xFFEF4444); // kırmızı

  /// Seviyeye göre ana renk.
  static Color forLevel(String level) {
    switch (level) {
      case 'A1':
        return levelA1;
      case 'A2':
        return levelA2;
      case 'B1':
        return levelB1;
      case 'B2':
        return levelB2;
      case 'C1':
        return levelC1;
      case 'C2':
        return levelC2;
      default:
        return primary;
    }
  }

  /// Bir rengin biraz açık/koyu tonuyla 2 renkli gradyan (glow için).
  static List<Color> gradientFor(Color c) {
    final hsl = HSLColor.fromColor(c);
    final lighter =
        hsl.withLightness((hsl.lightness + 0.12).clamp(0.0, 1.0)).toColor();
    final darker =
        hsl.withLightness((hsl.lightness - 0.10).clamp(0.0, 1.0)).toColor();
    return [lighter, darker];
  }
}
