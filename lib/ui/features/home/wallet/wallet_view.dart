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

  @override
  void initState() {
    super.initState();

    // Carregar endereço async e depois chamar setState
    walletController.loadUser();
  }

  final List<AssetModel> myAssets = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicatorWidget(
      onRefresh: walletController.loadUser,
      child: ListenableBuilder(
        listenable: walletController,
        builder:
            (context, _) => ListView(
              shrinkWrap: true,
              children: [
                CardWalletWidget(
                  addressUser: walletController.userModel?.address ?? "",
                  balanceETH:
                      walletController.userModel?.balance == null
                          ? "Loading..."
                          : "${walletController.userModel?.balance} ETH",
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
