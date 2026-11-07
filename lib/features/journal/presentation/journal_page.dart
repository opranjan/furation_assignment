import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_flip/page_flip.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../home/domain/usecases/get_user.dart';
import '../domain/entities/journal_entry.dart';
import 'bloc/journal_bloc.dart';
import '../../../core/theme/app_colors.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _JournalView();
  }
}

class _JournalView extends StatelessWidget {
  const _JournalView();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return ColoredBox(
      color: AppColors.white,
      child: Stack(
        children: [
          const _JournalGlow(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FadeSlideIn(
                        child: SizedBox(
                          width: 143,
                          height: 31,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Your Journal',
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: AppConstants.geist,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                height: 1.29,
                                letterSpacing: 24 * -0.02,
                                color: AppColors.journalHeading,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const FadeSlideIn(
                        delay: Duration(milliseconds: 80),
                        child: SizedBox(
                          width: 127,
                          height: 21,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'A Space To Be You',
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: AppConstants.satoshi,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.29,
                                letterSpacing: 16 * -0.02,
                                color: AppColors.journalSubtitle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 120),
                        child: const _JournalCover(),
                      ),
                      const SizedBox(height: 22),
                      const FadeSlideIn(
                        delay: Duration(milliseconds: 180),
                        child: _MonthChips(),
                      ),
                      const SizedBox(height: 14),
                      const Center(child: _SparkleDivider()),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: const Text(
                              'Recent Entries',
                              style: TextStyle(
                                fontFamily: AppConstants.geist,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add Entry is mock UI only.'),
                                ),
                              );
                            },
                            child: const Text(
                              '+ Add Entry',
                              style: TextStyle(
                                fontFamily: AppConstants.satoshi,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.journalAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  if (state.entries.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                        child: Text(
                          'No entries for this month yet.',
                          style: AppTypography.body(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                    sliver: SliverList.separated(
                      itemCount: state.entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 80 * index),
                          child: _EntryCard(entry: state.entries[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma Ellipse 12 — 662×662 at top -269, left -94.
/// Gradient #FEF2C2 → #D4E8EC → #E9F3F5, layer blur 116.6.
class _JournalGlow extends StatelessWidget {
  const _JournalGlow();

  @override
  Widget build(BuildContext context) {
    const blur = 116.6;
    return Positioned(
      top: -269 - blur,
      left: -94 - blur,
      width: 662 + blur * 2,
      height: 662 + blur * 2,
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur / 2, sigmaY: blur / 2),
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.yellowLight,
                    AppColors.mintLight,
                    AppColors.mintFade,
                  ],
                ),
              ),
              child: SizedBox(width: 662, height: 662),
            ),
          ),
        ),
      ),
    );
  }
}

class _JournalCover extends StatefulWidget {
  const _JournalCover();

  @override
  State<_JournalCover> createState() => _JournalCoverState();
}

class _JournalCoverState extends State<_JournalCover> {
  final _controller = PageFlipController();
  late final List<Widget> _pages;
  late final String _ownerName;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _ownerName = getIt<GetUser>()().name;
    _pages = [_CoverFace(ownerName: _ownerName), const _JournalEntryPage()];
  }

  void _flip() {
    if (_index >= _pages.length - 1) {
      _controller.goToPage(0);
      setState(() => _index = 0);
    } else {
      _controller.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxWidth / AppConstants.journalAspect;
        // Keep a single page_flip mounted. Its page cache is global, and the
        // home teaser breaks when this offstage copy initializes first.
        final active = TickerMode.of(context);
        if (!active) _index = 0;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.journalRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.journalRadius),
            child: SizedBox(
              width: double.infinity,
              height: h,
              child:
                  active
                      ? Stack(
                        fit: StackFit.expand,
                        children: [
                          PageFlipWidget(
                            controller: _controller,
                            backgroundColor: AppColors.journalCover,
                            duration: AppConstants.pageFlipDuration,
                            onPageFlipped:
                                (page) => setState(() => _index = page),
                            children: _pages,
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: _index > 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: _flip,
                              ),
                            ),
                          ),
                        ],
                      )
                      : _CoverFace(ownerName: _ownerName),
            ),
          ),
        );
      },
    );
  }
}

class _CoverFace extends StatelessWidget {
  const _CoverFace({required this.ownerName});

