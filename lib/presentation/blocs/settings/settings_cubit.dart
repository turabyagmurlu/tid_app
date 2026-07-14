import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/settings_local_datasource.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource _store;

  SettingsCubit(this._store)
      : super(SettingsState(
          fontScale: _store.loadFontScale(),
          themeMode: _intToThemeMode(_store.loadThemeMode()),
          onboardingSeen: _store.loadOnboardingSeen(),
        ));

  void markOnboardingSeen() {
    if (state.onboardingSeen) return;
    emit(state.copyWith(onboardingSeen: true));
    _store.saveOnboardingSeen(true);
  }

  static ThemeMode _intToThemeMode(int i) => switch (i) {
        1 => ThemeMode.light,
        2 => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static int _themeModeToInt(ThemeMode m) => switch (m) {
        ThemeMode.light => 1,
        ThemeMode.dark => 2,
        ThemeMode.system => 0,
      };

  void setFontScale(double v) {
    final clamped = v.clamp(0.8, 1.6);
    emit(state.copyWith(fontScale: clamped));
    _store.saveFontScale(clamped);
  }

  void setThemeMode(ThemeMode m) {
    emit(state.copyWith(themeMode: m));
    _store.saveThemeMode(_themeModeToInt(m));
  }
}
