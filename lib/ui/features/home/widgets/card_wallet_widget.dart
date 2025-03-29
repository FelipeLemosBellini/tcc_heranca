import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class CardWalletWidget extends StatelessWidget {
  final String addressUser;
  final String balanceETH;

  const CardWalletWidget({super.key, required this.addressUser, required this.balanceETH});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        color: AppColors.primary6,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Para evitar overflow
            children: [
              Text("Endereço da Carteira", style: AppFonts.labelMediumMedium),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    addressUser,
                    style: AppFonts.labelSmallMedium.copyWith(color: AppColors.gray4),
                  ),
                  IconButton(
                    onPressed: () {
                      print("copy address");
                    },
                    icon: Icon(Icons.copy, color: AppColors.white, size: 16),
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 8, bottom: 16), child: const Divider()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text("Saldo da Conta", style: AppFonts.labelMediumMedium),
                      const SizedBox(height: 8),
                      Text(
                        "$balanceETH ETH",
                        style: AppFonts.labelHeadBold.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.visibility, color: AppColors.gray3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
