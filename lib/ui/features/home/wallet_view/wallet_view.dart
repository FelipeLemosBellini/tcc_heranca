import 'package:flutter/material.dart';
import 'package:tcc/core/models/asset_model.dart';
import 'package:tcc/ui/features/home/widgets/card_wallet_widget.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final String addressUser = "0x1234...ABCD";

  final double balanceETH = 2.345;

  final List<AssetModel> myAssets = [
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Arbitrum", amount: 1.23, ticker: "ARB"),
    AssetModel(name: "Pendle", amount: 1.23, ticker: "PENDLE"),
    AssetModel(name: "Aave", amount: 1.23, ticker: "AAVE"),
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Arbitrum", amount: 1.23, ticker: "ARB"),
    AssetModel(name: "Pendle", amount: 1.23, ticker: "PENDLE"),
    AssetModel(name: "Aave", amount: 1.23, ticker: "AAVE"),
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Arbitrum", amount: 1.23, ticker: "ARB"),
    AssetModel(name: "Pendle", amount: 1.23, ticker: "PENDLE"),
    AssetModel(name: "Aave", amount: 1.23, ticker: "AAVE"),
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Arbitrum", amount: 1.23, ticker: "ARB"),
    AssetModel(name: "Pendle", amount: 1.23, ticker: "PENDLE"),
    AssetModel(name: "Aave", amount: 1.23, ticker: "AAVE"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        CardWalletWidget(addressUser: addressUser, balanceETH: balanceETH.toString()),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: myAssets.length,
          padding: EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: AppColors.gray2, size: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(myAssets[index].name, style: AppFonts.labelMediumMedium),
                  ),

                  const Spacer(),
                  Text("${myAssets[index].amount} ", style: AppFonts.labelMediumLight),
                  Text(myAssets[index].ticker, style: AppFonts.labelMediumLight),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ],
    );
  }
}
