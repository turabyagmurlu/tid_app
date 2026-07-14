import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/srs_local_datasource.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/srs_card_model.dart';
import '../../../data/models/word_model.dart';
import '../../../domain/srs/sm2_scheduler.dart';

part 'srs_state.dart';

/// Aralıklı tekrar yöneticisi. "Öğrendim" işaretlenen kelimeler tekrar
/// destesine girer; günü gelenler "Bugün Tekrar"da gösterilir.
class SrsCubit extends Cubit<SrsState> {
  final SrsLocalDataSource _store;
  final Map<String, SrsCard> _cards = {};
  final Map<String, WordModel> _wordMap = {};

  SrsCubit(this._store) : super(const SrsState.initial());

  static bool _hasVideo(WordModel w) =>
      w.regionalVariants.isNotEmpty &&
      w.regionalVariants.first.videoFullBody.trim().isNotEmpty;

  /// Öğrenilen kelimelerden vadesi gelenleri hesaplar.
  void loadDue(List<LessonModel> lessons, Set<String> learnedWordIds) {
    _wordMap
      ..clear()
      ..addEntries(lessons
          .expand((l) => l.words)
          .where(_hasVideo)
          .map((w) => MapEntry(w.wordId, w)));

    _cards
      ..clear()
      ..addAll(_store.load());

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var changed = false;

    // Öğrenilen ama destede olmayan kelimeler için kart oluştur.
    for (final id in learnedWordIds) {
      if (_wordMap.containsKey(id) && !_cards.containsKey(id)) {
        _cards[id] = SrsCard.fresh(id, today);
        changed = true;
      }
    }
    if (changed) _store.save(_cards);

    final due = <WordModel>[];
    for (final entry in _cards.entries) {
      final w = _wordMap[entry.key];
      if (w == null) continue;
      final d = entry.value.dueDate;
      if (!DateTime(d.year, d.month, d.day).isAfter(today)) {
        due.add(w);
      }
    }

    emit(SrsState(dueWords: due, index: 0, finished: due.isEmpty));
  }

  int get dueCount => state.dueWords.length;

  void grade(int quality) {
    if (state.finished || state.dueWords.isEmpty) return;
    final w = state.dueWords[state.index];
    final card = _cards[w.wordId] ?? SrsCard.fresh(w.wordId, DateTime.now());
    _cards[w.wordId] = Sm2Scheduler.review(card, quality, DateTime.now());
    _store.save(_cards);

    if (state.index + 1 >= state.dueWords.length) {
      emit(state.copyWith(finished: true));
    } else {
      emit(state.copyWith(index: state.index + 1));
    }
  }
}
