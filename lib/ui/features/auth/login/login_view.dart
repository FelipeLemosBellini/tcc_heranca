import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/assets/ethernium_svg_assets.dart';
import 'package:tcc/core/enum/kyc_status.dart';
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

  TextEditingController emailController = TextEditingController(text: "a@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "@Abc1234");

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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
                      Image.asset(
                      'assets/images/ethernium-logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                      ),
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
                              child: Text(
                                "Esqueci minha senha",
                                style: AppFonts.labelMediumMedium,
                              ),
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
                  /*ElevatedButtonWidget(
                    onTap: () => context.push(RouterApp.materialDesign),
                    text: "material design",
                  ),*/
                  ElevatedButtonWidget(
                    onTap: () => login(context),
                    text: "Entrar",
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void login(BuildContext context) async {
    if (Validators.isValidEmail(emailController.text) &&
        passwordController.text.isNotEmpty) {
      LoginSuccess loginSuccess = await controller.login(
        emailController.text,
        passwordController.text,
      );
      if (loginSuccess.isAdmin == true) {
        context.go(RouterApp.listUsers);
        return;
      }
      if (loginSuccess.kycStatus != null) {
        switch (loginSuccess.kycStatus) {
          case KycStatus.rejected:
          case KycStatus.waiting:
            context.go(RouterApp.kycStep);
          case KycStatus.approved:
            context.go(RouterApp.home);
          case KycStatus.submitted:
          default:
            controller.setMessage(
              AlertData(
                message: "Seus documentos estão sendo validados",
                errorType: ErrorType.warning,
              ),
            );
        }
      }
    } else {
      controller.setMessage(
        AlertData(message: "Preencha os campos", errorType: ErrorType.warning),
      );
    }
  }
}
