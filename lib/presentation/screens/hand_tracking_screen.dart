import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';

/// Deneysel: MediaPipe Hands ile kamera üzerinde canlı el (parmak) takibi.
/// Tüm takip mantığı web/hand_tracking.html içinde çalışır; burada iframe ile
/// gömülür (yalnızca web).
class HandTrackingScreen extends StatelessWidget {
  const HandTrackingScreen({super.key});

  static bool _registered = false;
  static const String _viewType = 'tid-hand-tracking-iframe';

  void _ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'hand_tracking.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..setAttribute('allow', 'camera');
      return iframe;
    });
    _registered = true;
  }

  @override
  Widget build(BuildContext context) {
    _ensureRegistered();
    return Scaffold(
      appBar: AppBar(title: const Text('El Takibi (Deneysel)')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppDimensions.md),
            child: Text(
              'Kameranı aç ve elini göster. Parmak eklemlerin canlı olarak '
              'işaretlenir; aynada işareti yaparken el şeklini kontrol edebilirsin. '
              'Bu özellik deneyseldir ve kamera izni gerektirir.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const Expanded(
            child: HtmlElementView(viewType: _viewType),
          ),
        ],
      ),
    );
  }
}
