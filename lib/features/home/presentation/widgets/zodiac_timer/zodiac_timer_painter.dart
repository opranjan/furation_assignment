import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'zodiac_timer_config.dart';
import '../../../../../core/theme/app_colors.dart';

/// Draws six concentric zodiac timer rings and tangential numbers only.
class ZodiacTimerPainter extends CustomPainter {
  ZodiacTimerPainter({
    required this.config,
    required this.angles,
    required this.values,
  });

  final ZodiacTimerConfig config;
  final List<double> angles;
  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final center = config.center;
    final edges = config.edges;

    // Soft ambient shadow
    canvas.drawCircle(
      center.translate(3, 5),
      edges.first,
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
        ..color = AppColors.black.withValues(alpha: 0.22),
    );

    for (var i = 0; i < ZodiacTimerConfig.ringCount; i++) {
      final outer = edges[i];
      final inner = edges[i + 1];
      final spec = ZodiacTimerConfig.rings[i];
      final isSec = i == ZodiacTimerConfig.ringCount - 1;

      if (isSec) {
        // Sec is a solid disk — no nested hub circles inside
        canvas.drawCircle(center, outer, Paint()..color = spec.color);
      } else {
        final ringPath =
            Path()
              ..fillType = PathFillType.evenOdd
              ..addOval(Rect.fromCircle(center: center, radius: outer))
              ..addOval(Rect.fromCircle(center: center, radius: inner));
        canvas.drawPath(ringPath, Paint()..color = spec.color);
      }

      // Subtle separator only on outer edge
      canvas.drawCircle(
        center,
        outer,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = ZodiacTimerConfig.separatorColor,
      );

      _drawNumbers(
        canvas,
        center,
        config.numberRadius(i),
        spec,
        angles[i],
        values[i],
        config.scale,
      );
    }
  }

  void _drawNumbers(
    Canvas canvas,
    Offset center,
    double radius,
    ZodiacRingSpec spec,
    double angleOffset,
    int selected,
    double scale,
  ) {
    final step = (2 * math.pi) / spec.slots;
    final nearest = (angleOffset / step).round();
    final residual = angleOffset - nearest * step;
    final half = (spec.slots / 2).ceil();
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (var d = -half; d <= half; d++) {
      final raw = selected + d;
      final value =
          spec.min + ((raw - spec.min) % spec.span + spec.span) % spec.span;
      // Ascending values run along the visible arc (…17,18,19,20,21…)
      final angle = ZodiacTimerConfig.selectionAngle + d * step + residual;

      if (angle < -math.pi - 0.35 || angle > 0.55) continue;

      final isSelected = d == 0;
      final dist = _angDist(angle, ZodiacTimerConfig.selectionAngle);
      final fade = (1 - (dist / 1.05)).clamp(0.0, 1.0);
      if (!isSelected && fade < 0.05) continue;

      final fontSize =
          (isSelected ? spec.selectedFontSize : spec.fontSize) *
          scale *
          (isSelected ? 1.0 : 0.85 + fade * 0.15);

      tp.text = TextSpan(
        text: '$value',
        style: GoogleFonts.barlowCondensed(
          fontSize: fontSize,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color:
              isSelected
                  ? ZodiacTimerConfig.selectedColor
                  : spec.mutedColor.withValues(alpha: 0.35 + fade * 0.55),
          height: 1,
          letterSpacing: -0.3,
        ),
      );
      tp.layout();

      final pos = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  double _angDist(double a, double b) {
    var d = (a - b).abs() % (2 * math.pi);
    if (d > math.pi) d = 2 * math.pi - d;
    return d;
  }

  @override
  bool shouldRepaint(covariant ZodiacTimerPainter old) {
    if (old.config.center != config.center ||
        old.config.outerRadius != config.outerRadius ||
        old.config.ringWidth != config.ringWidth) {
      return true;
    }
    for (var i = 0; i < angles.length; i++) {
      if (old.angles[i] != angles[i] || old.values[i] != values[i]) return true;
    }
    return false;
  }
}
