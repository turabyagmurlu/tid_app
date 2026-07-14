part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final double fontScale;
  final ThemeMode themeMode;

  const SettingsState({required this.fontScale, required this.themeMode});

  SettingsState copyWith({double? fontScale, ThemeMode? themeMode}) {
    return SettingsState(
      fontScale: fontScale ?? this.fontScale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [fontScale, themeMode];
}
