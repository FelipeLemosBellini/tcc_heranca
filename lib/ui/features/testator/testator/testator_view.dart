import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_event.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/features/testator/testator/widget/buy_vault_pop_up.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';
import 'package:tcc/ui/widgets/cards/card_testament_info_widget.dart';
import 'package:tcc/ui/widgets/empty_list_widgets/empty_list_testament_widget.dart';
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
      testatorController.getBalance();
    });

    super.initState();
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
                if (testatorController.balance == 0)
                  Center(
                    child: ElevatedButtonWidget(
                      text: "Criar Cofre",
                      onTap: () {
                        BuyVaultPopUp.openPopUp(
                          context: context,
                          connectWallet: () {},
                        );
                      },
                    ),
                  ),
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
