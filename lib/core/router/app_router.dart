import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/insights/presentation/bloc/insights_bloc.dart';
import '../../features/journal/presentation/bloc/journal_bloc.dart';
import '../../features/goals/presentation/goals_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/insights/presentation/insights_page.dart';
import '../../features/journal/presentation/journal_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/splash/presentation/splash_page.dart';
import 'app_routes.dart';
import 'route_error_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create({bool showSplashOnLaunch = false}) {
    final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      restorationScopeId: 'lumina-router',
      debugLogDiagnostics: kDebugMode,
      initialLocation: showSplashOnLaunch ? AppRoutes.splash : AppRoutes.home,
      redirect: (context, state) {
        if (state.uri.path == '/') {
          return showSplashOnLaunch ? AppRoutes.splash : AppRoutes.home;
        }
        return null;
      },
      errorBuilder: (context, state) => const RouteErrorPage(),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: AppRouteNames.splash,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            return SplashPage(
              onFinished: () {
                if (context.mounted) context.go(AppRoutes.home);
              },
            );
          },
        ),
        StatefulShellRoute.indexedStack(
          restorationScopeId: 'lumina-shell',
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            _branch(
              tab: AppTab.home,
              path: AppRoutes.home,
              name: AppRouteNames.home,
              builder:
                  (context, state) => BlocProvider(
                    create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
                    child: const HomePage(),
                  ),
            ),
            _branch(
              tab: AppTab.goals,
              path: AppRoutes.goals,
              name: AppRouteNames.goals,
              builder: (context, state) => const GoalsPage(),
            ),
            _branch(
              tab: AppTab.journal,
              path: AppRoutes.journal,
              name: AppRouteNames.journal,
              builder:
                  (context, state) => BlocProvider(
                    create:
                        (_) =>
                            getIt<JournalBloc>()..add(const JournalStarted()),
                    child: const JournalPage(),
                  ),
            ),
            _branch(
              tab: AppTab.insights,
              path: AppRoutes.insights,
              name: AppRouteNames.insights,
              builder:
                  (context, state) => BlocProvider(
                    create:
                        (_) =>
                            getIt<InsightsBloc>()..add(const InsightsStarted()),
                    child: const InsightsPage(),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellBranch _branch({
    required AppTab tab,
    required String path,
    required String name,
    required GoRouterWidgetBuilder builder,
  }) {
    return StatefulShellBranch(
      navigatorKey: GlobalKey<NavigatorState>(debugLabel: tab.name),
      restorationScopeId: 'tab-${tab.name}',
      routes: [GoRoute(path: path, name: name, builder: builder)],
    );
  }
}
