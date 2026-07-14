import 'dart:math';

import '../../data/models/lesson_model.dart';
import '../../data/models/quiz_question_model.dart';
import '../../data/models/word_model.dart';

/// Bir dersten çoktan seçmeli quiz soruları üretir.
///
/// Sadece gömülü videosu olan kelimeler soru olarak kullanılır (video
/// gösterilebilsin diye). Çeldiriciler önce aynı dersten, yetmezse
/// [extraPool] havuzundan seçilir.
class QuizGenerator {
  static bool _hasVideo(WordModel w) =>
      w.regionalVariants.isNotEmpty &&
      w.regionalVariants.first.videoFullBody.trim().isNotEmpty;

  static List<QuizQuestion> generate(
    LessonModel lesson, {
    List<WordModel> extraPool = const [],
    int? count,
    int? seed,
  }) {
    final rng = Random(seed);
    final playable = lesson.words.where(_hasVideo).toList();
    if (playable.length < 2) return const [];

    // Çeldirici havuzu: dersteki + ekstra havuzdaki benzersiz Türkçe kelimeler.
    final pool = <String>{
      ...lesson.words.map((w) => w.turkishWord),
      ...extraPool.map((w) => w.turkishWord),
    };

    final questions = <QuizQuestion>[];
    final ordered = [...playable]..shuffle(rng);
    final take = count == null ? ordered.length : min(count, ordered.length);

    for (var i = 0; i < take; i++) {
      final w = ordered[i];
      final correct = w.turkishWord;
      final distractors = (pool.where((t) => t != correct).toList()..shuffle(rng))
          .take(3)
          .toList();
      final opts = [correct, ...distractors]..shuffle(rng);
      questions.add(QuizQuestion(word: w, options: opts, correct: correct));
    }
    return questions;
  }
}
