import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/section_header.dart';
import 'bloc/home_bloc.dart';
import 'widgets/goals_empty_card.dart';
import 'widgets/horoscope_card.dart';
import 'widgets/journal_teaser_card.dart';
import 'widgets/numerology_card.dart';
import 'widgets/zodiac_timer/zodiac_timer.dart';
import 'widgets/zodiac_timer/zodiac_timer_config.dart';
import 'widgets/zodiac_timer/zodiac_timer_labels.dart';
import '../../../core/theme/app_colors.dart';

/// Home — Figma "Home Screen For First Time user".
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final user = state.user;
        final horoscope = state.horoscope;
        final topPadding = MediaQuery.paddingOf(context).top;
        final width = MediaQuery.sizeOf(context).width;
        // Figma sheet: top 406, radius 24. Column: top 440, left 26, width 352, gap 37.
        const sheetTop = 406.0;
        const sheetRadius = 24.0;
        const contentTop = 440.0;
        const sectionGap = 37.0;
        const headerToCard = 16.0;
        final sx = width / 402;
        final contentLeft = 26 * sx;
        final contentRight = 24 * sx;
        final headerHeight = sheetTop + sheetRadius;
        final hour = DateTime.now().hour;
        final greeting =
            hour < 12
                ? 'Good Morning,'
                : (hour < 17 ? 'Good Afternoon,' : 'Good Evening,');

        return ColoredBox(
          color: AppColors.headerBottom,
          child: CustomScrollView(
            //  physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: headerHeight,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.headerLift,
                          AppColors.headerMid,
                          AppColors.headerBottom,
                        ],
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _ZodiacPatternPainter(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: topPadding + 8,
                          bottom: 0,
                          child: const FadeSlideIn(
                            delay: Duration(milliseconds: 100),
                            child: ZodiacTimer(),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 16,
                          top: topPadding + 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FadeSlideIn(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            greeting,
                                            style: TextStyle(
                                              fontFamily: AppConstants.satoshi,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              height: 1.29,
                                              letterSpacing: 12 * -0.02,
                                              color: AppColors.greetingMuted,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 31,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              fontFamily: AppConstants.geist,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                              height: 1.29,
                                              letterSpacing: 24 * -0.02,
                                              color: AppColors.headerName,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            user.traitsLine,
                                            style: TextStyle(
                                              fontFamily: AppConstants.satoshi,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              height: 1.29,
                                              letterSpacing: 12 * -0.02,
                                              color: AppColors.headerTraits,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 26),
                                child: Row(
                                  children: [
                                    _RoundIcon(AppConstants.homeProfile),
                                    SizedBox(width: 10),
                                    _RoundIcon(AppConstants.homeNotification),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (_) {
                            final timerH = (width * 0.88).clamp(300.0, 380.0);
                            final timer = ZodiacTimerConfig.fromSize(
                              Size(width, timerH),
                            );
                            final timerTop = topPadding + 8;
                            final config = ZodiacTimerConfig(
                              center: Offset(
                                timer.center.dx,
                                timerTop + timer.center.dy,
                              ),
                              outerRadius: timer.outerRadius,
                              ringWidth: timer.ringWidth,
                              scale: timer.scale,
                            );
                            return Positioned.fill(
                              child: IgnorePointer(
                                child: ZodiacTimerLabels(
                                  config: config,
                                  chordY: sheetTop - 16,
                                ),
                              ),
                            );
                          },
                        ),
                        // Figma: 24px top-left / top-right white sheet on dial
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: sheetRadius,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sheetRadius),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: AppColors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      contentLeft,
                      0, // contentTop - headerHeight,
                      contentRight,
                      100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 140),
                          child: SectionHeader(title: "GOAL'S", opacity: 0.45),
                        ),
                        const SizedBox(height: headerToCard),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 180),
                          child: GoalsEmptyCard(
                            onCreate: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Create Goal — UI only'),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: sectionGap),
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 220),
                          child: SectionHeader(
                            title: "TODAY'S HOROSCOPE",
                            opacity: 0.45,
                            height: 21,
                          ),
                        ),
                        //const SizedBox(height: headerToCard),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 260),
                          child: HoroscopeCard(horoscope: horoscope),
                        ),
                        const SizedBox(height: sectionGap),
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 300),
                          child: SectionHeader(
                            title: "TODAY'S NUMEROLOGY",
                            opacity: 0.45,
                            height: 21,
                          ),
                        ),
                        const SizedBox(height: headerToCard),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 340),
                          child: NumerologyCard(
                            luckyNumber: horoscope.luckyNumber,
                          ),
                        ),
                        const SizedBox(height: sectionGap),
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 380),
                          child: SectionHeader(
                            title: 'YOUR JOURNAL',
                            opacity: 0.45,
                            height: 21,
                          ),
                        ),
                        const SizedBox(height: headerToCard),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 420),
                          child: SizedBox(
                            width: double.infinity,
                            height: 462 * sx,
                            child: OverflowBox(
                              alignment: Alignment.centerLeft,
                              minWidth: 363 * sx,
                              maxWidth: 363 * sx,
                              minHeight: 462 * sx,
                              maxHeight: 462 * sx,
                              child: Transform.translate(
                                offset: Offset(-11 * sx, 0),
                                child: JournalTeaserCard(ownerName: user.name),
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.iconRing),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SvgPicture.asset(
        asset,
        width: 22,
        height: 22,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ZodiacPatternPainter extends CustomPainter {
  static const symbols = [
    '♈',
    '♉',
    '♊',
    '♋',
    '♌',
    '♍',
    '♎',
    '♏',
    '♐',
    '♑',
    '♒',
    '♓',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(textDirection: TextDirection.ltr);
    final positions = <Offset>[
      Offset(size.width * 0.08, size.height * 0.22),
      Offset(size.width * 0.22, size.height * 0.38),
      Offset(size.width * 0.12, size.height * 0.55),
      Offset(size.width * 0.78, size.height * 0.18),
      Offset(size.width * 0.88, size.height * 0.42),
      Offset(size.width * 0.70, size.height * 0.58),
      Offset(size.width * 0.35, size.height * 0.68),
      Offset(size.width * 0.55, size.height * 0.72),
    ];
    for (var i = 0; i < positions.length; i++) {
      tp.text = TextSpan(
        text: symbols[i % symbols.length],
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.10),
          fontSize: 28,
        ),
      );
      tp.layout();
      tp.paint(canvas, positions[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
