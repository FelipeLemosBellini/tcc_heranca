import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:reown_appkit/modal/widgets/buttons/primary_button.dart';
import 'package:tcc/core/enum/connect_state_blockchain.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/features/testator/testator/widget/buy_vault_pop_up.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/refresh_indicator_widget.dart';

import '../../../widgets/buttons/elevated_button_widget.dart';

class TestatorView extends StatefulWidget {
  const TestatorView({super.key});

  @override
  State<TestatorView> createState() => _TestatorViewState();
}

class _TestatorViewState extends State<TestatorView>
    with AutomaticKeepAliveClientMixin {
  final TestatorController testatorController =
      GetIt.I.get<TestatorController>();
  final EventBus eventBus = GetIt.I.get<EventBus>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testatorController.init();
    });

    super.initState();
  }

  @override
  void dispose() {
    testatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicatorWidget(
      onRefresh: () async {},
      child: ListenableBuilder(
        listenable: testatorController,
        builder: (context, _) {
          return LoadingAndAlertOverlayWidget(
            isLoading: testatorController.isLoading,
            alertData: testatorController.alertData,
            child: Stack(
              children: [
                if (testatorController.state == ConnectStateBlockchain.idle)
                  Center(
                    child: ElevatedButtonWidget(
                      text: "Conectar carteira",
                      onTap: () {},
                    ),
                  ),
                if (testatorController.state ==
                        ConnectStateBlockchain.connected &&
                    testatorController.hasVault == null &&
                    !testatorController.isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Não foi possível verificar seu cofre, tente novamente',
                        textAlign: TextAlign.center,
                        style: AppFonts.bodyMediumRegular,
                      ),
                    ),
                  ),
                if (testatorController.state ==
                        ConnectStateBlockchain.connected &&
                    testatorController.hasVault == false)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bem vindo a área do cofre",
                          style: AppFonts.bodyHeadBold,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Para começar a usar nossa plataforma você precisa adquirir um cofre, vamos armazenar seu Ethereum dentro de um contrato inteligente para que no futuro ele possa ser solicitado por seus sucessores.",
                          textAlign: TextAlign.center,
                          style: AppFonts.bodyMediumRegular,
                        ),
                        SizedBox(height: 16),
                        ElevatedButtonWidget(
                          text: "Criar Cofre",
                          padding: EdgeInsets.zero,
                          onTap: () {
                            BuyVaultPopUp.openPopUp(
                              context: context,
                              connectWallet: () {},
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                if (testatorController.state ==
                        ConnectStateBlockchain.connected &&
                    testatorController.hasVault == true)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Seu saldo atual:", style: AppFonts.bodyHeadBold),
                        SizedBox(height: 4),
                        Text("0.4 ETH", style: AppFonts.bodyLargeMedium),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ElevatedButtonThematicWidget(
                                text: "Depositar",
                                onTap: () {
                                  context.push(
                                    RouterApp.vault,
                                    extra: FlowTestamentEnum.deposit,
                                  );
                                },
                                thematicEnum: ThematicButtonEnum.green,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButtonThematicWidget(
                                text: "Sacar",
                                onTap: () {
                                  context.push(
                                    RouterApp.vault,
                                    extra: FlowTestamentEnum.withdrawal,
                                  );
                                },
                                thematicEnum: ThematicButtonEnum.blue,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
