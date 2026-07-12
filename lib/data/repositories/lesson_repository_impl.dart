import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_datasource.dart';
import '../models/lesson_model.dart';

/// Önce uzak kaynağı (Firestore) dener; boş dönerse ya da hata olursa
/// yerel seed verisine düşer. Böylece uygulama Firebase yapılandırılmadan da
/// çalışır ve çevrimdışı dayanıklılık sağlar.
class LessonRepositoryImpl implements LessonRepository {
  final LessonDataSource? remote;
  final LessonDataSource local;

  LessonRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<LessonModel>> getLessons() async {
    if (remote != null) {
      try {
        final lessons = await remote!.fetchLessons();
        if (lessons.isNotEmpty) return lessons;
      } catch (_) {
        // Sessizce yerel kaynağa düş.
      }
    }
    return local.fetchLessons();
  }

  @override
  Future<LessonModel?> getLessonById(String lessonId) async {
    if (remote != null) {
      try {
        final lesson = await remote!.fetchLessonById(lessonId);
        if (lesson != null) return lesson;
      } catch (_) {
        // Sessizce yerel kaynağa düş.
      }
    }
    return local.fetchLessonById(lessonId);
  }
}
