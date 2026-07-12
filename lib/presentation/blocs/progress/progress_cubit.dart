import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_progress_model.dart';

part 'progress_state.dart';

/// Oyunlaştırma durumu: günlük seri, tamamlanan dersler, XP.
///
/// Şimdilik bellek içi çalışır. TODO(persist): Firestore
/// 'users/{uid}/progress' belgesi ile UserProgress.toMap()/fromMap()
/// kullanılarak senkronize edilebilir.
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(const ProgressState(UserProgress()));

  Future<void> load() async {
    // Demo başlangıç durumu (ilk gün serisi).
    emit(const ProgressState(UserProgress(currentStreak: 1)));
  }

  void completeLesson(String lessonId) {
    final p = state.progress;
    emit(ProgressState(p.copyWith(
      completedLessonIds: {...p.completedLessonIds, lessonId},
      xp: p.xp + 10,
    )));
  }

  /// Kullanıcı bugün çalıştığında seriyi günceller.
  void registerStudyToday() {
    final p = state.progress;
    final now = DateTime.now();
    final last = p.lastStudyDate;
    int streak = p.currentStreak;

    if (last == null) {
      streak = 1;
    } else {
      final diff = DateTime(now.year, now.month, now.day)
          .difference(DateTime(last.year, last.month, last.day))
          .inDays;
      if (diff == 1) {
        streak += 1; // ardışık gün
      } else if (diff > 1) {
        streak = 1; // seri kırıldı
      }
      // diff == 0: aynı gün, seri değişmez
    }

    emit(ProgressState(p.copyWith(currentStreak: streak, lastStudyDate: now)));
  }
}
