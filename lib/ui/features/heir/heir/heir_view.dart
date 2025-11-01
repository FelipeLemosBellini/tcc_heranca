import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_event.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/heir/heir/heir_controller.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';
import 'package:tcc/ui/widgets/cards/card_testament_info_widget.dart';
import 'package:tcc/ui/widgets/empty_list_widgets/empty_list_testament_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/refresh_indicator_widget.dart';

class HeirView extends StatefulWidget {
  const HeirView({super.key});

  @override
  State<HeirView> createState() => _HeirViewState();
}

class _HeirViewState extends State<HeirView>
    with AutomaticKeepAliveClientMixin {
  HeirController heirController = GetIt.I.get<HeirController>();
  final EventBus eventBus = GetIt.I.get<EventBus>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      heirController.loadingTestaments();
      eventBus.on<TestamentEvent>().listen((event) {
        heirController.loadingTestaments();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicatorWidget(
      onRefresh: () async => heirController.loadingTestaments(),
      child: ListenableBuilder(
        listenable: heirController,
        builder: (context, _) {
          return LoadingAndAlertOverlayWidget(
            isLoading: heirController.isLoading,
            alertData: heirController.alertData,
            child: Visibility(
              visible: heirController.listTestament.isNotEmpty,
              replacement: EmptyListTestamentWidget(
                text: 'Crie um processo de sucessão',
                onTap: heirController.loadingTestaments,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: heirController.listTestament.length,
                itemBuilder: (context, index) {
                  final testament = heirController.listTestament[index];
                  final bottomPadding =
                      heirController.listTestament.length - 1 == index ? 64.0 : 16.0;
                  final status = testament.heirStatus;
                  final canRequestInheritance =
                      status == HeirStatus.consultaSaldoAprovado;
                  final isFinished = status == HeirStatus.transferenciaSaldoRealizada;

                  return Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardTestamentInfoWidget(
                          testament: testament,
                          seeDetails: () {
                            context.push(
                              RouterApp.seeDetailsInheritance,
                              extra: {
                                "testament": testament,
                                "typeUser": EnumTypeUser.heir,
                              },
                            );
                          },
                        ),
                        if (canRequestInheritance) ...[
                          const SizedBox(height: 12),
                          PillButtonWidget(
                            text: 'Enviar documentos da herança',
                            showArrow: true,
                            onTap: () {
                              context.push(
                                RouterApp.requestInheritance,
                                extra: testament,
                              );
                            },
                          ),
                        ] else if (isFinished) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.green.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Processo finalizado',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Colors.green.shade700),
                                ),
                              ],
                            ),
                          ),
                        ] else if (status == HeirStatus.transferenciaSaldoRecusado) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Transferência recusada',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Colors.red.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
