import 'word_model.dart';

/// Tek bir çoktan seçmeli quiz sorusu: bir kelimenin videosu gösterilir,
/// kullanıcı 4 Türkçe şıktan doğruyu seçer.
class QuizQuestion {
  final WordModel word;
  final List<String> options; // 4 şık, karışık
  final String correct; // = word.turkishWord

  const QuizQuestion({
    required this.word,
    required this.options,
    required this.correct,
  });
}
