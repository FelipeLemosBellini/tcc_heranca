import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_event.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // testatorController.loadingTestaments();
    //
    // eventBus.on<TestamentEvent>().listen((event) {
    //   testatorController.loadingTestaments();
    // });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicatorWidget(
      onRefresh: () async => testatorController.loadingTestaments(),
      child: ListenableBuilder(
        listenable: testatorController,
        builder: (context, _) {
          return LoadingAndAlertOverlayWidget(
            isLoading: testatorController.isLoading,
            alertData: testatorController.alertData,
            child: Stack(
              children: [
                Visibility(
                  visible: testatorController.listTestament.isNotEmpty,
                  child: ListView.builder(
                    itemCount: testatorController.listTestament.length,
                    padding: const EdgeInsets.all(24.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {},
                  ),
                ),

                if (testatorController.listTestament.isEmpty)
                  Center(
                    child: SizedBox(
                      width: 240,
                      child: ElevatedButtonWidget(
                        text: "Criar Cofre",
                        onTap:
                            () => {
                              context.push(
                                RouterApp.vault,
                                extra: FlowTestamentEnum.creation,
                              ),
                            },
                      ),
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
