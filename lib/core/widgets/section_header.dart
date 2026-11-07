import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Section label row — Geist SemiBold 16, uppercase, #141414.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.opacity = 1,
    this.height = 16 * 1.29,
  });

  final String title;
  final Widget? trailing;
  final double opacity;
  final double height;

  static const _style = TextStyle(
    fontFamily: AppConstants.geist,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.29,
    letterSpacing: 16 * -0.02,
    color: AppColors.sectionTitle,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: _style.copyWith(
              color: AppColors.sectionTitle.withValues(alpha: opacity),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
