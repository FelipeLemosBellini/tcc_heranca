import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_created_event.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/widgets/cards/card_testament_info_widget.dart';
import 'package:tcc/ui/widgets/empty_list_widgets/empty_list_testament_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/refresh_indicator_widget.dart';

class TestatorView extends StatefulWidget {
  const TestatorView({super.key});

  @override
  State<TestatorView> createState() => _TestatorViewState();
}

class _TestatorViewState extends State<TestatorView> with AutomaticKeepAliveClientMixin {
  final TestatorController testatorController = GetIt.I.get<TestatorController>();
  final EventBus eventBus = GetIt.I.get<EventBus>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testatorController.loadingTestaments();

      eventBus.on<TestamentCreatedEvent>().listen((event) {
        testatorController.loadingTestaments();
      });
    });

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
            child: Visibility(
              visible: testatorController.listTestament.isNotEmpty,
              replacement: EmptyListTestamentWidget(
                text: 'Você não possui nenhum testamento.',
                onTap: testatorController.loadingTestaments,
              ),
              child: ListView.builder(
                itemCount: testatorController.listTestament.length,
                padding: const EdgeInsets.all(24.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final testament = testatorController.listTestament[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: testatorController.listTestament.length - 1 == index ? 64 : 16,
                    ),
                    child: CardTestamentInfoWidget(
                      testament: testament,
                      seeDetails: () {
                        context.push(
                          RouterApp.seeDetails,
                          extra: {"testament": testament, "typeUser": EnumTypeUser.testator},
                        );
                      },
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
