import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/models/asset_model.dart';
import 'package:tcc/ui/features/home/wallet/wallet_controller.dart';
import 'package:tcc/ui/features/home/widgets/card_wallet_widget.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/refresh_indicator_widget.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with AutomaticKeepAliveClientMixin {
  WalletController walletController = GetIt.I.get<WalletController>();

  String? userAddress;
  double? balanceETH;

  @override
  void initState() {
    super.initState();

    // Carregar endereço async e depois chamar setState
    walletController.loadAssets().then((_) async {
      final address = await walletController.getUserAddress();
      setState(() {
        userAddress = address;
        balanceETH = walletController.balance ?? 0.0;
      });
    });
  }

  final List<AssetModel> myAssets = [
    AssetModel(name: "Ether", amount: 1.0, ticker: "ETH"),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicatorWidget(
      onRefresh: walletController.loadAssets,
      child: ListenableBuilder(
        listenable: walletController,
        builder:
            (context, _) => ListView(
              shrinkWrap: true,
              children: [
                CardWalletWidget(
                  addressUser: userAddress ?? "",
                  balanceETH: balanceETH == null ? "Loading..." : "$balanceETH ETH",
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: myAssets.length,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: AppColors.gray2,
                            size: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              myAssets[index].name,
                              style: AppFonts.labelMediumMedium,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${myAssets[index].amount} ",
                            style: AppFonts.labelMediumLight,
                          ),
                          Text(
                            myAssets[index].ticker,
                            style: AppFonts.labelMediumLight,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              ],
            ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
