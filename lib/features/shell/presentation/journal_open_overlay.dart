import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen book-open. The Journal screen is already underneath, so the
/// cover turns off the left edge and the page is the screen itself.
class JournalOpenOverlay extends StatefulWidget {
  const JournalOpenOverlay({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<JournalOpenOverlay> createState() => _JournalOpenOverlayState();
}

class _JournalOpenOverlayState extends State<JournalOpenOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward().whenComplete(() {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_controller.value);
        final angle = t * (math.pi / 2) * 0.98;
        final coverOpacity =
            t < 0.82 ? 1.0 : (1 - (t - 0.82) / 0.18).clamp(0.0, 1.0);
        final shade = (1 - t) * 0.22;
        return Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.black.withValues(alpha: shade),
                      AppColors.transparent,
                    ],
                    stops: const [0, 0.42],
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: coverOpacity,
              child: Transform(
                alignment: Alignment.centerLeft,
                filterQuality: FilterQuality.medium,
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.0008)
                      ..rotateY(-angle),
                child: const ColoredBox(
                  color: AppColors.journalCover,
                  child: Image(
                    image: AssetImage(AppConstants.journalCover),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
