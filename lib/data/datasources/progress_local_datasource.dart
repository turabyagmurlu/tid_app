import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_progress_model.dart';

/// Kullanıcı ilerlemesini cihazda kalıcı olarak saklar (shared_preferences).
class ProgressLocalDataSource {
  static const String _key = 'user_progress_v1';
  final SharedPreferences prefs;

  const ProgressLocalDataSource(this.prefs);

  UserProgress load() {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const UserProgress();
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      return UserProgress.fromMap(map);
    } catch (_) {
      return const UserProgress();
    }
  }

  Future<void> save(UserProgress progress) async {
    await prefs.setString(_key, json.encode(progress.toMap()));
  }
}
