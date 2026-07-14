import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/srs_card_model.dart';

/// SRS kartlarını cihazda saklar (word_id -> SrsCard).
class SrsLocalDataSource {
  static const String _key = 'srs_cards_v1';
  final SharedPreferences prefs;

  const SrsLocalDataSource(this.prefs);

  Map<String, SrsCard> load() {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      return map.map((k, v) =>
          MapEntry(k, SrsCard.fromMap(Map<String, dynamic>.from(v as Map))));
    } catch (_) {
      return {};
    }
  }

  Future<void> save(Map<String, SrsCard> cards) async {
    final map = cards.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_key, json.encode(map));
  }
}
