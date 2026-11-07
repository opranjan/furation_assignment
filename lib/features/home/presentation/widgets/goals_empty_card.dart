import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Goals empty state — Figma typography + text positions.
class GoalsEmptyCard extends StatelessWidget {
  const GoalsEmptyCard({super.key, this.onCreate});

  final VoidCallback? onCreate;

  static const double _cardHeight = 176;

  /// Geist Bold 20 / 129% / -2%
  static const _titleStyle = TextStyle(
    fontFamily: AppConstants.geist,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.29,
    letterSpacing: 20 * -0.02,
    color: AppColors.goalsTitle,
  );

  /// Satoshi Regular 14 / 129% / -2%
  static const _subtitleStyle = TextStyle(
    fontFamily: AppConstants.satoshi,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.29,
    letterSpacing: 14 * -0.02,
    color: AppColors.goalsSubtitle,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final cardWidth = maxWidth < 351 ? maxWidth : 351.0;
        return Container(
          width: cardWidth,
          height: _cardHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.goalsBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.goalsSand,
                      AppColors.goalsGold,
                      AppColors.goalsSage,
                      AppColors.goalsDeep,
                    ],
                    stops: [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
              Image.asset(
                AppConstants.goalsMountains,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
              // Title — Geist 700 / 20px @ top 20, left 21 (124×26)
              const Positioned(
                left: 21,
                top: 20,
                width: 124,
                height: 26,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No Goals Yet',
                    maxLines: 1,
                    softWrap: false,
                    style: _titleStyle,
                  ),
                ),
              ),
              // Subtitle — Satoshi 400 / 14px @ top 51, left 21 (168×36)
              const Positioned(
                left: 21,
                top: 51,
                width: 168,
                height: 36,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let your intentions guide your journey.',
                    maxLines: 2,
                    style: _subtitleStyle,
                  ),
                ),
              ),
              // CTA — 271×35 @ top 126, left 37
              Positioned(
                left: 37,
                top: 126,
                width: 271,
                height: 35,
                child: _CreateGoalButton(onPressed: onCreate),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateGoalButton extends StatelessWidget {
  const _CreateGoalButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 271,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.white, width: 1.5),
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          child: const Stack(
            children: [
              Positioned(
                left: 72,
                top: 9,
                width: 130,
                height: 18,
                child: Stack(
                  children: [
                    Positioned(
                      top: 3,
                      left: 0,
                      width: 11.5,
                      height: 11.5,
                      child: Icon(
                        Icons.add,
                        size: 11.5,
                        color: AppColors.white,
                      ),
                    ),
                    Positioned(
                      left: 19,
                      width: 111,
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Your Goal',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: AppConstants.geist,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.29,
                            letterSpacing: 14 * -0.02,
                            color: AppColors.white,
                          ),
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
    );
  }
}
