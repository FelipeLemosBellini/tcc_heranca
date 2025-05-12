import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_controller.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class LoginWalletView extends StatefulWidget {
  const LoginWalletView({super.key});

  @override
  State<LoginWalletView> createState() => _LoginWalletViewState();
}

class _LoginWalletViewState extends State<LoginWalletView> {
  LoginWalletController controller = GetIt.I.get<LoginWalletController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 32,
                      left: 24,
                      right: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Bem vindo ao Ethernium",
                          style: AppFonts.bodyHeadBold,
                        ),
                        Text(
                          "Sua plataforma descentralizada de sucessão de criptomoedas",
                          style: AppFonts.bodyLargeRegular,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButtonWidget(onTap: () {}, text: "Entrar"),
                ],
              ),
            ),
            bottomSheet: SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
