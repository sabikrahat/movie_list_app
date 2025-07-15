import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/view/home.dart';
import '../../features/settings/view/setting_view.dart';
import '../shared/page_not_found/page_not_found.dart';
import '../utils/logger/logger_helper.dart';
import 'app_routes.dart';

final goNavigatorKey = GlobalKey<NavigatorState>();

bool isMaintenanceBreak = false;

final GoRouter goRouter = GoRouter(
  // debugLogDiagnostics: !kReleaseMode,
  initialLocation: AppRoutes.homeRoute,
  errorBuilder: (_, _) => const KPageNotFound(error: '404 - Page not found!'),
  navigatorKey: goNavigatorKey,
  routes: <RouteBase>[
    GoRoute(path: AppRoutes.homeRoute, name: HomeView.name, builder: (_, _) => const HomeView()),
    GoRoute(
      path: AppRoutes.settingsRoute,
      name: SettingsView.name,
      builder: (_, _) => const SettingsView(),
    ),
  ],
  redirect: (context, state) {
    final path = '/${state.fullPath?.split('/').last.toLowerCase()}';
    log.f('Path: $path');
    return null;
  },
);
