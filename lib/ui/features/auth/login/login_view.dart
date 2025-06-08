import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/validators.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';
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
  void initState() {
    super.initState();
    emailController.text = "felipe@gmail.com";
    passwordController.text = "@Abc1234";
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder:
          (_, __) => LoadingAndAlertOverlayWidget(
            isLoading: controller.isLoading,
            alertData: controller.alertData,
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E1E2C), Color(0xFF23233A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wallet_travel, size: 80, color: AppColors.primary),
                        const SizedBox(height: 16),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PillButtonWidget(
                              onTap: () => context.go(RouterApp.createAccount),
                              text: "Criar conta",
                            ),
                            GestureDetector(
                              onTap: () => context.go(RouterApp.forgotPassword),
                              child: Text("Esqueci minha senha", style: AppFonts.labelMediumMedium),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomSheet: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButtonWidget(
                    onTap: () => context.push(RouterApp.materialDesign),
                    text: "material design",
                  ),
                  ElevatedButtonWidget(onTap: () => login(context), text: "Entrar"),
                ],
              ),
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
