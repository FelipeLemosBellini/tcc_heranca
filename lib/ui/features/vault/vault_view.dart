import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/update_vault.dart';
import 'package:tcc/core/helpers/bigint_extensions.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/vault/vault_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/refresh_indicator_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class VaultView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const VaultView({super.key, required this.flowTestamentEnum});

  @override
  State<VaultView> createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  final VaultController vaultController = GetIt.I.get<VaultController>();
  final FocusNode _amountFocus = FocusNode();
  final EventBus eventBus = GetIt.I.get<EventBus>();

  final TextEditingController _amountCtl = TextEditingController();

  bool disableButton = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.flowTestamentEnum == FlowTestamentEnum.deposit) {
        await vaultController.getWalletBalance();
        await vaultController.getWalletBalance();
      } else {
        await vaultController.getVaultBalance();
      }
    });
    super.initState();

    _amountCtl.addListener(() {
      setState(() {
        BigInt digitedValue = BigInt.tryParse(_amountCtl.text) ?? BigInt.zero;
        disableButton =
            digitedValue > vaultController.balance ||
            digitedValue == BigInt.zero;
      });
    });
  }

  @override
  void dispose() {
    _amountFocus.dispose();
    _amountCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorWidget(
      onRefresh: () async {
        vaultController.getWalletBalance();
      },
      child: ListenableBuilder(
        listenable: vaultController,
        builder: (context, _) {
          return LoadingAndAlertOverlayWidget(
            isLoading: vaultController.isLoading,
            alertData: vaultController.alertData,
            child: Scaffold(
              appBar: AppBarSimpleWidget(
                title:
                    widget.flowTestamentEnum == FlowTestamentEnum.deposit
                        ? "Depositar"
                        : "Sacar",
                onTap: () {
                  context.pop();
                },
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        widget.flowTestamentEnum == FlowTestamentEnum.deposit
                            ? 'Saldo atual da sua carteira:'
                            : 'Saldo atual do cofre',
                        style: AppFonts.bodyLargeMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // '${widget.flowTestamentEnum == FlowTestamentEnum.deposit ? '10' : '15'} ETH',
                        "${vaultController.balance.weiToEth()} ETH",
                        style: AppFonts.bodySmallMedium,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        widget.flowTestamentEnum == FlowTestamentEnum.deposit
                            ? 'Adicionar saldo ao cofre'
                            : 'Sacar do cofre',
                        style: AppFonts.bodyLargeBold,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldWidget(
                                  controller: _amountCtl,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  focusNode: _amountFocus,
                                  hintText: 'Quantidade em wei',
                                  onlyNumber: true,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _amountCtl.text =
                                        vaultController.balance.toString();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary3,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(6),
                                    margin: EdgeInsets.only(
                                      left: 4,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      "Adicionar tudo",
                                      style: AppFonts.bodySmallMedium,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Valor em ETH: ${BigInt.parse(_amountCtl.text.isEmpty ? "0" : _amountCtl.text).weiToEth()}",
                                  style: AppFonts.bodySmallMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary3,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'WEI',
                              style: AppFonts.bodyMediumMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              bottomSheet: SafeArea(
                child: ElevatedButtonWidget(
                  inverterColor: disableButton,
                  text:
                      widget.flowTestamentEnum == FlowTestamentEnum.deposit
                          ? "Depositar"
                          : "Sacar",
                  onTap: () async {
                    if (disableButton) return;

                    widget.flowTestamentEnum == FlowTestamentEnum.deposit
                        ? vaultController.deposit(BigInt.parse(_amountCtl.text))
                        : _withdraw();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _withdraw() async {
    var response = await vaultController.withdraw(
      BigInt.parse(_amountCtl.text),
    );
    if (response) {
      _amountCtl.clear();
      vaultController.getVaultBalance();
      eventBus.fire(UpdateVault());
    }
  }
}
