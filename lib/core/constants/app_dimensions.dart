/// Boşluk, yarıçap ve erişilebilirlik ölçüleri.
class AppDimensions {
  AppDimensions._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;

  /// Erişilebilirlik: minimum dokunma hedefi (Material: 48dp).
  static const double minTouchTarget = 48;

  // Dudak yakın çekim (PIP) kutusu ölçüleri — Bölüm 6 taslağı
  static const double closeupWidth = 120;
  static const double closeupHeight = 160;
}
