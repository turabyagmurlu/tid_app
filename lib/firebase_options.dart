// ŞABLON DOSYA — GERÇEK DEĞİLDİR.
//
// Bu dosya, proje derlenebilsin diye yer tutucu değerlerle üretilmiştir.
// Gerçek Firebase yapılandırması için:
//   1) dart pub global activate flutterfire_cli
//   2) flutterfire configure --project=<firebase-proje-id>
// komutlarını çalıştırın; bu dosya otomatik olarak gerçek değerlerle değiştirilecektir.
//
// Uygulama, geçerli yapılandırma bulunmazsa çöker DEĞİL; main.dart Firebase
// başlatmayı try/catch ile sarar ve yerel seed verisine düşer.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Bu platform için Firebase yapılandırması yok. `flutterfire configure` çalıştırın.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
    authDomain: 'REPLACE_ME',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
    iosBundleId: 'com.example.tidApp',
  );
}
