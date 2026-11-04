import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';
import 'app_routes.dart';

/// Shown for unknown paths and routes that fail to build.
class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Page not found',
                  textAlign: TextAlign.center,
                  style: AppTypography.displaySerif(size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'That link does not match a screen in Lumina.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body(),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Go home',
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
