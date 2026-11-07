import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Today's Numerology — cream number-pattern bg + orb (Figma).
class NumerologyCard extends StatelessWidget {
  const NumerologyCard({
    super.key,
    required this.luckyNumber,
    this.fadeBottom = false,
  });

  final int luckyNumber;

  /// Softens the lower edge. Used on Insights only; Home stays a solid card.
  final bool fadeBottom;

  @override
  Widget build(BuildContext context) {
    const radius = 28.0;

    final card = AspectRatio(
      aspectRatio: 349 / 368,
      child: Container(
        decoration:
            fadeBottom
                ? null
                : BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  // border-image: linear-gradient(360deg, #FCF6DE → #CFC7A9)
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.numerologyBorder,
                      AppColors.numerologyBorderLight,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
        padding: EdgeInsets.all(fadeBottom ? 0 : 1.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            fadeBottom ? radius : radius - 1.2,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppConstants.numerology,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22, 18, 22, fadeBottom ? 56 : 20),
                child: Column(
                  children: [
                    const Text(
                      'Lucky Number',
                      style: TextStyle(
                        fontFamily: AppConstants.satoshi,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.29,
                        letterSpacing: 14 * -0.02,
                        color: AppColors.numerologyLabel,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(child: _LuckyOrb(number: luckyNumber)),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's guidance:",
                        style: TextStyle(
                          fontFamily: AppConstants.geist,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.29,
                          letterSpacing: 16 * -0.02,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Stay open to unexpected opportunities. Trust your instincts, explore something new, and avoid overthinking your next move.',
                      style: TextStyle(
                        fontFamily: AppConstants.satoshi,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.38,
                        letterSpacing: 14 * -0.02,
                        color: AppColors.numerologyBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!fadeBottom) return card;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF), Color(0x00FFFFFF)],
          stops: [0, 0.82, 1],
        ).createShader(rect);
      },
      child: card,
    );
  }
}

/// Drag to spin the globe; it completes a few turns and lands on 1–10.
class _LuckyOrb extends StatefulWidget {
  const _LuckyOrb({required this.number});

  final int number;

  @override
  State<_LuckyOrb> createState() => _LuckyOrbState();
}

class _LuckyOrbState extends State<_LuckyOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  late Animation<double> _yawAnim;
  final _rng = math.Random();

  late int _displayNumber;
  late int _resultNumber;
  double _yaw = 0;
  double _dragAccum = 0;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _displayNumber = widget.number.clamp(1, 10);
    _resultNumber = _displayNumber;
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _yawAnim = AlwaysStoppedAnimation(_yaw);
    _spin.addListener(_onSpinTick);
    _spin.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _spinning = false;
          _displayNumber = _resultNumber;
          _yaw = _yawAnim.value;
        });
      }
    });
  }

  void _onSpinTick() {
    if (!mounted) return;
    setState(() {
      _yaw = _yawAnim.value;
      // Roulette flicker until near the end, then lock result
      if (_spin.value < 0.82) {
        _displayNumber = ((_spin.value * 40).floor() % 10) + 1;
      } else {
        _displayNumber = _resultNumber;
      }
    });
  }

  @override
  void dispose() {
    _spin.removeListener(_onSpinTick);
    _spin.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_spinning) return;
    _dragAccum += d.delta.dx.abs();
    setState(() => _yaw += d.delta.dx * 0.02);
  }

  void _onPanEnd(DragEndDetails _) {
    if (_spinning) return;
    if (_dragAccum < 18) {
      _dragAccum = 0;
      return;
    }
    _dragAccum = 0;
    _startSpin();
  }

  void _startSpin() {
    _resultNumber = _rng.nextInt(10) + 1; // 1..10
    final turns = 3 + _rng.nextInt(3); // 3–5 full rotations
    final start = _yaw;
    final end =
        start + turns * math.pi * 2 + (_resultNumber / 10) * math.pi * 2;

    _yawAnim = Tween<double>(
      begin: start,
      end: end,
    ).animate(CurvedAnimation(parent: _spin, curve: Curves.easeOutCubic));
    setState(() => _spinning = true);
    _spin.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _GlobePainter(number: _displayNumber, yaw: _yaw),
          ),
        );
      },
    );
  }
}

/// Teal rotatable globe + orbit ring + pedestal (Figma).
class _GlobePainter extends CustomPainter {
  _GlobePainter({required this.number, required this.yaw});

