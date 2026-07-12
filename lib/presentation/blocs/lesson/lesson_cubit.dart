import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/lesson_model.dart';
import '../../../domain/repositories/lesson_repository.dart';

part 'lesson_state.dart';

/// Ders listesini yükler ve durumunu yönetir.
class LessonCubit extends Cubit<LessonState> {
  final LessonRepository _repository;

  LessonCubit(this._repository) : super(const LessonInitial());

  Future<void> loadLessons() async {
    emit(const LessonLoading());
    try {
      final lessons = await _repository.getLessons();
      emit(LessonLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
}
