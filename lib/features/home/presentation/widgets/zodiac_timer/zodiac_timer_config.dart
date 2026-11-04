import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Geometry + visual tokens for the Figma circular zodiac timer.
class ZodiacTimerConfig {
  const ZodiacTimerConfig({
    required this.center,
    required this.outerRadius,
    required this.ringWidth,
    required this.scale,
  });

  final Offset center;
  final double outerRadius;
  final double ringWidth;
  final double scale;

  static const ringCount = 6;

  static const labels = ['Yrs', 'Mm', 'Days', 'Hrs', 'Mins', 'Sec'];

  static const rings = <ZodiacRingSpec>[
    ZodiacRingSpec(
      color: AppColors.dialYrsFill,
      min: 0,
      max: 99,
      selected: 22,
      fontSize: 22,
      selectedFontSize: 24,
      mutedColor: AppColors.dialYrsMuted,
      angleSlots: 36,
    ),
    ZodiacRingSpec(
      color: AppColors.dialMmFill,
      min: 0,
      max: 11,
      selected: 9,
      fontSize: 17,
      selectedFontSize: 19,
      mutedColor: AppColors.dialMmMuted,
    ),
    ZodiacRingSpec(
      color: AppColors.dialDaysFill,
      min: 1,
      max: 31,
      selected: 20,
      fontSize: 14,
      selectedFontSize: 16,
      mutedColor: AppColors.dialDaysMuted,
    ),
    ZodiacRingSpec(
      color: AppColors.dialHrsFill,
      min: 0,
      max: 23,
      selected: 14,
      fontSize: 12,
      selectedFontSize: 13,
      mutedColor: AppColors.dialHrsMuted,
    ),
    ZodiacRingSpec(
      color: AppColors.dialMinsFill,
      min: 0,
      max: 59,
      selected: 8,
      fontSize: 11,
      selectedFontSize: 12,
      mutedColor: AppColors.dialMinsMuted,
    ),
    ZodiacRingSpec(
      color: AppColors.dialSecFill,
      min: 0,
      max: 59,
      selected: 20,
      fontSize: 11,
      selectedFontSize: 12,
      mutedColor: AppColors.dialSecMuted,
      // Wider gaps while keeping consecutive Sec order (17,18,19,20,21…)
      angleSlots: 40,
    ),
  ];

  static const hubColor = AppColors.dialHub;
  static const hubInnerColor = AppColors.dialHubInner;
  static const selectedColor = AppColors.dialSelected;
  static const separatorColor = AppColors.dialSeparator;

  /// Selection ray (~11 o'clock) for highlighted values.
  static const selectionAngle = -2.15;

  /// Build responsive geometry from available header width/height.
  factory ZodiacTimerConfig.fromSize(Size size) {
    final w = size.width;
    final scale = (w / 390).clamp(0.85, 1.15);

    // Oversized wheel: top cream arc sits under profile/bell (Figma).
    final outerRadius = w * 0.88;
    const hubRatio = 0.16;
    final ringWidth = ((outerRadius * (1 - hubRatio)) / ringCount).clamp(
      40.0,
      58.0,
    );
    // Center bottom-right so only upper-left shows; top of dial under icons.
    final center = Offset(w * 1.02, outerRadius + 28);

    return ZodiacTimerConfig(
      center: center,
      outerRadius: outerRadius,
      ringWidth: ringWidth,
      scale: scale,
    );
  }

  /// Outer → inner edge radii (length = ringCount + 1). Always ≥ hub.
  List<double> get edges {
    final hub = outerRadius - ringCount * ringWidth;
    final list = <double>[outerRadius];
    for (var i = 0; i < ringCount; i++) {
      list.add(outerRadius - (i + 1) * ringWidth);
    }
    // Safety: never allow non-positive inner edge
    if (list.last < hub.clamp(12.0, outerRadius)) {
      list[list.length - 1] = hub.clamp(12.0, outerRadius);
    }
    return list;
  }

  double midRadius(int ringIndex) {
    final e = edges;
    return (e[ringIndex] + e[ringIndex + 1]) / 2;
  }

  double numberRadius(int ringIndex) {
    final e = edges;
    final band = e[ringIndex] - e[ringIndex + 1];
    return e[ringIndex] - band * 0.32;
  }
}

class ZodiacRingSpec {
  const ZodiacRingSpec({
    required this.color,
    required this.min,
    required this.max,
    required this.selected,
    required this.fontSize,
    required this.selectedFontSize,
    required this.mutedColor,
    this.angleSlots,
  });

  final Color color;
  final int min;
  final int max;
  final int selected;
  final double fontSize;
  final double selectedFontSize;
  final Color mutedColor;
  final int? angleSlots;

  int get span => max - min + 1;
  int get slots => angleSlots ?? span;
}