  final int number;
  final double yaw;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Globe sits in upper half; leave room for ~0.28×diameter float gap + pedestal
    final r = math.min(size.width, size.height) * 0.28;
    final cy = size.height * 0.36;
    final center = Offset(cx, cy);

    _drawPedestal(canvas, cx, cy, r);
    _drawOrbitRingBack(canvas, center, r);
    _drawGlobe(canvas, center, r);
    _drawOrbitRingFront(canvas, center, r);
    _drawSurfaceNumbers(canvas, center, r);
    _drawLuckyNumber(canvas, center, r);
  }

  void _drawPedestal(Canvas canvas, double cx, double cy, double r) {
    // Isometric cube pedestal
    final halfW = r * 0.88;
    final topRise = r * 0.36;
    final sideH = r * 0.88;
    final gap = r * 0.26;
    final y0 = cy + r + gap;

    final topN = Offset(cx, y0);
    final topE = Offset(cx + halfW, y0 + topRise);
    final topS = Offset(cx, y0 + topRise * 2);
    final topW = Offset(cx - halfW, y0 + topRise);

    final botE = Offset(topE.dx, topE.dy + sideH);
    final botS = Offset(topS.dx, topS.dy + sideH);
    final botW = Offset(topW.dx, topW.dy + sideH);

    const teal = AppColors.globeTeal;
    const tealDeep = AppColors.globeTealDeep;
    const tealSoft = AppColors.globeTealSoft;
    final fade = AppColors.globeCream.withValues(alpha: 0);

    Path face(Offset a, Offset b, Offset c, Offset d) =>
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(b.dx, b.dy)
          ..lineTo(c.dx, c.dy)
          ..lineTo(d.dx, d.dy)
          ..close();

    final reflect =
        Path()
          ..moveTo(botW.dx, botW.dy)
          ..lineTo(botS.dx, botS.dy)
          ..lineTo(botE.dx, botE.dy)
          ..lineTo(botE.dx, botE.dy + sideH * 0.5)
          ..lineTo(botS.dx, botS.dy + sideH * 0.62)
          ..lineTo(botW.dx, botW.dy + sideH * 0.5)
          ..close();
    canvas.drawPath(
      reflect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [teal.withValues(alpha: 0.11), teal.withValues(alpha: 0)],
        ).createShader(
          Rect.fromPoints(
            Offset(botW.dx, botW.dy),
            Offset(botE.dx, botS.dy + sideH * 0.62),
          ),
        ),
    );

    canvas.drawPath(
      face(topW, topS, botS, botW),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tealDeep, teal, fade],
          stops: const [0.0, 0.3, 1.0],
        ).createShader(Rect.fromPoints(topW, botS)),
    );
    canvas.drawPath(
      face(topE, topS, botS, botE),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tealSoft, teal, fade],
          stops: const [0.0, 0.3, 1.0],
        ).createShader(Rect.fromPoints(topE, botS)),
    );

    final top = face(topN, topE, topS, topW);
    canvas.drawPath(
      top,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tealSoft, teal, tealDeep],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromPoints(Offset(topW.dx, topN.dy), Offset(topE.dx, topS.dy)),
        ),
    );
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = AppColors.white.withValues(alpha: 0.2),
    );
  }

  void _drawGlobe(Canvas canvas, Offset center, double r) {
    // Outer atmosphere glow
    canvas.drawCircle(
      center,
      r * 1.22,
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
        ..color = AppColors.globeGlow.withValues(alpha: 0.28),
    );

    // Globe sphere
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 1.05,
          colors: [
            AppColors.globeHighlight,
            AppColors.globeMid,
            AppColors.globeOcean,
            AppColors.globeDeep,
            AppColors.globeAbyss,
          ],
          stops: [0.0, 0.28, 0.55, 0.82, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Latitude / longitude grid (globe feel)
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: r)),
    );
    final grid =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..color = AppColors.white.withValues(alpha: 0.18);

    // Meridians — shift with yaw so the globe feels like it spins
    for (var i = 0; i < 6; i++) {
      final lon = yaw + i * (math.pi / 6);
      // Project meridian as ellipse; hide back side via width
      final phase = math.cos(lon);
      if (phase.abs() < 0.08) continue;
      final w = (r * 2 * phase.abs()).clamp(r * 0.12, r * 2.0);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + math.sin(lon) * r * 0.08, center.dy),
          width: w * 0.92,
          height: r * 2.0,
        ),
        grid
          ..color = AppColors.white.withValues(
            alpha: 0.10 + 0.14 * phase.abs(),
          ),
      );
    }
    // Parallels (fixed)
    for (final y in [-0.55, -0.25, 0.0, 0.28, 0.55]) {
      final rr = r * math.sqrt(1 - y * y);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + y * r),
          width: rr * 2,
          height: rr * 0.35,
        ),
        grid..color = AppColors.white.withValues(alpha: 0.16),
      );
    }
    canvas.restore();

    // Rim light
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..shader = SweepGradient(
          colors: [
            AppColors.white.withValues(alpha: 0.0),
            AppColors.white.withValues(alpha: 0.35),
            AppColors.white.withValues(alpha: 0.0),
            AppColors.white.withValues(alpha: 0.12),
            AppColors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Specular highlight
    canvas.drawCircle(
      center.translate(-r * 0.34, -r * 0.40),
      r * 0.16,
      Paint()..color = AppColors.white.withValues(alpha: 0.42),
    );
    canvas.drawCircle(
      center.translate(-r * 0.22, -r * 0.28),
      r * 0.06,
      Paint()..color = AppColors.white.withValues(alpha: 0.55),
    );
  }

  // Ring outer ≈ 1.7× globe diameter (Figma)
  Rect _ringRect(double r) =>
      Rect.fromCenter(center: Offset.zero, width: r * 3.4, height: r * 0.88);

  void _drawOrbitRingBack(Canvas canvas, Offset center, double r) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.18);
    canvas.drawArc(
      _ringRect(r),
      math.pi * 0.08,
      math.pi * 0.84,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = AppColors.globeRing.withValues(alpha: 0.4),
    );
    canvas.restore();
  }

  void _drawOrbitRingFront(Canvas canvas, Offset center, double r) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.18);
    final ring = _ringRect(r);
    canvas.drawArc(
      ring,
      -math.pi * 0.92,
      math.pi * 0.84,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..shader = const LinearGradient(
          colors: [
            AppColors.globeRingFade,
            AppColors.globeRingGold,
            AppColors.globeRingCyan,
            AppColors.globeRingCyanFade,
          ],
        ).createShader(ring),
    );
    canvas.drawArc(
      ring,
      -math.pi * 0.92,
      math.pi * 0.84,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5)
        ..color = AppColors.globeRingSoft.withValues(alpha: 0.65),
    );
    canvas.restore();
  }

  void _drawSurfaceNumbers(Canvas canvas, Offset center, double r) {
    final tp = TextPainter(textDirection: TextDirection.ltr);
    // Digits placed on a sphere; only front hemisphere is visible
    final surface = [9, 3, 6, 4, 7, 8, 1, 2, 5, 0];
    for (var i = 0; i < surface.length; i++) {
      final lon0 = i * (2 * math.pi / surface.length);
      final lat = -0.55 + (i % 5) * 0.28;
      final lon = lon0 + yaw;
      final cosLat = math.cos(lat);
      final x = math.sin(lon) * cosLat;
      final z = math.cos(lon) * cosLat; // depth: >0 = front
      final y = math.sin(lat);
      if (z < 0.05) continue; // back face hidden

      final pos = Offset(center.dx + x * r * 0.78, center.dy + y * r * 0.78);
      final depthFade = ((z + 0.1) / 1.1).clamp(0.0, 1.0);
      tp.text = TextSpan(
        text: '${surface[i]}',
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.18 + 0.42 * depthFade),
          fontSize: (8.0 + 6.0 * depthFade) * (i.isEven ? 1.15 : 1.0),
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      );
      tp.layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  void _drawLuckyNumber(Canvas canvas, Offset center, double r) {
    final main =
        TextPainter(textDirection: TextDirection.ltr)
          ..text = TextSpan(
            text: '$number',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.92),
              fontSize: r * 1.05,
              fontWeight: FontWeight.w300,
              height: 1,
              fontFamily: AppConstants.geist,
              shadows: [
                Shadow(
                  color: AppColors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                ),
              ],
            ),
          )
          ..layout();
    main.paint(canvas, center - Offset(main.width / 2, main.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) =>
      oldDelegate.number != number || oldDelegate.yaw != yaw;
}
