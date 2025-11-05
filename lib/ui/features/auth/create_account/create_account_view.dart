import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/validators.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  CreateAccountController controller =
      GetIt.instance.get<CreateAccountController>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode repeatPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Scaffold(
            appBar: AppBarSimpleWidget(
              onTap: () {
                context.pop();
              },
              title: "Criar conta",
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                      hintText: "Digite o seu nome",
                      controller: nameController,
                      focusNode: nameFocus,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      hintText: "Digite o seu melhor email",
                      controller: emailController,
                      focusNode: emailFocus,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      hintText: "Crie uma senha",
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      hintText: "Digite a senha novamente",
                      controller: repeatPasswordController,
                      focusNode: repeatPasswordFocus,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: ElevatedButtonWidget(
              onTap: () => register(context),
              text: "Próximo",
            ),
          ),
        );
      },
    );
  }

  void register(BuildContext context) async {
    if (passwordController.text != repeatPasswordController.text) {
      controller.setMessage(
        AlertData(
          message: "As senhas precisam ser iguais",
          errorType: ErrorType.warning,
        ),
      );
      return;
    }

    if (nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        Validators.isValidEmail(emailController.text)) {
      bool successCreateAccount = await controller.createAccount(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      if (successCreateAccount) {
        print("successCreateAccount");
        // context.go(RouterApp.kycStep);
      }
    } else {
      controller.setMessage(
        AlertData(message: "Preencha os campos!", errorType: ErrorType.warning),
      );
    }
  }
}
