import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/core/routers/transitions.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_view.dart';
import 'package:tcc/ui/features/testament/address/address_step_view.dart';
import 'package:tcc/ui/features/testament/amount/amount_step_view.dart';
import 'package:tcc/ui/features/testament/plan/plan_step_view.dart';
import 'package:tcc/ui/features/testament/prove_of_life/prove_of_life_step_view.dart';
import 'package:tcc/ui/features/testament/summary/summary_view.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/vault/vault_view.dart';

abstract class TestamentRoutes {
  static List<RouteBase> testamentRoutes = [
    GoRoute(
      path: RouterApp.amountStep,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          AmountStepView(flowTestamentEnum: state.extra as FlowTestamentEnum),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.addressStep,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          AddressStepView(flowTestamentEnum: state.extra as FlowTestamentEnum),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.proofOfLifeStep,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          ProveOfLifeStepView(
            flowTestamentEnum: state.extra as FlowTestamentEnum,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.summary,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          SummaryView(flowTestamentEnum: state.extra as FlowTestamentEnum),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.planStep,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          PlanStepView(flowTestamentEnum: state.extra as FlowTestamentEnum),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.requestInheritance,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          RequestInheritanceView(),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.vault,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return Transitions.customTransitionPage(
          VaultView(flowTestamentEnum: state.extra as FlowTestamentEnum),
          state,
        );
      },
    ),
  ];
}
