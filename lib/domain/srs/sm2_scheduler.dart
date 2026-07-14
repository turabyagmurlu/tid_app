import '../../data/models/srs_card_model.dart';

/// SuperMemo SM-2 algoritması (sadeleştirilmiş).
/// quality: 0..5 (0-2 = hatırlamadı, 3-5 = hatırladı).
class Sm2Scheduler {
  static SrsCard review(SrsCard card, int quality, DateTime now) {
    quality = quality.clamp(0, 5);

    int reps;
    int interval;
    if (quality < 3) {
      // Hatırlanmadı: baştan.
      reps = 0;
      interval = 1;
    } else {
      reps = card.repetitions + 1;
      if (reps == 1) {
        interval = 1;
      } else if (reps == 2) {
        interval = 6;
      } else {
        interval = (card.intervalDays * card.easiness).round();
      }
    }

    // EF güncellemesi.
    double ef = card.easiness +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (ef < 1.3) ef = 1.3;

    final due = DateTime(now.year, now.month, now.day)
        .add(Duration(days: interval < 1 ? 1 : interval));

    return card.copyWith(
      easiness: ef,
      repetitions: reps,
      intervalDays: interval,
      dueDate: due,
    );
  }
}
