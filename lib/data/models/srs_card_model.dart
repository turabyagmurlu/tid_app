/// Aralıklı tekrar (SRS) kartı — bir kelimenin SM-2 zamanlama durumu.
class SrsCard {
  final String wordId;
  final double easiness; // EF, başlangıç 2.5, min 1.3
  final int repetitions; // ardışık doğru sayısı
  final int intervalDays;
  final DateTime dueDate;

  const SrsCard({
    required this.wordId,
    this.easiness = 2.5,
    this.repetitions = 0,
    this.intervalDays = 0,
    required this.dueDate,
  });

  factory SrsCard.fresh(String wordId, DateTime now) =>
      SrsCard(wordId: wordId, dueDate: now);

  SrsCard copyWith({
    double? easiness,
    int? repetitions,
    int? intervalDays,
    DateTime? dueDate,
  }) {
    return SrsCard(
      wordId: wordId,
      easiness: easiness ?? this.easiness,
      repetitions: repetitions ?? this.repetitions,
      intervalDays: intervalDays ?? this.intervalDays,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  factory SrsCard.fromMap(Map<String, dynamic> m) => SrsCard(
        wordId: m['word_id'] as String,
        easiness: (m['ef'] as num?)?.toDouble() ?? 2.5,
        repetitions: (m['rep'] ?? 0) as int,
        intervalDays: (m['interval'] ?? 0) as int,
        dueDate: DateTime.tryParse(m['due'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'word_id': wordId,
        'ef': easiness,
        'rep': repetitions,
        'interval': intervalDays,
        'due': dueDate.toIso8601String(),
      };
}
