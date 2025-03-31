import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/create_account/create_account_view.dart';
import 'package:tcc/ui/features/forgot_password/forgot_password_view.dart';
import 'package:tcc/ui/features/home/home_view.dart';
import 'package:tcc/ui/features/login/login_view.dart';
import 'package:tcc/ui/features/new_testament/address/address_step_view.dart';
import 'package:tcc/ui/features/new_testament/amount/amount_step_view.dart';
import 'package:tcc/ui/features/new_testament/prove_of_life/prove_of_life_step_view.dart';
import 'package:tcc/ui/features/new_testament/summary/summary_view.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_view.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_view.dart';

abstract class RouterApp {
  static const String login = "/";
  static const String materialDesign = "/materialDesign";
  static const String createAccount = "/createAccount";
  static const String forgotPassword = "/forgotPassword";
  static const String home = "/home";
  static const String seeDetails = "/seeDetails";
  static const String amountStep = "/amountStep";
  static const String addressStep = "/addressStep";
  static const String proofOfLifeStep = "/proofOfLifeStep";
  static const String summary = "/summary";


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
          GoRoute(
            path: materialDesign,
            pageBuilder: (context, state) {
              return customTransitionPage(MaterialDesignView(), state);
            },
          ),
          GoRoute(
            path: forgotPassword,
            pageBuilder: (context, state) {
              return customTransitionPage(ForgotPasswordView(), state);
            },
          ),
          GoRoute(
            path: createAccount,
            pageBuilder: (context, state) {
              return customTransitionPage(CreateAccountView(), state);
            },
          ),
          GoRoute(
            path: home,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeView();
            },
          ),
          GoRoute(
            path: amountStep,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customTransitionPage(AmountStepView(), state);
            },
          ),
          GoRoute(
            path: addressStep,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customTransitionPage(AddressStepView(), state);
            },
          ),
          GoRoute(
            path: proofOfLifeStep,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customTransitionPage(ProveOfLifeStepView(), state);
            },
          ),
          GoRoute(
            path: summary,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customTransitionPage(SummaryView(), state);
            },
          ),
          GoRoute(
            path: seeDetails,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customTransitionPage(
                SeeDetailsView(testamentModel: state.extra as TestamentModel),
                state
              );
            },
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<dynamic> customTransitionPage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: ValueKey(state.uri.path), // Usa a rota atual como chave única
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Detecta se está avançando ou voltando
      bool isPushing = state.fullPath == state.uri.path;

      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: isPushing ? const Offset(1, 0) : const Offset(-1, 0), // Direita para esquerda ou esquerda para direita
            end: Offset.zero, // Vai para o centro
          ).chain(CurveTween(curve: Curves.easeInOut)), // Suaviza a animação
        ),
        child: child,
      );
    },
  );
}
