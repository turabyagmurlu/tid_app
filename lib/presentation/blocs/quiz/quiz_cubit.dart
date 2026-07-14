import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/lesson_model.dart';
import '../../../data/models/quiz_question_model.dart';
import '../../../data/models/word_model.dart';
import '../../../domain/quiz/quiz_generator.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(const QuizState.initial());

  void start(LessonModel lesson, {List<WordModel> extraPool = const []}) {
    final questions = QuizGenerator.generate(lesson, extraPool: extraPool);
    if (questions.isEmpty) {
      emit(const QuizState.empty());
      return;
    }
    emit(QuizState(
      questions: questions,
      index: 0,
      selected: null,
      correctCount: 0,
      finished: false,
    ));
  }

  void answer(String option) {
    if (state.selected != null || state.finished || state.questions.isEmpty) {
      return;
    }
    final q = state.questions[state.index];
    final isCorrect = option == q.correct;
    emit(state.copyWith(
      selected: option,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
    ));
  }

  void next() {
    if (state.selected == null) return;
    if (state.index + 1 >= state.questions.length) {
      emit(state.copyWith(finished: true));
    } else {
      emit(state.copyWith(index: state.index + 1, clearSelected: true));
    }
  }
}
