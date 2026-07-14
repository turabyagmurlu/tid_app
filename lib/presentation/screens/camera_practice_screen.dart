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
import 'hand_tracking_screen.dart';

/// Ayna Modu — ÜST: eğitmen referans videosu · ALT: kullanıcının ön kamerası.
/// İşareti izleyip aynı anda kendini aynada taklit edersin.
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
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.sm),
                child: _Labeled(
                  label: 'Referans',
                  color: AppColors.primary,
                  child: DualVideoPlayer(
                    key: ValueKey(
                        'practice_${widget.word.wordId}_${widget.variant.region}'),
                    fullBodyUrl: widget.variant.videoFullBody,
                    lipCloseupUrl: widget.variant.videoLipCloseups,
                  ),
                ),
              ),
            ),

            // ALT: Kullanıcının ön kamerası (ayna)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppDimensions.sm, 0,
                    AppDimensions.sm, AppDimensions.sm),
                child: BlocBuilder<PracticeCubit, PracticeState>(
                  builder: (context, s) {
                    return _Labeled(
                      label: 'Sen (ayna)',
                      color: const Color(0xFF06B6D4),
                      child: _cameraError != null
                          ? _CamError(message: _cameraError!)
                          : _loadingCameras
                              ? const ColoredBox(
                                  color: Colors.black,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : MirrorCameraPreview(
                                  camera: front, mirror: s.mirrorEnabled),
                    );
                  },
                ),
              ),
            ),

            // Alt ipucu + gerçek el takibine kısayol
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.md, 0,
                  AppDimensions.md, AppDimensions.sm),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'İşareti izle, aynı anda kendini aynada taklit et.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.back_hand, size: 18),
                    label: const Text('El Takibi'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HandTrackingScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bir çocuğu köşe etiketiyle saran kutu.
class _Labeled extends StatelessWidget {
  final String label;
  final Color color;
  final Widget child;
  const _Labeled(
      {required this.label, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Colors.black, child: Center(child: child)),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CamError extends StatelessWidget {
  final String message;
  const _CamError({required this.message});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off, color: Colors.white70, size: 40),
              const SizedBox(height: AppDimensions.sm),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
