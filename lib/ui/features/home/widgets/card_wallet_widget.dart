import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        color: AppColors.primary,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.primaryLight4,
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Endereço da Carteira", style: AppFonts.labelMediumMedium),
                      Row(
                        children: [
                          Text(
                            addressUser,

                            style: AppFonts.labelSmallMedium.copyWith(color: AppColors.gray3),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              print("copy address");
                            },
                            icon: Icon(Icons.copy, color: AppColors.white, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary6,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                          "https://worldvectorlogo.com/download/ethereum-eth.svg",
                          placeholderBuilder: (_) {
                            return Icon(
                              Icons.monetization_on,
                              color: AppColors.primaryLight2,
                              size: 32,
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.primaryLight2),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Divider(color: AppColors.white),
              ),
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.visibility, color: AppColors.gray3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
