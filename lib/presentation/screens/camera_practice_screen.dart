import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/camera_utils.dart';
import '../../data/models/regional_variant_model.dart';
import '../../data/models/word_model.dart';
import '../blocs/practice/practice_cubit.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/dual_video_player.dart';
import '../widgets/mimic_feedback_overlay.dart';

/// Ayna Modu (Split-Screen) alıştırma ekranı — Bölüm 4/6-A.
/// ÜST: eğitmen referans videosu · ALT: kullanıcının canlı ön kamerası + overlay.
class CameraPracticeScreen extends StatelessWidget {
  final WordModel word;
  final RegionalVariant variant;

  const CameraPracticeScreen({
    super.key,
    required this.word,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PracticeCubit(),
      child: _PracticeView(word: word, variant: variant),
    );
  }
}

class _PracticeView extends StatefulWidget {
  final WordModel word;
  final RegionalVariant variant;
  const _PracticeView({required this.word, required this.variant});

  @override
  State<_PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<_PracticeView> {
  List<CameraDescription> _cameras = const [];
  bool _loadingCameras = true;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      final cams = await availableCameras();
      if (mounted) {
        setState(() {
          _cameras = cams;
          _loadingCameras = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = 'Kameralara erişilemedi: $e';
          _loadingCameras = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final front = CameraUtils.frontCamera(_cameras);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.word.turkishWord} · ${AppStrings.mirrorMode}'),
        actions: [
          BlocBuilder<PracticeCubit, PracticeState>(
            builder: (context, s) => IconButton(
              tooltip: s.mirrorEnabled ? 'Aynayı kapat' : 'Aynayı aç',
              icon: Icon(s.mirrorEnabled ? Icons.flip : Icons.flip_outlined),
              onPressed: () => context.read<PracticeCubit>().toggleMirror(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ÜST: Eğitmen referans videosu
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: DualVideoPlayer(
                  key: ValueKey(
                      'practice_${widget.word.wordId}_${widget.variant.region}'),
                  fullBodyUrl: widget.variant.videoFullBody,
                  lipCloseupUrl: widget.variant.videoLipCloseups,
                ),
              ),
            ),

            // ALT: Ayna modu + mimik geri bildirim katmanı
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: BlocBuilder<PracticeCubit, PracticeState>(
                  builder: (context, s) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: _loadingCameras
                              ? const Center(child: CircularProgressIndicator())
                              : MirrorCameraPreview(
                                  camera: front, mirror: s.mirrorEnabled),
                        ),
                        if (_cameraError == null && !_loadingCameras)
                          Positioned.fill(
                            child: MimicFeedbackOverlay(
                              hand: s.handFeedback,
                              face: s.faceFeedback,
                              facialExpressionRequired:
                                  widget.word.facialExpressionRequired,
                            ),
                          ),
                        if (_cameraError != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppDimensions.md),
                              child: Text(
                                _cameraError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // GEÇİCİ: MediaPipe entegrasyonu gelene kadar overlay durumlarını
            // göstermek için manuel demo düğmeleri. Üretimde kaldırılacak.
            const _DemoFeedbackBar(),
          ],
        ),
      ),
    );
  }
}

class _DemoFeedbackBar extends StatelessWidget {
  const _DemoFeedbackBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () => context.read<PracticeCubit>().updateMimicFeedback(
                  hand: HandFeedback.detecting,
                  face: FaceFeedback.detecting,
                ),
            icon: const Icon(Icons.sensors),
            label: const Text('Algıla'),
          ),
          TextButton.icon(
            onPressed: () => context.read<PracticeCubit>().updateMimicFeedback(
                  hand: HandFeedback.matched,
                  face: FaceFeedback.matched,
                ),
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            label: const Text('Eşleşti'),
          ),
          TextButton.icon(
            onPressed: () => context.read<PracticeCubit>().updateMimicFeedback(
                  hand: HandFeedback.mismatch,
                  face: FaceFeedback.mismatch,
                ),
            icon: const Icon(Icons.error, color: AppColors.error),
            label: const Text('Hatalı'),
          ),
        ],
      ),
    );
  }
}
