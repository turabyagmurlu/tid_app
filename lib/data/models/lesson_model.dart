import 'package:equatable/equatable.dart';

import 'word_model.dart';

/// Bir ders: seviye (A1..C2), modül ve içindeki işaretler (kelimeler).
class LessonModel extends Equatable {
  final String lessonId;
  final String title;
  final String level; // A1, A2, B1, B2, C1, C2
  final String module; // "Modül 1: Başlangıç"
  final List<WordModel> words;

  const LessonModel({
    required this.lessonId,
    required this.title,
    required this.level,
    required this.module,
    required this.words,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    final rawWords = (map['words'] as List<dynamic>? ?? const []);
    final words = rawWords
        .map((e) => WordModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    return LessonModel(
      lessonId: (map['lesson_id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      level: (map['level'] ?? '') as String,
      module: (map['module'] ?? '') as String,
      words: words,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'lesson_id': lessonId,
        'title': title,
        'level': level,
        'module': module,
        'words': words.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object?> get props => [lessonId, title, level, module, words];
}
