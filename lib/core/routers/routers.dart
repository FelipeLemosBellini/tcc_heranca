import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  static const String completedProcesses = "/completedProcesses";
  static const String listUserTestators = "/listUserTestators";
  static const String listDocuments = "/listDocuments";

  static const String seeDetailsInheritance = "/seeDetailsInheritance";

  static const String home = "/home";
  static const String aboutUs = "/aboutUs";

  static const String vault = "/vault";

  static const String requestVault = "/requestVault";
  static const String requestInheritance = "/requestInheritance";

  static final SupabaseClient _supabase = Supabase.instance.client;

  static final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(_supabase.auth.onAuthStateChange),
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final session = _supabase.auth.currentSession;
      // Rotas públicas (auth/entrada)
      final isAuthRoute = [
        login,
        createAccount,
        forgotPassword,
      ].contains(goingTo);

      if (session == null) {
        return login;
      }
      if ((isAuthRoute) && goingTo != home) {
        return home;
      }
      return null;
    },
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
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
