import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Goals tab — content not ready yet.
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cream,
      child: Center(
        child: Text('Coming soon', style: AppTypography.displaySerif(size: 28)),
      ),
    );
  }
}
