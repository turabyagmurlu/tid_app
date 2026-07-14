import 'package:equatable/equatable.dart';

/// Kullanıcının oyunlaştırma ilerlemesi: günlük seri (streak), tamamlanan
/// dersler, öğrenilen kelimeler ve XP. Kalıcı olarak shared_preferences'ta
/// saklanır (bkz. ProgressLocalDataSource).
class UserProgress extends Equatable {
  final int currentStreak;
  final DateTime? lastStudyDate;
  final Set<String> completedLessonIds;

  /// "Öğrendim" işaretlenen kelimelerin word_id kümesi.
  final Set<String> learnedWordIds;
  final int xp;

  const UserProgress({
    this.currentStreak = 0,
    this.lastStudyDate,
    this.completedLessonIds = const {},
    this.learnedWordIds = const {},
    this.xp = 0,
  });

  UserProgress copyWith({
    int? currentStreak,
    DateTime? lastStudyDate,
    Set<String>? completedLessonIds,
    Set<String>? learnedWordIds,
    int? xp,
  }) {
    return UserProgress(
      currentStreak: currentStreak ?? this.currentStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      learnedWordIds: learnedWordIds ?? this.learnedWordIds,
      xp: xp ?? this.xp,
    );
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    final ts = map['last_study_date'];
    DateTime? last;
    if (ts is String) last = DateTime.tryParse(ts);
    if (ts is int) last = DateTime.fromMillisecondsSinceEpoch(ts);
    return UserProgress(
      currentStreak: (map['current_streak'] ?? 0) as int,
      lastStudyDate: last,
      completedLessonIds:
          ((map['completed_lesson_ids'] as List<dynamic>?) ?? const [])
              .map((e) => e.toString())
              .toSet(),
      learnedWordIds:
          ((map['learned_word_ids'] as List<dynamic>?) ?? const [])
              .map((e) => e.toString())
              .toSet(),
      xp: (map['xp'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'current_streak': currentStreak,
        'last_study_date': lastStudyDate?.toIso8601String(),
        'completed_lesson_ids': completedLessonIds.toList(),
        'learned_word_ids': learnedWordIds.toList(),
        'xp': xp,
      };

  @override
  List<Object?> get props =>
      [currentStreak, lastStudyDate, completedLessonIds, learnedWordIds, xp];
}
