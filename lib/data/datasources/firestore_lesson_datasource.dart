import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lesson_model.dart';
import 'lesson_datasource.dart';

/// Firestore 'lessons' koleksiyonundan ders verisini çeker.
/// Beklenen belge yapısı, Bölüm 5'teki JSON şemasıyla birebir aynıdır.
///
/// Belge kimliği (doc.id) lesson_id olarak kullanılır; belge içinde ayrıca
/// lesson_id alanı olması gerekmez (varsa doc.id ile ezilir).
class FirestoreLessonDataSource implements LessonDataSource {
  final FirebaseFirestore _db;

  FirestoreLessonDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'lessons';

  @override
  Future<List<LessonModel>> fetchLessons() async {
    final snapshot = await _db.collection(_collection).get();
    final lessons = snapshot.docs
        .map((doc) => LessonModel.fromMap({...doc.data(), 'lesson_id': doc.id}))
        .toList();
    // Seviyeye göre sırala (A1, A2, B1, ...)
    lessons.sort((a, b) => a.level.compareTo(b.level));
    return lessons;
  }

  @override
  Future<LessonModel?> fetchLessonById(String lessonId) async {
    final doc = await _db.collection(_collection).doc(lessonId).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return LessonModel.fromMap({...data, 'lesson_id': doc.id});
  }
}
