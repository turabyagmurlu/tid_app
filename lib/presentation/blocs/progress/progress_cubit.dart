import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/progress_local_datasource.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/user_progress_model.dart';

part 'progress_state.dart';

/// Oyunlaştırma durumu: günlük seri, tamamlanan dersler, öğrenilen kelimeler,
/// XP. Tüm değişiklikler shared_preferences'a kalıcı olarak yazılır.
class ProgressCubit extends Cubit<ProgressState> {
  final ProgressLocalDataSource _store;

  ProgressCubit(this._store) : super(const ProgressState(UserProgress()));

  Future<void> load() async {
    emit(ProgressState(_store.load()));
  }

  void _persist(UserProgress p) {
    emit(ProgressState(p));
    _store.save(p);
  }

  void completeLesson(String lessonId) {
    final p = state.progress;
    if (p.completedLessonIds.contains(lessonId)) return;
    _persist(p.copyWith(
      completedLessonIds: {...p.completedLessonIds, lessonId},
      xp: p.xp + 10,
    ));
  }

  /// Bir kelimenin "öğrenildi" durumunu açar/kapatır.
  void toggleWordLearned(String wordId) {
    final p = state.progress;
    final set = {...p.learnedWordIds};
    if (set.contains(wordId)) {
      set.remove(wordId);
      _persist(p.copyWith(learnedWordIds: set));
    } else {
      set.add(wordId);
      _persist(p.copyWith(learnedWordIds: set, xp: p.xp + 2));
    }
  }

  bool isWordLearned(String wordId) =>
      state.progress.learnedWordIds.contains(wordId);

  /// Favori (yıldız) durumunu açar/kapatır.
  void toggleFavorite(String wordId) {
    final p = state.progress;
    final set = {...p.favoriteWordIds};
    set.contains(wordId) ? set.remove(wordId) : set.add(wordId);
    _persist(p.copyWith(favoriteWordIds: set));
  }

  bool isFavorite(String wordId) =>
      state.progress.favoriteWordIds.contains(wordId);

  void addXp(int amount) {
    final p = state.progress;
    _persist(p.copyWith(xp: p.xp + amount));
  }

  /// Bir dersin tamamlanma oranı (0..1): öğrenilen kelime / toplam kelime.
  double lessonProgress(LessonModel lesson) {
    if (lesson.words.isEmpty) return 0;
    final learned = lesson.words
        .where((w) => state.progress.learnedWordIds.contains(w.wordId))
        .length;
    return learned / lesson.words.length;
  }

  /// Kullanıcı bugün çalıştığında seriyi günceller (kalıcı).
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
      } else if (diff == 0) {
        return; // aynı gün: değişiklik yok, yazma
      }
    }

    _persist(p.copyWith(currentStreak: streak, lastStudyDate: now));
  }
}
