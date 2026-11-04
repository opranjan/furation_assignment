import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Section label row — Figma: Geist SemiBold 16 / space-between / opacity 0.45.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  /// CSS text-transform: capitalize
  static String _capitalize(String value) {
    return value
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }

  static const _style = TextStyle(
    fontFamily: 'Geist',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.29,
    letterSpacing: 16 * -0.02,
    color: AppColors.black,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 21,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _capitalize(title),
            style: _style.copyWith(
              color: AppColors.black.withValues(alpha: 0.45),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
