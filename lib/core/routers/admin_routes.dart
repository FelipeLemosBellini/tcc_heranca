import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_view.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_testators_view.dart';
import 'package:tcc/ui/features/backoffice/list_users/list_users_view.dart';
import 'package:tcc/ui/features/backoffice/completed_processes/completed_processes_view.dart';
import 'package:tcc/ui/features/home/about_us/about_us_view.dart';
import 'package:tcc/ui/features/home/home_view.dart';

abstract class AdminRoutes {

  static List<RouteBase> adminRoutes = [
    GoRoute(
      path: RouterApp.listUsers,
      builder: (BuildContext context, GoRouterState state) {
        return const ListUsersView();
      },
    ),
    GoRoute(
      path: RouterApp.completedProcesses,
      builder: (BuildContext context, GoRouterState state) {
        return const CompletedProcessesView();
      },
    ),
    GoRoute(
      path: RouterApp.listUserTestators,
      builder: (BuildContext context, GoRouterState state) {
        final params = state.extra as Map<String, dynamic>;
        final requesterId = params['userId'] as String;
        final requesterName = params['name'] as String?;
        return ListUserTestatorsView(
          requesterId: requesterId,
          requesterName: requesterName,
        );
      },
    ),
    GoRoute(
      path: RouterApp.listDocuments,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic> params = state.extra as Map<String, dynamic>;
        String userId = params['userId'] as String;
        final String? testatorCpf = params['testatorCpf'] as String?;
        final String? testatorName = params['testatorName'] as String?;
        return ListUserDocumentsView(
          userId: userId,
          testatorCpf: testatorCpf,
          testatorName: testatorName,
        );
      },
    ),
  ];
}
