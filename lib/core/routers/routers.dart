import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/admin_routes.dart';
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
  static const String kycStep = "/kycStep";

  static const String summary = "/summary";

  static const String listUsers = "/listUsers";
  static const String listUserTestators = "/listUserTestators";
  static const String listDocuments = "/listDocuments";

  static const String seeDetails = "/seeDetails";

  static const String home = "/home";
  static const String aboutUs = "/aboutUs";

  static const String vault = "/vault";

  static const String requestVault = "/requestVault";
  static const String requestInheritance = "/requestInheritance";

  static final GoRouter router = GoRouter(
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
          ...AdminRoutes.adminRoutes,


          GoRoute(
            path: loginWallet,
            pageBuilder: (context, state) {
              return Transitions.customTransitionPage(LoginWalletView(), state);
            },
          ),
          GoRoute(
            path: materialDesign,
            pageBuilder: (context, state) {
              return Transitions.customTransitionPage(
                MaterialDesignView(),
                state,
              );
            },
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<User?> stream) {
    _sub = stream.asBroadcastStream().listen((User? user) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
