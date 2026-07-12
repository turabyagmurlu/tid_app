import '../models/lesson_model.dart';

/// Ders verisi kaynağı sözleşmesi. Uzak (Firestore) ve yerel (seed) kaynaklar
/// bu arayüzü uygular; böylece repository kaynaktan bağımsız çalışır.
abstract class LessonDataSource {
  Future<List<LessonModel>> fetchLessons();
  Future<LessonModel?> fetchLessonById(String lessonId);
}
