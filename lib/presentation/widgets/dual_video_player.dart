import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/video_utils.dart';

/// Gerçek işaret videosu oynatıcı:
///  - Ana video (varsa ikinci açı PIP olarak)
///  - AYNA (yatay çevir) düğmesi — taklit ederken kolaylık sağlar
///  - Hız: 0.5x / 0.75x / 1.0x (yavaşlatmalı çalışma)
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
  bool _mirror = false;
  bool _closeupVisible = true;
  bool _ready = false;
  bool _failed = false;

  bool get _hasCloseup =>
      widget.lipCloseupUrl.trim().isNotEmpty &&
      widget.lipCloseupUrl != widget.fullBodyUrl;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final main = VideoPlayerController.networkUrl(Uri.parse(widget.fullBodyUrl));
    _main = main;
    try {
      await main.initialize();
      main
        ..setLooping(true)
        ..setVolume(0);
      if (_hasCloseup) {
        final cu =
            VideoPlayerController.networkUrl(Uri.parse(widget.lipCloseupUrl));
        _closeup = cu;
        await cu.initialize();
        cu
          ..setLooping(true)
          ..setVolume(0);
      }
      if (widget.autoPlay) {
        await main.play();
        await _closeup?.play();
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
                  child: ColoredBox(color: Colors.black, child: _buildMain()),
                ),
                if (_hasCloseup && _closeupVisible && !_failed)
                  Positioned(
                    top: AppDimensions.sm,
                    right: AppDimensions.sm,
                    child: _CloseupBox(controller: _ready ? _closeup : null),
                  ),
                if (_mirror && !_failed)
                  const Positioned(top: 8, left: 8, child: _MirrorBadge()),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        _ControlBar(
          current: _speed,
          onSpeed: _applySpeed,
          mirror: _mirror,
          onMirror: () => setState(() => _mirror = !_mirror),
          hasCloseup: _hasCloseup,
          closeupVisible: _closeupVisible,
          onToggleCloseup: () =>
              setState(() => _closeupVisible = !_closeupVisible),
        ),
      ],
    );
  }

  Widget _buildMain() {
    if (_failed) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.md),
          child: Text('Video yüklenemedi. Bağlantıyı kontrol edin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }
    if (!_ready) return const Center(child: CircularProgressIndicator());
    Widget vp = VideoPlayer(_main!);
    if (_mirror) {
      vp = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        child: vp,
      );
    }
    return vp;
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
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: const Text('2. Açı',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MirrorBadge extends StatelessWidget {
  const _MirrorBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(6)),
      child: const Text('Ayna açık',
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _ControlBar extends StatelessWidget {
  final double current;
  final ValueChanged<double> onSpeed;
  final bool mirror;
  final VoidCallback onMirror;
  final bool hasCloseup;
  final bool closeupVisible;
  final VoidCallback onToggleCloseup;

  const _ControlBar({
    required this.current,
    required this.onSpeed,
    required this.mirror,
    required this.onMirror,
    required this.hasCloseup,
    required this.closeupVisible,
    required this.onToggleCloseup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.speed, size: 20),
            for (final s in VideoUtils.playbackSpeeds)
              ChoiceChip(
                label: Text('${s}x'),
                selected: current == s,
                onSelected: (_) => onSpeed(s),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: current == s ? Colors.white : null,
                    fontWeight: FontWeight.w700),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            FilterChip(
              avatar: Icon(Icons.flip,
                  size: 18, color: mirror ? Colors.white : null),
              label: const Text('Ayna'),
              selected: mirror,
              onSelected: (_) => onMirror(),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                  color: mirror ? Colors.white : null,
                  fontWeight: FontWeight.w600),
            ),
            if (hasCloseup)
              FilterChip(
                avatar: const Icon(Icons.switch_video, size: 18),
                label: Text(closeupVisible ? '2. açı: açık' : '2. açı: kapalı'),
                selected: closeupVisible,
                onSelected: (_) => onToggleCloseup(),
              ),
          ],
        ),
      ],
    );
  }
}
