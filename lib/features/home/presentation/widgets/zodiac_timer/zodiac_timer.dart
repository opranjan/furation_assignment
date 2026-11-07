import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'zodiac_timer_config.dart';
import 'zodiac_timer_painter.dart';

/// Circular zodiac timer. Rings follow the real clock and turn on their own.
class ZodiacTimer extends StatefulWidget {
  const ZodiacTimer({super.key, this.height});

  final double? height;

  @override
  State<ZodiacTimer> createState() => _ZodiacTimerState();
}

class _ZodiacTimerState extends State<ZodiacTimer>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// Yrs, Mm, Days, Hrs, Mins, Sec — exact values, fraction included.
  List<double> _exact(DateTime now) {
    final second = now.second + now.millisecond / 1000 + now.microsecond / 1e6;
    final minute = now.minute + second / 60;
    final hour = now.hour + minute / 60;
    final dayFraction = hour / 24;

    final yearStart = DateTime(now.year);
    final nextYear = DateTime(now.year + 1);
    final daysInYear = nextYear.difference(yearStart).inDays;
    final dayOfYear = now.difference(yearStart).inDays;
    final year = (now.year % 100) + (dayOfYear + dayFraction) / daysInYear;

    final monthStart = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);
    final daysInMonth = nextMonth.difference(monthStart).inDays;
    final month = now.month + ((now.day - 1) + dayFraction) / daysInMonth;

    final day = now.day + dayFraction;

    return [year, month, day, hour, minute, second];
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

        return SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: ZodiacTimerPainter(config: config, exact: _exact(_now)),
          ),
        );
      },
    );
  }
}
