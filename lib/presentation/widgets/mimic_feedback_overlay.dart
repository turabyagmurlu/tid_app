import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../blocs/practice/practice_cubit.dart';

/// Kamera görüntüsü üzerine binen geri bildirim katmanı (Bölüm 4 — Mimik Kontrolü).
///
/// GELECEK FAZ: MediaPipe Hand Landmark & Face Mesh sonuçlarıyla beslenir.
/// Şu an el/yüz için hedef kutuları (guide) ve durum rozetleri gösterir.
/// [IgnorePointer] ile altındaki kamera etkileşimini engellemez.
class MimicFeedbackOverlay extends StatelessWidget {
  final HandFeedback hand;
  final FaceFeedback face;
  final bool facialExpressionRequired;

  const MimicFeedbackOverlay({
    super.key,
    required this.hand,
    required this.face,
    required this.facialExpressionRequired,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // El bölgesi hedef kutusu
          Positioned(
            left: 24,
            right: 24,
            top: 96,
            bottom: 56,
            child: _GuideBox(
              color: AppColors.handBox,
              label: 'El Bölgesi',
              status: _statusLabel(hand.index),
              active: hand == HandFeedback.matched,
            ),
          ),
          // Yüz/mimik hedef kutusu — yalnızca mimik gerekliyse
          if (facialExpressionRequired)
            Positioned(
              left: 90,
              right: 90,
              top: 16,
              height: 72,
              child: _GuideBox(
                color: AppColors.faceBox,
                label: 'Mimik',
                status: _statusLabel(face.index),
                active: face == FaceFeedback.matched,
              ),
            ),
          // Alt bilgi şeridi
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StatusStrip(facial: facialExpressionRequired),
          ),
        ],
      ),
    );
  }

  /// 0:idle 1:detecting 2:matched 3:mismatch (HandFeedback/FaceFeedback ortak).
  String _statusLabel(int index) {
    switch (index) {
      case 1:
        return 'Algılanıyor...';
      case 2:
        return 'Doğru ✓';
      case 3:
        return 'Düzelt';
      default:
        return 'Bekleniyor';
    }
  }
}

class _GuideBox extends StatelessWidget {
  final Color color;
  final String label;
  final String status;
  final bool active;

  const _GuideBox({
    required this.color,
    required this.label,
    required this.status,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: active ? 4 : 2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        color: active ? color.withOpacity(0.12) : Colors.transparent,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$label · $status',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final bool facial;
  const _StatusStrip({required this.facial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      color: Colors.black54,
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white70, size: 18),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              facial
                  ? 'Elini ve yüz ifadeni kutulara hizala — bu işaret mimik gerektirir.'
                  : 'Elini mavi kutuya hizala ve eğitmeni taklit et.',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
