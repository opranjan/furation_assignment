import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(AppTab tab) {
    navigationShell.goBranch(
      tab.index,
      initialLocation: tab.index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = AppTab.values[navigationShell.currentIndex];
    return Scaffold(
      // Dark so Home Goals sheet 24px top corners aren’t filled by white
      backgroundColor: AppColors.headerBottom,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(current: current, onSelect: _select),
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
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                selected: current == AppTab.home,
                onTap: onSelect,
                showStar: true,
              ),
              _NavItem(
                tab: AppTab.goals,
                label: 'Goals',
                icon: Icons.gps_fixed_rounded,
                selectedIcon: Icons.gps_fixed_rounded,
                selected: current == AppTab.goals,
                onTap: onSelect,
              ),
              _NavItem(
                tab: AppTab.journal,
                label: 'Journal',
                icon: Icons.auto_stories_outlined,
                selectedIcon: Icons.auto_stories_rounded,
                selected: current == AppTab.journal,
                onTap: onSelect,
              ),
              _NavItem(
                tab: AppTab.insights,
                label: 'Insights',
                icon: Icons.auto_awesome_outlined,
                selectedIcon: Icons.auto_awesome,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
    this.showStar = false,
  });

  final AppTab tab;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final ValueChanged<AppTab> onTap;
  final bool showStar;

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
                height: 26,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      selected ? selectedIcon : icon,
                      color: color,
                      size: 24,
                    ),
                    if (showStar && selected)
                      const Positioned(
                        top: -2,
                        right: -10,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 11,
                          color: AppColors.starGold,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.label(
                  size: 11,
                  weight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
