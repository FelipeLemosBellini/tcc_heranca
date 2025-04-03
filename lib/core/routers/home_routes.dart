import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/home/home_view.dart';

abstract class HomeRoutes {

  static List<RouteBase> homeRoutes = [
    GoRoute(
      path: RouterApp.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
    ),
  ];
}
