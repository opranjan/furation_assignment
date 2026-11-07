import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/horoscope.dart';

/// Today's Horoscope — scales from Figma 351×190 frame.
class HoroscopeCard extends StatelessWidget {
  const HoroscopeCard({super.key, required this.horoscope});

  final Horoscope horoscope;

  static const _designW = 351.0;
  static const _designH = 190.0;
  static const _coin = 78.11629486083984;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w =
            constraints.maxWidth.isFinite ? constraints.maxWidth : _designW;
        final s = w / _designW;
        final h = _designH * s;
        final coin = _coin * s;
        // Coin hangs above the card; keep that overhang inside this box
        // so the scroll view does not clip the top of the icon.
        final overhang = coin * 0.16;

        return SizedBox(
          width: w,
          height: h + overhang,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: overhang,
                left: 0,
                right: 0,
                height: h,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24 * s),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.22),
                        blurRadius: 16 * s,
                        offset: Offset(0, 8 * s),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(AppConstants.horoscope),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(painter: _HoroscopeFxPainter()),
                        ),
                      ),
                      Positioned(
                        left: 19 * s,
                        top: 17 * s,
                        width: 65 * s,
                        height: 26 * s,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            horoscope.sign,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: AppConstants.satoshi,
                              fontWeight: FontWeight.w700,
                              fontSize: 20 * s,
                              height: 1.29,
                              letterSpacing: 20 * -0.02 * s,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19 * s,
                        top: 45 * s,
                        width: 82 * s,
                        height: 17 * s,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            horoscope.dateLabel,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: AppConstants.satoshi,
                              fontWeight: FontWeight.w500,
                              fontSize: 12 * s,
                              height: 1.38,
                              letterSpacing: 12 * -0.02 * s,
                              color: AppColors.horoscopeDate,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19 * s,
                        top: 77 * s,
                        width: 257 * s,
                        height: 76 * s,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            horoscope.body,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppConstants.satoshi,
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * s,
                              height: 1.38,
                              letterSpacing: 14 * -0.02 * s,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 253 * s,
                        top: 120 * s,
                        width: 77 * s,
                        height: 17 * s,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              width: 66 * s,
                              height: 17 * s,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Read more',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12 * s,
                                    height: 1.4,
                                    letterSpacing: 12 * -0.01 * s,
                                    color: AppColors.readMore,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 72 * s,
                              top: 4 * s,
                              width: 5 * s,
                              height: 9 * s,
                              child: Transform.rotate(
                                angle: math.pi,
                                child: CustomPaint(
                                  painter: _ChevronPainter(AppColors.readMore),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Coin sits on the top edge, inset from the corner so it stays whole.
              Positioned(
                top: -20,
                right: 16 * s,
                width: coin,
                height: coin,
                child: Image.asset(
                  AppConstants.geminiCoin,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Left-pointing chevron. Rotated 180° so it reads as the Read more arrow.
class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    final path =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(0, size.height / 2)
          ..lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _HoroscopeFxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ray =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.72, -0.55),
            radius: 1.15,
            colors: [
              AppColors.white.withValues(alpha: 0.16),
              AppColors.white.withValues(alpha: 0.05),
              AppColors.transparent,
            ],
            stops: const [0.0, 0.35, 1.0],
          ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, ray);

    final rng = math.Random(42);
    final paint = Paint();
    for (var i = 0; i < 42; i++) {
      final x = size.width * (0.42 + rng.nextDouble() * 0.55);
      final y = rng.nextDouble() * size.height * 0.7;
      final r = rng.nextDouble() * 1.3 + 0.3;
      paint.color = AppColors.white.withValues(
        alpha: 0.14 + rng.nextDouble() * 0.28,
      );
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
