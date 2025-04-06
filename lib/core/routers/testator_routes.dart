import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/core/routers/transitions.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_view.dart';

abstract class TestatorRoutes {
  static List<RouteBase> testatorRoutes = [
    GoRoute(
      path: RouterApp.seeDetails,
      pageBuilder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return Transitions.customTransitionPage(
          SeeDetailsView(
            testamentModel: data['testament'] as TestamentModel,
            enumTypeUser: data['typeUser'] as EnumTypeUser,
          ),
          state,
        );
      },
    ),
  ];
}
