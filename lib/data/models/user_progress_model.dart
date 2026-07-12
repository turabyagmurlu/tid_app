import 'package:equatable/equatable.dart';

/// Kullanıcının oyunlaştırma ilerlemesi: günlük seri (streak), tamamlanan
/// dersler ve XP. Bölüm 4 (Gamification) için temel model.
class UserProgress extends Equatable {
  final int currentStreak;
  final DateTime? lastStudyDate;
  final Set<String> completedLessonIds;
  final int xp;

  const UserProgress({
    this.currentStreak = 0,
    this.lastStudyDate,
    this.completedLessonIds = const {},
    this.xp = 0,
  });

  UserProgress copyWith({
    int? currentStreak,
    DateTime? lastStudyDate,
    Set<String>? completedLessonIds,
    int? xp,
  }) {
    return UserProgress(
      currentStreak: currentStreak ?? this.currentStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
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
      completedLessonIds: ((map['completed_lesson_ids'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toSet(),
      xp: (map['xp'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'current_streak': currentStreak,
        'last_study_date': lastStudyDate?.toIso8601String(),
        'completed_lesson_ids': completedLessonIds.toList(),
        'xp': xp,
      };

  @override
  List<Object?> get props =>
      [currentStreak, lastStudyDate, completedLessonIds, xp];
}
