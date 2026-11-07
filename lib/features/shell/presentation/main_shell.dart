import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'journal_open_overlay.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _openingJournal = false;

  void _select(AppTab tab) {
    if (_openingJournal) return;
    final openingJournal =
        tab == AppTab.journal &&
        widget.navigationShell.currentIndex != AppTab.journal.index;
    if (openingJournal) {
      setState(() => _openingJournal = true);
      widget.navigationShell.goBranch(AppTab.journal.index);
      return;
    }
    widget.navigationShell.goBranch(
      tab.index,
      initialLocation: tab.index == widget.navigationShell.currentIndex,
    );
  }

  void _finishJournalOpen() {
    if (!mounted) return;
    setState(() => _openingJournal = false);
  }

  @override
  Widget build(BuildContext context) {
    final current = AppTab.values[widget.navigationShell.currentIndex];
    return Stack(
      children: [
        Scaffold(
          // Dark so Home Goals sheet 24px top corners aren’t filled by white
          backgroundColor: AppColors.headerBottom,
          body: widget.navigationShell,
          bottomNavigationBar: _BottomNav(current: current, onSelect: _select),
        ),
        if (_openingJournal)
          Positioned.fill(
            child: JournalOpenOverlay(onFinished: _finishJournalOpen),
          ),
      ],
    );
  }
}

/// Flat white bottom bar matching Figma Home.
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottom > 0 ? bottom : 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              _NavItem(
                tab: AppTab.home,
                label: 'Home',
                icon: AppConstants.navHome,
                selected: current == AppTab.home,
                onTap: onSelect,
              ),
              _NavItem(
                tab: AppTab.goals,
                label: 'Goals',
                icon: AppConstants.navGoals,
                selected: current == AppTab.goals,
                onTap: onSelect,
              ),
              _NavItem(
                tab: AppTab.journal,
                label: 'Journal',
                icon: AppConstants.navJournal,
                selected: current == AppTab.journal,
                onTap: onSelect,
              ),
              _NavItem(
                tab: AppTab.insights,
                label: 'Insights',
                icon: AppConstants.navInsights,
                selected: current == AppTab.insights,
                onTap: onSelect,
              ),
            ],
          ),
          Positioned(
            top: -2,
            left: 0,
            right: 0,
            height: 26,
            child: IgnorePointer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const indicatorWidth = 76.0;
                  final slot = constraints.maxWidth / 4;
                  final left =
                      slot * current.index + (slot - indicatorWidth) / 2;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedPositioned(
                        duration: AppConstants.indicatorDuration,
                        curve: Curves.easeOutCubic,
                        left: left,
                        top: 0,
                        width: indicatorWidth,
                        height: 26,
                        child: const Image(
                          image: AssetImage(AppConstants.navIndicator),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String value) {
  return value
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) return word;
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final String label;
  final String icon;
  final bool selected;
  final ValueChanged<AppTab> onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.navIdle;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(tab),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _capitalize(label),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppConstants.geist,
                  fontStyle: FontStyle.normal,
                  fontSize: selected ? 12.25 : 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
