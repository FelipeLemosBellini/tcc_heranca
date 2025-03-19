import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/validators.dart';
import 'package:tcc/ui/features/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  ForgotPasswordController controller = GetIt.instance.get<ForgotPasswordController>();

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Stack(
            children: [
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage("assets/backgrounds/background.png",),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: new Container(
                    decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              // DecoratedBox(decoration:BoxDecoration(border: ),child: Image.asset(, fit: BoxFit.cover)),

              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(color: AppColors.titleView, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        hintText: "Digite seu email",
                        focusNode: emailFocus,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                bottomSheet: ElevatedButtonWidget(text: "Enviar email", onTap: () => sendEmail(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  void sendEmail(BuildContext context) async {
    if (Validators.isValidEmail(emailController.text)) {
      bool success = await controller.sendEmailToResetPassword(emailController.text);

      if (success) {
        controller.setMessage(AlertData(message: "Email enviado com sucesso", errorType: ErrorType.success));
        context.pop();
      }
    } else {
      controller.setMessage(AlertData(message: "Email inválido", errorType: ErrorType.warning));
    }
  }
}
