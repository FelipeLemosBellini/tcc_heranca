import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/features/create_account/create_account_view.dart';
import 'package:tcc/ui/features/forgot_password/forgot_password_view.dart';
import 'package:tcc/ui/features/home/home_view.dart';
import 'package:tcc/ui/features/login/login_view.dart';

abstract class RouterApp {
  static const String login = "/";
  static const String createAccount = "/createAccount";
  static const String forgotPassword = "/forgotPassword";
  static const String home = "/home";

  static final GoRouter router = GoRouter(
    initialLocation: home,
   /* redirect: (BuildContext context, GoRouterState state) async {*/

      /*User? user = FirebaseAuth.instance.currentUser;
      final bool isLoggedIn = user != null;

      //allowed routes
      List<String> allowedRoutes = [login, createAccount, forgotPassword];

      // if is not logged in go to allowedRoutes
      if (!isLoggedIn && !allowedRoutes.contains(state.topRoute?.path)) {
        return login;
      }

      //if is logged in go to home
      if (isLoggedIn && state.topRoute?.path == login) {
        return home;
      }

      // go to any page if logged in
      return null;*/
    routes: <RouteBase>[
      GoRoute(
        path: login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: forgotPassword,
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordView();
            },
          ),
          GoRoute(
            path: createAccount,
            builder: (BuildContext context, GoRouterState state) {
              return const CreateAccountView();
            },
          ),

          GoRoute(
            path: home,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeView();
            },
          ),
        ],
      ),
    ],
  );
}

// '/': (context) => //const RegisterView(),
// const MyHomePage(title: 'RPD'),
// '/register': (context) => const CreateAccountView(),
// '/forgotPassword': (context) => const ForgotPasswordView(),
// '/thought': (context) => const ThoughtScreen(),
