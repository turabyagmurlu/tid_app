import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';

/// Kullanıcının ön kamerasını (Ayna Modu) gösterir.
/// [mirror] açıkken görüntü yatay çevrilir; kullanıcı kendini aynadaki gibi görür.
class MirrorCameraPreview extends StatefulWidget {
  final CameraDescription? camera;
  final bool mirror;

  const MirrorCameraPreview({
    super.key,
    required this.camera,
    this.mirror = true,
  });

  @override
  State<MirrorCameraPreview> createState() => _MirrorCameraPreviewState();
}

class _MirrorCameraPreviewState extends State<MirrorCameraPreview> {
  CameraController? _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cam = widget.camera;
    if (cam == null) {
      setState(() => _error = 'Kamera bulunamadı.');
      return;
    }
    final controller = CameraController(
      cam,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _controller = controller;
    try {
      await controller.initialize();
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (mounted) setState(() => _error = 'Kamera açılamadı: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_error != null) {
      child = _Placeholder(icon: Icons.videocam_off, text: _error!);
    } else if (!_ready || _controller == null) {
      child = const Center(child: CircularProgressIndicator());
    } else {
      final size = _controller!.value.previewSize ?? const Size(640, 480);
      // Alanı doldur (cover): siyah boşluk bırakmadan tüm kutuyu kapla.
      child = FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Transform(
            alignment: Alignment.center,
            transform: widget.mirror
                ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
                : Matrix4.identity(),
            child: CameraPreview(_controller!),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Placeholder({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 40),
          const SizedBox(height: AppDimensions.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
