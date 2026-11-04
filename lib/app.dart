import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class LuminaApp extends StatefulWidget {
  const LuminaApp({super.key, this.showSplashOnLaunch = false});

  final bool showSplashOnLaunch;

  @override
  State<LuminaApp> createState() => _LuminaAppState();
}

class _LuminaAppState extends State<LuminaApp> {
  late final GoRouter _router = AppRouter.create(
    showSplashOnLaunch: widget.showSplashOnLaunch,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      restorationScopeId: 'lumina',
      routerConfig: _router,
    );
  }
}