  final String ownerName;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.journalCover,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Book on a 402-wide screen with the page's 20px side padding.
          final s = constraints.maxWidth / 362;
          return Stack(
            fit: StackFit.expand,
            children: [
              const Image(
                image: AssetImage(AppConstants.journalCover),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                filterQuality: FilterQuality.high,
              ),
              Positioned(
                top: 36 * s,
                left: 95 * s,
                width: 202 * s,
                height: 44 * s,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5 * s),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 11 * s,
                        left: 16 * s,
                        width: 169 * s,
                        height: 21 * s,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${ownerName.toUpperCase()}\u2019S JOURNAL",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: AppConstants.arvo,
                              fontWeight: FontWeight.w700,
                              fontSize: 17 * s,
                              height: 1,
                              letterSpacing: 0,
                              color: AppColors.journalPlate,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _JournalEntryPage extends StatelessWidget {
  const _JournalEntryPage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.journalPage,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ClipRect(
              child: Transform.scale(
                scale: 1.04,
                child: Image(
                  image: AssetImage(AppConstants.journalPage),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 26, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Page 1',
                  style: TextStyle(
                    fontFamily: AppConstants.satoshi,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.2,
                    color: AppColors.journalMuted,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '12th August, 12:35 PM',
                  style: TextStyle(
                    fontFamily: AppConstants.satoshi,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.2,
                    color: AppColors.journalAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A Day To Remember',
                  style: TextStyle(
                    fontFamily: AppConstants.geist,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Today Felt Like A Good Day To Slow Down. I Finally Made Time For Something I Had Been Putting Off For A While To Pause, Breathe, And Simply Enjoy The Moment Without Rushing To The Next Thing....',
                  style: TextStyle(
                    fontFamily: AppConstants.satoshi,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.bodyGray,
                  ),
                ),
                const Spacer(),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [AppColors.journalAccent, AppColors.primary],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          fontFamily: AppConstants.satoshi,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkleDivider extends StatelessWidget {
  const _SparkleDivider();

  @override
  Widget build(BuildContext context) {
    const color = AppColors.monthIdle;
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, size: 8, color: color),
        SizedBox(width: 6),
        Icon(Icons.auto_awesome, size: 12, color: color),
        SizedBox(width: 6),
        Icon(Icons.auto_awesome, size: 8, color: color),
      ],
    );
  }
}

class _MonthChips extends StatefulWidget {
  const _MonthChips();

  @override
  State<_MonthChips> createState() => _MonthChipsState();
}

class _MonthChipsState extends State<_MonthChips> {
  static const _pillWidth = 110.0;
  static const _gap = 12.0;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSelected());
  }

  void _showSelected() {
    if (!mounted || !_controller.hasClients) return;
    final month = context.read<JournalBloc>().state.selectedMonth;
    final index = month - 1;
    final viewport = _controller.position.viewportDimension;
    final target = index * (_pillWidth + _gap) - (viewport - _pillWidth) / 2;
    _controller.jumpTo(target.clamp(0, _controller.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: JournalBloc.months.length,
            separatorBuilder: (_, __) => const SizedBox(width: _gap),
            itemBuilder: (context, index) {
              final month = JournalBloc.months[index];
              final selected = state.selectedMonth == month;
              final label = DateFormat('MMM').format(DateTime(2026, month));
              return Material(
                color: AppColors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(122),
                  onTap:
                      () => context.read<JournalBloc>().add(
                        JournalMonthSelected(month),
                      ),
                  child: Ink(
                    width: _pillWidth,
                    height: 38,
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? AppColors.chipSelected
                              : AppColors.chipIdle,
                      borderRadius: BorderRadius.circular(122),
                      border:
                          selected
                              ? null
                              : Border.all(color: AppColors.chipBorder),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: AppConstants.satoshi,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color:
                              selected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

String _capitalize(String value) {
  return value
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('d').format(entry.date);
    final month = DateFormat('MMM').format(entry.date);
    final weekday = DateFormat('EEE').format(entry.date);

    return Container(
      height: 110,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.entryStart, AppColors.entryEnd],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.entryInner, AppColors.white],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontFamily: AppConstants.geist,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      height: 1,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    month,
                    style: const TextStyle(
                      fontFamily: AppConstants.satoshi,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.1,
                      color: AppColors.journalMuted,
                    ),
                  ),
                  Text(
                    weekday,
                    style: const TextStyle(
                      fontFamily: AppConstants.satoshi,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.2,
                      color: AppColors.journalMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalize(entry.title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppConstants.satoshi,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.snippet,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppConstants.satoshi,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.29,
                      letterSpacing: -0.24,
                      color: AppColors.entryBody,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.timeLabel,
                    style: const TextStyle(
                      fontFamily: AppConstants.satoshi,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.entryHint,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.entryHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
