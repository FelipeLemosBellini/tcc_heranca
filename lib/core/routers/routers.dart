import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/auth_routes.dart';
import 'package:tcc/core/routers/home_routes.dart';
import 'package:tcc/core/routers/testament_routes.dart';
import 'package:tcc/core/routers/testator_routes.dart';
import 'package:tcc/core/routers/transitions.dart';
import 'package:tcc/ui/features/auth/login/login_view.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_view.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_view.dart';

abstract class RouterApp {
  static const String login = "/";
  static const String loginWallet = "/loginWallet";
  static const String materialDesign = "/materialDesign";

  static const String createAccount = "/createAccount";
  static const String forgotPassword = "/forgotPassword";

  static const String amountStep = "/amountStep";
  static const String addressStep = "/addressStep";
  static const String proofOfLifeStep = "/proofOfLifeStep";
  static const String summary = "/summary";

  static const String seeDetails = "/seeDetails";

  static const String home = "/home";
  static const String aboutUs = "/aboutUs";

  static final GoRouter router = GoRouter(
    // redirect: (BuildContext context, GoRouterState state) async {
    //   User? user = FirebaseAuth.instance.currentUser;
    //   final bool isLoggedIn = user != null;
    //
    //   //allowed routes
    //   List<String> allowedRoutes = [login, createAccount, forgotPassword];
    //
    //   // if is not logged in go to allowedRoutes
    //   if (!isLoggedIn && !allowedRoutes.contains(state.topRoute?.path)) {
    //     return login;
    //   }
    //
    //   //if is logged in go to home
    //   if (isLoggedIn && state.topRoute?.path == login) {
    //     return home;
    //   }
    //
    //   // go to any page if logged in
    //   return null;
    // },
    routes: <RouteBase>[
      GoRoute(
        path: login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
        routes: <RouteBase>[
          ...AuthRoutes.authRoutes,
          ...HomeRoutes.homeRoutes,
          ...TestamentRoutes.testamentRoutes,
          ...TestatorRoutes.testatorRoutes,
          GoRoute(
            path: loginWallet,
            pageBuilder: (context, state) {
              return Transitions.customTransitionPage(LoginWalletView(), state);
            },
          ),GoRoute(
            path: materialDesign,
            pageBuilder: (context, state) {
              return Transitions.customTransitionPage(MaterialDesignView(), state);
            },
          ),
        ],
      ),
    ],
  );
}
