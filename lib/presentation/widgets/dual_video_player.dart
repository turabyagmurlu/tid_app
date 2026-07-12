import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/video_utils.dart';

/// Çift açılı eğitmen videosu (Bölüm 4 — Görsel Odaklı Arayüz):
///  - Ana çerçeve: genel beden çekimi
///  - Sağ üst PIP: dudak okuma yakın çekimi
/// Hız (0.5x/0.75x/1.0x) ve döngü (loop) desteği ile.
class DualVideoPlayer extends StatefulWidget {
  final String fullBodyUrl;
  final String lipCloseupUrl;
  final bool autoPlay;

  const DualVideoPlayer({
    super.key,
    required this.fullBodyUrl,
    required this.lipCloseupUrl,
    this.autoPlay = true,
  });

  @override
  State<DualVideoPlayer> createState() => _DualVideoPlayerState();
}

class _DualVideoPlayerState extends State<DualVideoPlayer> {
  VideoPlayerController? _main;
  VideoPlayerController? _closeup;
  double _speed = 1.0;
  bool _closeupVisible = true;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final main = VideoPlayerController.networkUrl(Uri.parse(widget.fullBodyUrl));
    final closeup =
        VideoPlayerController.networkUrl(Uri.parse(widget.lipCloseupUrl));
    _main = main;
    _closeup = closeup;
    try {
      await Future.wait([main.initialize(), closeup.initialize()]);
      main
        ..setLooping(true)
        ..setVolume(0);
      closeup
        ..setLooping(true)
        ..setVolume(0);
      if (widget.autoPlay) {
        await main.play();
        await closeup.play();
      }
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _applySpeed(double s) {
    setState(() => _speed = s);
    _main?.setPlaybackSpeed(s);
    _closeup?.setPlaybackSpeed(s);
  }

  @override
  void dispose() {
    _main?.dispose();
    _closeup?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: (_ready && _main!.value.aspectRatio > 0)
              ? _main!.value.aspectRatio
              : 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black,
                    child: _buildMain(),
                  ),
                ),
                if (_closeupVisible && !_failed)
                  Positioned(
                    top: AppDimensions.sm,
                    right: AppDimensions.sm,
                    child: _CloseupBox(controller: _ready ? _closeup : null),
                  ),
                Positioned(
                  top: AppDimensions.sm,
                  left: AppDimensions.sm,
                  child: _RoundIconButton(
                    icon: _closeupVisible
                        ? Icons.picture_in_picture
                        : Icons.picture_in_picture_alt_outlined,
                    tooltip: _closeupVisible
                        ? 'Yakın çekimi gizle'
                        : 'Yakın çekimi göster',
                    onTap: () =>
                        setState(() => _closeupVisible = !_closeupVisible),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        _SpeedBar(current: _speed, onChanged: _applySpeed),
      ],
    );
  }

  Widget _buildMain() {
    if (_failed) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.md),
          child: Text(
            'Video yüklenemedi. Bağlantıyı kontrol edin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
    if (!_ready) return const Center(child: CircularProgressIndicator());
    return VideoPlayer(_main!);
  }
}

class _CloseupBox extends StatelessWidget {
  final VideoPlayerController? controller;
  const _CloseupBox({this.controller});

  @override
  Widget build(BuildContext context) {
    final ready = controller != null && controller!.value.isInitialized;
    return Container(
      width: AppDimensions.closeupWidth,
      height: AppDimensions.closeupHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        color: Colors.black54,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm - 2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (ready)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller!.value.size.width,
                  height: controller!.value.size.height,
                  child: VideoPlayer(controller!),
                ),
              )
            else
              const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: const Text(
                  AppStrings.lipFocus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}

class _SpeedBar extends StatelessWidget {
  final double current;
  final ValueChanged<double> onChanged;
  const _SpeedBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.speed, size: 20),
        const SizedBox(width: AppDimensions.sm),
        for (final s in VideoUtils.playbackSpeeds)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text('${s}x'),
              selected: current == s,
              onSelected: (_) => onChanged(s),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: current == s ? Colors.white : null,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
