import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_created_event.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/summary/summary_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class SummaryView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const SummaryView({super.key, required this.flowTestamentEnum});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  SummaryController summaryController = GetIt.I.get<SummaryController>();

  @override
  void initState() {
    summaryController.initController(widget.flowTestamentEnum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: "Resumo",
        onTap: () {
          context.pop();
        },
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          ProgressBarWidget(progress: 0.95),
          Text('Resumo do Testamento', style: AppFonts.bodyHeadBold),
          const SizedBox(height: 24),
          TextFieldWidget(
            hintText: 'Titulo testamento',
            controller: summaryController.titleController,
            focusNode: FocusNode(),
          ),
          const SizedBox(height: 24),
          Text(
            'Valor: ${summaryController.testamentModel.value} ETH',
            style: AppFonts.bodyMediumLight,
          ),
          const SizedBox(height: 24),
          Text(
            'Frequência da Prova de Vida: ${summaryController.testamentModel.proveOfLiveRecorrence.name}',
            style: AppFonts.bodyMediumLight,
          ),
          const SizedBox(height: 24),
          Text('Herdeiros:', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 18),
          ListView.builder(
            itemCount: summaryController.testamentModel.listHeir.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: AppColors.primaryLight2,
                shadowColor: AppColors.primaryLight2,
                elevation: 16,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.person, color: AppColors.primary5),
                  title: Text(
                    summaryController.testamentModel.listHeir[index].address,
                    style: AppFonts.bodyMediumRegular.copyWith(color: AppColors.primary5),
                  ),
                  subtitle: Text(
                    "Participação: ${summaryController.testamentModel.listHeir[index].percentage}%",
                    style: AppFonts.bodyMediumRegular.copyWith(color: AppColors.primary5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: ElevatedButtonWidget(text: "Finalizar", onTap: finishTestament),
    );
  }

  void finishTestament() {
    if (summaryController.titleController.text.isEmpty) {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(
          message: 'Dê um titulo ao seu novo testamento!',
          errorType: ErrorType.warning,
        ),
      );
      return;
    }
    summaryController.saveTestament(widget.flowTestamentEnum);
    summaryController.clearTestament();
    EventBus eventBus = GetIt.I.get<EventBus>();
    eventBus.fire(TestamentCreatedEvent(summaryController.testamentModel));
    context.go(RouterApp.home);
  }
}
