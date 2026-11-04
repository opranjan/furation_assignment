import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'zodiac_timer_config.dart';
import '../../../../../core/theme/app_colors.dart';

/// Horizontal unit labels — each sits on its ring mid-radius (no angled arc).
class ZodiacTimerLabels extends StatelessWidget {
  const ZodiacTimerLabels({
    super.key,
    required this.config,
    required this.chordY,
  });

  final ZodiacTimerConfig config;

  /// Shared horizontal Y for all labels (same space as [config.center]).
  final double chordY;

  static const _style = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1,
    shadows: [
      Shadow(color: AppColors.labelHalo, blurRadius: 6),
      Shadow(color: AppColors.white, blurRadius: 2),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final cx = config.center.dx;
    final dy = chordY - config.center.dy;
    final scaler = MediaQuery.textScalerOf(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var i = 0; i < ZodiacTimerConfig.ringCount; i++)
          _label(i, cx, dy, scaler),
      ],
    );
  }

  Widget _label(int i, double cx, double dy, TextScaler scaler) {
    final r = config.midRadius(i);
    if (dy.abs() >= r - 1) return const SizedBox.shrink();

    // Left intersection of this ring with the horizontal chord
    final x = cx - math.sqrt(r * r - dy * dy);
    final label = ZodiacTimerConfig.labels[i];

    final painter = TextPainter(
      text: TextSpan(text: label, style: _style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();

    return Positioned(
      left: x - painter.width / 2,
      top: chordY - painter.height / 2,
      child: Text(label, style: _style, textScaler: scaler),
    );
  }
}
