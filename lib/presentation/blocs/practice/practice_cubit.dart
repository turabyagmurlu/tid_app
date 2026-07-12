import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'practice_state.dart';

/// Ayna modu alıştırma ekranının durumu: ayna açık/kapalı, oynatma hızı,
/// yakın çekim görünürlüğü ve mimik/el geri bildirimi.
///
/// GELECEK FAZ: Google MediaPipe Hand Landmark & Face Mesh sonuçları
/// [updateMimicFeedback] üzerinden bu duruma bağlanacaktır.
class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit() : super(const PracticeState());

  void toggleMirror() =>
      emit(state.copyWith(mirrorEnabled: !state.mirrorEnabled));

  void toggleCloseup() =>
      emit(state.copyWith(closeupVisible: !state.closeupVisible));

  void setSpeed(double speed) => emit(state.copyWith(playbackSpeed: speed));

  void updateMimicFeedback({HandFeedback? hand, FaceFeedback? face}) {
    emit(state.copyWith(
      handFeedback: hand ?? state.handFeedback,
      faceFeedback: face ?? state.faceFeedback,
    ));
  }
}
