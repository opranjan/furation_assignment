import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final headerHeight = topPadding + (width * 1.05).clamp(380.0, 460.0);
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
                                      Text(
                                        greeting,
                                        style: AppTypography.body(
                                          size: 14,
                                          color: AppColors.greetingMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user.name,
                                        style: AppTypography.title(
                                          size: 32,
                                          weight: FontWeight.w700,
                                          color: AppColors.white,
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        user.traitsLine,
                                        style: AppTypography.label(
                                          size: 12,
                                          weight: FontWeight.w400,
                                          color: AppColors.cyanMuted,
                                          letterSpacing: 0.2,
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
                                  chordY: headerHeight - 40,
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
                          height: 28,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FadeSlideIn(
                                delay: Duration(milliseconds: 140),
                                child: SectionHeader(title: "GOAL'S"),
                              ),
                              const SizedBox(height: 10),
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
                              const SizedBox(height: 28),
                              const FadeSlideIn(
                                delay: Duration(milliseconds: 220),
                                child: SectionHeader(
                                  title: "TODAY'S HOROSCOPE",
                                ),
                              ),
                              // Figma: card top 37 → header 21 + gap 16
                              //const SizedBox(height: 16),
                              FadeSlideIn(
                                delay: const Duration(milliseconds: 260),
                                child: HoroscopeCard(horoscope: horoscope),
                              ),
                              const SizedBox(height: 28),
                              const FadeSlideIn(
                                delay: Duration(milliseconds: 300),
                                child: SectionHeader(
                                  title: "TODAY'S NUMEROLOGY",
                                ),
                              ),
                              const SizedBox(height: 14),
                              FadeSlideIn(
                                delay: const Duration(milliseconds: 340),
                                child: NumerologyCard(
                                  luckyNumber: horoscope.luckyNumber,
                                ),
                              ),
                              const SizedBox(height: 28),
                              const FadeSlideIn(
                                delay: Duration(milliseconds: 380),
                                child: SectionHeader(title: 'YOUR JOURNAL'),
                              ),
                              // Figma: card top 37 → header 21 + gap 16
                              const SizedBox(height: 16),
                              FadeSlideIn(
                                delay: const Duration(milliseconds: 420),
                                child: JournalTeaserCard(ownerName: user.name),
                              ),
                            ],
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
      child: Image.asset(asset, width: 22, height: 22, fit: BoxFit.contain),
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
