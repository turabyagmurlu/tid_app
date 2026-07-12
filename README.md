# 🤟 TİD Öğren — Türk İşaret Dili Öğrenme Uygulaması (Flutter)

Bölüm 7'deki şartnameye göre üretilmiş, **derlenebilir Flutter iskeleti**.
Clean Architecture + `flutter_bloc` (Cubit) + Firebase (Firestore/Storage),
yerel seed verisiyle **kutudan çıkar çıkmaz çalışır**.

## ✨ Öne çıkanlar
- **Çift açılı video oynatıcı** (`DualVideoPlayer`): genel beden + dudak yakın çekim (PIP), `0.5x/0.75x/1.0x` hız, döngü.
- **Ayna Modu (Split-Screen)**: eğitmen videosu üstte, kullanıcının ön kamerası altta (yatay çevrilmiş).
- **Mimik/El geri bildirim katmanı** (`MimicFeedbackOverlay`): MediaPipe Hand Landmark & Face Mesh için hazır overlay kutuları.
- **TİD Gramer Quiz'i** (`GrammarQuizWidget`): Özne-Nesne-Yüklem sıralama alıştırması.
- **Bölgesel varyantlar** (İstanbul/Ankara) her işaret için seçilebilir.
- **Oyunlaştırma**: günlük seri (streak), XP, tamamlanan ders takibi.
- **Erişilebilirlik**: yüksek kontrast tema, ≥48dp dokunma hedefleri, semantik etiketler, açık/koyu tema.

## 🗂️ Mimari
```
lib/
├── core/            # constants (renk/boyut/metin), theme, utils (kamera/video)
├── data/            # models, datasources (Firestore + yerel seed), repositories
├── domain/          # repository arayüzleri
├── presentation/    # blocs (Cubit), screens, widgets
├── firebase_options.dart  # ŞABLON — flutterfire ile değiştirin
└── main.dart
```
Veri akışı: `LessonRepositoryImpl` önce **Firestore**'u dener, hata/boş olursa
`assets/seed/lessons_seed.json`'a düşer. Böylece Firebase yapılandırılmadan da çalışır.

## 🚀 Çalıştırma
Bu paket yalnızca kaynak dosyaları içerir; platform klasörleri (`android/`, `ios/`) yoktur.

```bash
# 1) Projeyi aç
cd tid_app

# 2) Platform iskeletini üret (mevcut lib/ ve pubspec korunur)
flutter create .

# 3) Bağımlılıkları çek
flutter pub get

# 4) Çalıştır (yerel seed verisiyle hemen açılır)
flutter run
```

## 🔥 Firebase (opsiyonel ama tercih edilen)
```bash
dart pub global activate flutterfire_cli
flutterfire configure          # lib/firebase_options.dart otomatik üretilir
```
Firestore'da `lessons` koleksiyonu oluşturun; her belge **Bölüm 5 şeması** ile aynı olmalı.
Belge kimliği = `lesson_id`. `assets/seed/lessons_seed.json` dosyasını referans veri olarak içe aktarabilirsiniz.
Videoları **Firebase Storage**'a yükleyip indirme URL'lerini `video_full_body` / `video_lip_closeups` alanlarına yazın.

> ⚠️ Örnek `firebase_options.dart` yer tutucudur. `main.dart`, başlatma başarısız olursa
> otomatik olarak yerel seed verisine düşer — uygulama yine de açılır.

## 📷 Kamera izinleri (`flutter create .` sonrası ekleyin)
**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```
`android/app/build.gradle` → `minSdkVersion 21` (camera eklentisi için).

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Ayna modunda işaretlerinizi eğitmenle karşılaştırmak için kamera gereklidir.</string>
```

## 🧠 MediaPipe yol haritası (Gelecek Faz)
Overlay ve durum yönetimi hazır. Entegrasyon için:
1. `google_mediapipe_*` / platform kanalı ile Hand Landmark + Face Mesh akışını bağlayın.
2. Sonuçları `PracticeCubit.updateMimicFeedback(hand:, face:)` ile besleyin.
3. `MimicFeedbackOverlay` kutuları otomatik olarak `matched/mismatch` durumuna geçer.
`camera_practice_screen.dart` içindeki `_DemoFeedbackBar` yalnızca demo amaçlıdır; üretimde kaldırın.

## ♿ Erişilebilirlik notları
- Renkler WCAG AA kontrastı gözetilerek seçildi (`AppColors`).
- Tüm etkileşimli öğeler ≥48dp; ikonlarda `semanticLabel`/`tooltip`.
- Videolar sessiz + döngülü; dudak okuma için ayrı yakın çekim.
- Sağır kültürü etiği (göz teması, ışık, dokunma) Modül 4 içeriğinde ele alınır.

## 📦 Bağımlılıklar
`flutter_bloc`, `equatable`, `firebase_core`, `cloud_firestore`, `firebase_storage`,
`video_player`, `camera`, `intl`. Sürümler `pubspec.yaml` içinde; `flutter pub get`
çözemezse `flutter pub upgrade --major-versions` çalıştırın.

## ⚠️ Bilinen sınırlamalar
- Örnek video URL'leri geçici (Flutter demo klipleri); gerçek TİD çekimleriyle değiştirin.
- Kimlik doğrulama (Auth) ve ilerleme kalıcılığı (Firestore'a yazma) TODO olarak işaretlendi.
- Testler bu iskelete dahil edilmedi (kapsam tercihi: "Tam çalışır iskelet").
