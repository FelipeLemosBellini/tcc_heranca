import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/see_details_inheritance_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class SeeDetailsInheritanceView extends StatefulWidget {
  // final RequestInheritanceModel model;

  const SeeDetailsInheritanceView({super.key,
    // required this.model
  });

  @override
  State<SeeDetailsInheritanceView> createState() =>
      _SeeDetailsInheritanceViewState();
}

class _SeeDetailsInheritanceViewState extends State<SeeDetailsInheritanceView> {
  final SeeDetailsInheritanceController _seeDetailsInheritanceController =
      GetIt.I.get<SeeDetailsInheritanceController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _seeDetailsInheritanceController,
      builder:
          (_, __) => LoadingAndAlertOverlayWidget(
            isLoading: _seeDetailsInheritanceController.isLoading,
            alertData: _seeDetailsInheritanceController.alertData,
            child: Scaffold(
              appBar: AppBarSimpleWidget(
                title: "Detalhes",
                onTap: () {
                  context.pop();
                },
              ),
              body: Container(),
            ),
          ),
    );
  }
}
