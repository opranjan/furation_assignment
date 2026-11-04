import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.splashIntroDuration,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.86,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    Timer(AppConstants.splashHoldDuration, () {
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashTop,
              AppColors.splashBg,
              AppColors.splashBottom,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldSoft, width: 1.4),
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.45),
                        AppColors.primaryDeep,
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('✨', style: TextStyle(fontSize: 34)),
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.appName,
                  style: AppTypography.displaySerif(
                    size: 40,
                    color: AppColors.textOnDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Astrology • Journal • Insights',
                  style: AppTypography.label(
                    size: 13,
                    color: AppColors.textOnDarkMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
