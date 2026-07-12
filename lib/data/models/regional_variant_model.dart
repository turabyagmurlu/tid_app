import 'package:equatable/equatable.dart';

/// Bir işaretin bölgesel gösterimi (Örn: "İstanbul Standardı" / "Ankara Varyantı").
/// Her varyant, iki açıdan video taşır: genel beden çekimi + dudak yakın çekimi.
class RegionalVariant extends Equatable {
  final String region;
  final String videoFullBody; // Genel beden çekimi (mp4 URL — Firebase Storage/CDN)
  final String videoLipCloseups; // Dudak okuma yakın çekimi (mp4 URL)

  const RegionalVariant({
    required this.region,
    required this.videoFullBody,
    required this.videoLipCloseups,
  });

  factory RegionalVariant.fromMap(Map<String, dynamic> map) {
    return RegionalVariant(
      region: (map['region'] ?? '') as String,
      videoFullBody: (map['video_full_body'] ?? '') as String,
      videoLipCloseups: (map['video_lip_closeups'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'region': region,
        'video_full_body': videoFullBody,
        'video_lip_closeups': videoLipCloseups,
      };

  @override
  List<Object?> get props => [region, videoFullBody, videoLipCloseups];
}
