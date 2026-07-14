import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama ayarlarını (yazı boyutu, tema) cihazda saklar.
class SettingsLocalDataSource {
  static const String _fontKey = 'setting_font_scale_v1';
  static const String _themeKey = 'setting_theme_mode_v1';
  static const String _onbKey = 'onboarding_seen_v1';
  final SharedPreferences prefs;

  const SettingsLocalDataSource(this.prefs);

  double loadFontScale() => prefs.getDouble(_fontKey) ?? 1.0;

  /// 0 = system, 1 = light, 2 = dark
  int loadThemeMode() => prefs.getInt(_themeKey) ?? 0;

  bool loadOnboardingSeen() => prefs.getBool(_onbKey) ?? false;

  Future<void> saveFontScale(double v) => prefs.setDouble(_fontKey, v);
  Future<void> saveThemeMode(int v) => prefs.setInt(_themeKey, v);
  Future<void> saveOnboardingSeen(bool v) => prefs.setBool(_onbKey, v);
}
