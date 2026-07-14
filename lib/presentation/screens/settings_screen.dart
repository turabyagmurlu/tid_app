import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_dimensions.dart';
import '../blocs/settings/settings_cubit.dart';

/// Erişilebilirlik ayarları: yazı boyutu ve tema.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, s) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                Text('Yazı Boyutu',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Örnek metin — bu boyutta görünür.',
                  style: TextStyle(fontSize: 16 * s.fontScale),
                ),
                Slider(
                  value: s.fontScale,
                  min: 0.8,
                  max: 1.6,
                  divisions: 8,
                  label: '%${(s.fontScale * 100).round()}',
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setFontScale(v),
                ),
                const Divider(height: AppDimensions.xl),
                Text('Tema', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.sm),
                RadioListTile<ThemeMode>(
                  title: const Text('Sistem (otomatik)'),
                  value: ThemeMode.system,
                  groupValue: s.themeMode,
                  onChanged: (m) =>
                      context.read<SettingsCubit>().setThemeMode(m!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Açık'),
                  value: ThemeMode.light,
                  groupValue: s.themeMode,
                  onChanged: (m) =>
                      context.read<SettingsCubit>().setThemeMode(m!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Koyu'),
                  value: ThemeMode.dark,
                  groupValue: s.themeMode,
                  onChanged: (m) =>
                      context.read<SettingsCubit>().setThemeMode(m!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
