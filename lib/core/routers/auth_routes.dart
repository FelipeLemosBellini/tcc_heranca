import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/core/routers/transitions.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_view.dart';
import 'package:tcc/ui/features/auth/forgot_password/forgot_password_view.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_view.dart';

abstract class AuthRoutes {
  static List<RouteBase> authRoutes = [
    GoRoute(
      path: RouterApp.forgotPassword,
      pageBuilder: (context, state) {
        return Transitions.customTransitionPage(ForgotPasswordView(), state);
      },
    ),
    GoRoute(
      path: RouterApp.createAccount,
      pageBuilder: (context, state) {
        return Transitions.customTransitionPage(CreateAccountView(), state);
      },
    ),
    GoRoute(
      path: RouterApp.kycStep,
      pageBuilder:
          (context, state) =>
              Transitions.customTransitionPage(KycView(), state),
    ),
  ];
}
