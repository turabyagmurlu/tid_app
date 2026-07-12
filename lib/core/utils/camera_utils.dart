import 'package:camera/camera.dart';

/// Kamera ile ilgili yardımcılar.
class CameraUtils {
  CameraUtils._();

  /// Ön kamerayı döndürür; yoksa mevcut ilk kamerayı, o da yoksa null verir.
  static CameraDescription? frontCamera(List<CameraDescription> cameras) {
    if (cameras.isEmpty) return null;
    return cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
  }
}
