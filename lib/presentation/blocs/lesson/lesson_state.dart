part of 'lesson_cubit.dart';

/// Sealed hiyerarşi — home ekranında exhaustive switch ile kullanılır.
sealed class LessonState extends Equatable {
  const LessonState();

  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {
  const LessonInitial();
}

class LessonLoading extends LessonState {
  const LessonLoading();
}

class LessonLoaded extends LessonState {
  final List<LessonModel> lessons;
  const LessonLoaded(this.lessons);

  /// Dersleri modüle göre gruplar (home ekranındaki bölümlemeler için).
  Map<String, List<LessonModel>> get byModule {
    final map = <String, List<LessonModel>>{};
    for (final lesson in lessons) {
      map.putIfAbsent(lesson.module, () => <LessonModel>[]).add(lesson);
    }
    return map;
  }

  @override
  List<Object?> get props => [lessons];
}

class LessonError extends LessonState {
  final String message;
  const LessonError(this.message);

  @override
  List<Object?> get props => [message];
}
