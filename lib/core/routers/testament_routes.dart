import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/core/routers/transitions.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_view.dart';
import 'package:tcc/ui/features/heir/request_vault/request_vault_view.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/see_details_inheritance_view.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/vault/vault_view.dart';

abstract class TestamentRoutes {
  static List<RouteBase> testamentRoutes = [
    GoRoute(
      path: RouterApp.seeDetailsInheritance,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final params =
            state.extra as Map<String, dynamic>? ?? <String, dynamic>{};
        final testament = params['testament'] as RequestInheritanceModel;
        final typeUser =
            params['typeUser'] as EnumTypeUser? ?? EnumTypeUser.heir;
        return Transitions.customTransitionPage(
          SeeDetailsInheritanceView(testament: testament, typeUser: typeUser),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.requestInheritance,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final inheritance = state.extra as RequestInheritanceModel;
        return Transitions.customTransitionPage(
          RequestInheritanceView(inheritance: inheritance),
          state,
        );
      },
    ),
    GoRoute(
      path: RouterApp.requestVault,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final extra = state.extra;
        RequestInheritanceModel? inheritance;
        if (extra is RequestInheritanceModel) {
          inheritance = extra;
        } else if (extra is Map<String, dynamic>) {
          final maybe = extra['inheritance'];
          if (maybe is RequestInheritanceModel) {
            inheritance = maybe;
          }
        }
        return Transitions.customTransitionPage(
          RequestVaultView(inheritance: inheritance),
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
