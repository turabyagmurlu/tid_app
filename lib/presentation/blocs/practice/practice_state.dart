part of 'practice_cubit.dart';

/// El hareketi eşleşme durumu (MediaPipe Hand Landmark için hazır).
enum HandFeedback { idle, detecting, matched, mismatch }

/// Yüz/mimik eşleşme durumu (MediaPipe Face Mesh için hazır).
enum FaceFeedback { idle, detecting, matched, mismatch }

class PracticeState extends Equatable {
  final bool mirrorEnabled;
  final bool closeupVisible;
  final double playbackSpeed;
  final HandFeedback handFeedback;
  final FaceFeedback faceFeedback;

  const PracticeState({
    this.mirrorEnabled = true,
    this.closeupVisible = true,
    this.playbackSpeed = 1.0,
    this.handFeedback = HandFeedback.idle,
    this.faceFeedback = FaceFeedback.idle,
  });

  PracticeState copyWith({
    bool? mirrorEnabled,
    bool? closeupVisible,
    double? playbackSpeed,
    HandFeedback? handFeedback,
    FaceFeedback? faceFeedback,
  }) {
    return PracticeState(
      mirrorEnabled: mirrorEnabled ?? this.mirrorEnabled,
      closeupVisible: closeupVisible ?? this.closeupVisible,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      handFeedback: handFeedback ?? this.handFeedback,
      faceFeedback: faceFeedback ?? this.faceFeedback,
    );
  }

  @override
  List<Object?> get props =>
      [mirrorEnabled, closeupVisible, playbackSpeed, handFeedback, faceFeedback];
}
