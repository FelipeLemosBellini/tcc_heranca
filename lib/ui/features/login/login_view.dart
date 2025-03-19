import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/validators.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/pill_button_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

import 'login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController controller = GetIt.I.get<LoginController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder:
          (_, __) => LoadingAndAlertOverlayWidget(
            isLoading: controller.isLoading,
            alertData: controller.alertData,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(flex: 1),
                      Icon(Icons.psychology, size: MediaQuery.sizeOf(context).width * 0.3, color: AppColors.navyBlue),
                      const Spacer(flex: 1),
                      TextFieldWidget(
                        hintText: "Digite seu email",
                        controller: emailController,
                        focusNode: emailFocus,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        hintText: "Digite sua senha",
                        controller: passwordController,
                        focusNode: passwordFocus,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PillButtonWidget(onTap: () => context.go(RouterApp.createAccount), text: "Criar conta"),
                            GestureDetector(
                              onTap: () => context.go(RouterApp.forgotPassword),
                              child: const Text(
                                "Esqueci minha senha",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
              bottomSheet: ElevatedButtonWidget(onTap: () => login(context), text: "Entrar"),
            ),
          ),
    );
  }

  void login(BuildContext context) async {
    if (Validators.isValidEmail(emailController.text) && passwordController.text.isNotEmpty) {
      bool successLogin = await controller.login(emailController.text, passwordController.text);

      if (successLogin) {
        context.go(RouterApp.home);
      }
    } else {
      controller.setMessage(AlertData(message: "Preencha os campos", errorType: ErrorType.warning));
    }
  }
}
