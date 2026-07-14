part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final double fontScale;
  final ThemeMode themeMode;
  final bool onboardingSeen;

  const SettingsState({
    required this.fontScale,
    required this.themeMode,
    this.onboardingSeen = false,
  });

  SettingsState copyWith({
    double? fontScale,
    ThemeMode? themeMode,
    bool? onboardingSeen,
  }) {
    return SettingsState(
      fontScale: fontScale ?? this.fontScale,
      themeMode: themeMode ?? this.themeMode,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }

  @override
  List<Object?> get props => [fontScale, themeMode, onboardingSeen];
}
