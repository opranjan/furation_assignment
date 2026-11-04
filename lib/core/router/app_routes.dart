/// Bottom-nav tabs.
enum AppTab { home, goals, journal, insights }

/// Path and name constants. Add a screen here before registering its route.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const goals = '/goals';
  static const journal = '/journal';
  static const insights = '/insights';

  static const shell = [home, goals, journal, insights];

  static String of(AppTab tab) => shell[tab.index];
}

abstract final class AppRouteNames {
  static const splash = 'splash';
  static const home = 'home';
  static const goals = 'goals';
  static const journal = 'journal';
  static const insights = 'insights';
}
