/// Uygulama metinleri (TR). İleride l10n/intl'e taşınabilir.
class AppStrings {
  AppStrings._();

  static const String appName = 'TİD Öğren';
  static const String homeTitle = 'Türk İşaret Dili';
  static const String modulesTitle = 'Modüller';

  // Modüller (Bölüm 2 müfredatı)
  static const String module1 = 'Modül 1: Başlangıç & Temeller (A1)';
  static const String module2 = 'Modül 2: Günlük Yaşam & Çevre (A2)';
  static const String module3 = 'Modül 3: Gramer, Fiiller & Cümle (B1-B2)';
  static const String module4 = 'Modül 4: İleri Seviye & Kültür (C1-C2)';

  // Genel
  static const String loading = 'Yükleniyor...';
  static const String retry = 'Tekrar Dene';
  static const String errorGeneric = 'Bir hata oluştu.';
  static const String clear = 'Temizle';

  // Video oynatıcı
  static const String lipFocus = 'Dudak Odaklı';
  static const String mirrorMode = 'Ayna Modu';
  static const String practiceInMirror = 'Ayna Modunda Alıştır';

  // Quiz
  static const String quizTitle = 'Gramer Alıştırması';
  static const String quizPrompt =
      'Kelimeleri TİD gramer yapısına (Özne-Nesne-Yüklem) uygun sıralayın:';
  static const String check = 'Kontrol Et';
  static const String correctOrder = 'Tebrikler! Doğru TİD dizilimi.';
  static const String wrongOrder = 'Hatalı sıralama, tekrar deneyin.';
  static const String emptyAnswerHint = 'Kelimeleri buraya sırayla ekleyin';

  // Streak / gamification
  static const String dailyGoal = 'Günde 10-15 dk tekrar yapmayı unutma!';

  // Mimik
  static const String facialRequired = 'Mimik gerektirir';
  static const String mnemonicTitle = 'Hatırlatıcı İpucu';
}
