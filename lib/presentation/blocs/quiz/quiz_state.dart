part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  final List<QuizQuestion> questions;
  final int index;
  final String? selected;
  final int correctCount;
  final bool finished;

  const QuizState({
    required this.questions,
    required this.index,
    required this.selected,
    required this.correctCount,
    required this.finished,
  });

  const QuizState.initial()
      : questions = const [],
        index = 0,
        selected = null,
        correctCount = 0,
        finished = false;

  const QuizState.empty()
      : questions = const [],
        index = 0,
        selected = null,
        correctCount = 0,
        finished = true;

  bool get isEmpty => questions.isEmpty;
  QuizQuestion? get current =>
      questions.isEmpty ? null : questions[index];
  int get total => questions.length;

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? index,
    String? selected,
    bool clearSelected = false,
    int? correctCount,
    bool? finished,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      index: index ?? this.index,
      selected: clearSelected ? null : (selected ?? this.selected),
      correctCount: correctCount ?? this.correctCount,
      finished: finished ?? this.finished,
    );
  }

  @override
  List<Object?> get props =>
      [questions, index, selected, correctCount, finished];
}
