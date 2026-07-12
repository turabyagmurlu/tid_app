import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/lesson_model.dart';
import 'lesson_datasource.dart';

/// Firebase yapılandırılmadığında ya da çevrimdışıyken kullanılan yedek kaynak.
/// assets/seed/lessons_seed.json dosyasını okur.
class LocalSeedLessonDataSource implements LessonDataSource {
  const LocalSeedLessonDataSource();

  static const String _assetPath = 'assets/seed/lessons_seed.json';

  Future<List<LessonModel>> _readAll() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final rawLessons = (decoded['lessons'] as List<dynamic>? ?? const []);
    return rawLessons
        .map((e) => LessonModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<LessonModel>> fetchLessons() => _readAll();

  @override
  Future<LessonModel?> fetchLessonById(String lessonId) async {
    final all = await _readAll();
    for (final lesson in all) {
      if (lesson.lessonId == lessonId) return lesson;
    }
    return null;
  }
}
