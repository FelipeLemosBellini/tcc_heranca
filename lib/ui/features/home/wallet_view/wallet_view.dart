import 'package:flutter/material.dart';
import 'package:tcc/core/models/asset_model.dart';
import 'package:tcc/ui/features/home/widgets/card_wallet_widget.dart';

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
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
    AssetModel(name: "Polygon", amount: 1.23, ticker: "POL"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        CardWalletWidget(addressUser: addressUser, balanceETH: balanceETH.toString()),
        ListView.builder(
          shrinkWrap: true,
          itemCount: myAssets.length,
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ],
    );
  }
}
