import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';

class BuyVaultPopUp extends StatelessWidget {
  final Function() connectWallet;

  const BuyVaultPopUp({super.key, required this.connectWallet});

  static void openPopUp({
    required BuildContext context,
    required Function() connectWallet,
  }) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return BuyVaultPopUp(connectWallet: connectWallet);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Adquira seu cofre", style: AppFonts.bodyHeadBold),
          SizedBox(height: 4),
          Text(
            "Conecte sua carteira e realize a confirmação da transação para habilitar o seu cofre",
            style: AppFonts.bodySmallRegular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          PillButtonWidget(
            onTap: () {
              connectWallet.call();
            },
            text: "Conectar carteira",
          ),
        ],
      ),
    );
  }
}
