import '../../data/models/lesson_model.dart';

/// İş mantığı arayüzü. Sunum katmanı yalnızca bu sözleşmeye bağımlıdır.
abstract class LessonRepository {
  Future<List<LessonModel>> getLessons();
  Future<LessonModel?> getLessonById(String lessonId);
}
