import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'dial_tick_feedback.dart';
import 'zodiac_timer_config.dart';
import 'zodiac_timer_painter.dart';

/// Wins against parent [CustomScrollView] so ring pans aren't stolen.
class _EagerPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

/// Circular zodiac timer — Figma Home header wheel.
class ZodiacTimer extends StatefulWidget {
  const ZodiacTimer({super.key, this.height, this.enableInteraction = true});

  final double? height;
  final bool enableInteraction;

  @override
  State<ZodiacTimer> createState() => _ZodiacTimerState();
}

class _ZodiacTimerState extends State<ZodiacTimer>
    with TickerProviderStateMixin {
  late final List<double> _angles = List<double>.filled(
    ZodiacTimerConfig.ringCount,
    0,
    growable: false,
  );
  late final List<AnimationController> _ctrls;

  int? _activeRing;
  double _lastAngle = 0;
  double _lastPanMs = 0;
  double _velocity = 0;
  int _lastTickIndex = 0;
  ZodiacTimerConfig? _config;

  void _tickFeedback({bool strong = false}) {
    DialTickFeedback.instance.tick(strong: strong);
  }

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      ZodiacTimerConfig.ringCount,
      (_) => AnimationController(vsync: this),
    );
    DialTickFeedback.instance.warmUp();
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  int _valueFor(int i) {
    final spec = ZodiacTimerConfig.rings[i];
    final step = (2 * math.pi) / spec.slots;
    // Match painter: increasing angle → increasing value
    final steps = (_angles[i] / step).round();
    final raw = spec.selected + steps;
    return spec.min + ((raw - spec.min) % spec.span + spec.span) % spec.span;
  }

  /// Hub counts as Sec so the innermost ring is easy to grab.
  int? _hitRing(Offset local, ZodiacTimerConfig config) {
    final d = (local - config.center).distance;
    final edges = config.edges;
    if (d > edges.first + 16) return null;
    if (d <= edges[ZodiacTimerConfig.ringCount - 1] + 6) {
      return ZodiacTimerConfig.ringCount - 1; // Sec
    }
    for (var i = 0; i < ZodiacTimerConfig.ringCount; i++) {
      if (d <= edges[i] + 2 && d >= edges[i + 1] - 2) return i;
    }
    return null;
  }

  double _atan(Offset local, Offset center) =>
      math.atan2(local.dy - center.dy, local.dx - center.dx);

  void _onPanStart(DragStartDetails d) {
    if (!widget.enableInteraction) return;
    final config = _config;
    if (config == null) return;

    final ring = _hitRing(d.localPosition, config);
    _activeRing = ring;
    if (ring != null) {
      _ctrls[ring].stop();
      _lastAngle = _atan(d.localPosition, config.center);
      _lastPanMs = DateTime.now().millisecondsSinceEpoch.toDouble();
      _velocity = 0;
      final step = (2 * math.pi) / ZodiacTimerConfig.rings[ring].slots;
      _lastTickIndex = (_angles[ring] / step).round();
      _tickFeedback();
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final ring = _activeRing;
    final config = _config;
    if (ring == null || config == null) return;

    final angle = _atan(d.localPosition, config.center);
    var delta = angle - _lastAngle;
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;

    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    final dt = ((now - _lastPanMs) / 1000).clamp(0.001, 0.05);
    _velocity = delta / dt;
    _lastPanMs = now;
    _lastAngle = angle;

    final step = (2 * math.pi) / ZodiacTimerConfig.rings[ring].slots;
    final next = _angles[ring] + delta;
    final tick = (next / step).round();
    if (tick != _lastTickIndex) {
      _lastTickIndex = tick;
      _tickFeedback();
    }

    setState(() => _angles[ring] = next);
  }

  Future<void> _onPanEnd(DragEndDetails _) async {
    final ring = _activeRing;
    _activeRing = null;
    if (ring == null) return;

    final spec = ZodiacTimerConfig.rings[ring];
    final step = (2 * math.pi) / spec.slots;
    final ctrl = _ctrls[ring];
    final start = _angles[ring];
    final sim = FrictionSimulation(0.14, start, _velocity.clamp(-30.0, 30.0));

    var snapped = false;
    void frictionListener() {
      final t =
          (ctrl.duration ?? Duration.zero).inMilliseconds * ctrl.value / 1000.0;
      if (!mounted) return;
      final next = sim.x(t);
      final tick = (next / step).round();
      if (tick != _lastTickIndex) {
        _lastTickIndex = tick;
        _tickFeedback();
      }
      setState(() => _angles[ring] = next);
      if (sim.isDone(t) && !snapped) {
        snapped = true;
        ctrl.removeListener(frictionListener);
        ctrl.stop();
        _snap(ring, step);
      }
    }

    ctrl
      ..duration = const Duration(seconds: 3)
      ..addListener(frictionListener);
    await ctrl.forward(from: 0);
    ctrl.removeListener(frictionListener);
    if (!snapped && mounted) await _snap(ring, step);
  }

  Future<void> _snap(int ring, double step) async {
    final begin = _angles[ring];
    final end = (begin / step).round() * step;
    if ((end - begin).abs() < 0.0001) {
      if (mounted) setState(() => _angles[ring] = end);
      return;
    }
    _tickFeedback(strong: true);

    final ctrl = _ctrls[ring];
    void settle() {
      if (!mounted) return;
      final t = Curves.easeOutCubic.transform(ctrl.value.clamp(0.0, 1.0));
      setState(() => _angles[ring] = begin + (end - begin) * t);
    }

    ctrl.duration = const Duration(milliseconds: 180);
    ctrl.addListener(settle);
    await ctrl.forward(from: 0);
    ctrl.removeListener(settle);
    if (mounted) setState(() => _angles[ring] = end);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
        final height = widget.height ?? (width * 0.88).clamp(300.0, 380.0);

        final config = ZodiacTimerConfig.fromSize(Size(width, height));
        _config = config;

        final values = List.generate(ZodiacTimerConfig.ringCount, _valueFor);

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: RawGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    gestures: <Type, GestureRecognizerFactory>{
                      _EagerPanGestureRecognizer:
                          GestureRecognizerFactoryWithHandlers<
                            _EagerPanGestureRecognizer
                          >(_EagerPanGestureRecognizer.new, (
                            _EagerPanGestureRecognizer instance,
                          ) {
                            instance
                              ..onStart = _onPanStart
                              ..onUpdate = _onPanUpdate
                              ..onEnd = _onPanEnd
                              ..onCancel = () {
                                _activeRing = null;
                              };
                          }),
                    },
                    child: CustomPaint(
                      painter: ZodiacTimerPainter(
                        config: config,
                        angles: List<double>.from(_angles),
                        values: values,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
