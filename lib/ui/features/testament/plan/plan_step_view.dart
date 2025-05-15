import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/plan/plan_step_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';

class PlanStepView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const PlanStepView({super.key, required this.flowTestamentEnum});

  @override
  State<PlanStepView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanStepView> {
  PlanStepController planStepController = GetIt.I.get<PlanStepController>();

  final List<String> options = ['Teste', 'Basico', 'Pro'];

  @override
  void initState() {
    planStepController.initController(widget.flowTestamentEnum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title:
        widget.flowTestamentEnum == FlowTestamentEnum.creation
            ? "Novo testamento"
            : "Edite o testamento",
        onTap: () {
          context.pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBarWidget(progress: .80),
            Text('Planos', style: AppFonts.bodyLargeBold),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: planStepController.selectedOption,
              hint: const Text('Selecione o seu plano'),
              style: AppFonts.bodyMediumMedium,
              isExpanded: true,
              borderRadius: BorderRadius.all(Radius.circular(36)),
              items:
              options.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  planStepController.selectedOption = newValue;
                });
              },
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButtonWidget(
        text: "Next",
        onTap: () {
          if (planStepController.selectedOption == null) {
            AlertHelper.showAlertSnackBar(
              context: context,
              alertData: AlertData(message: 'Selecione uma opção!', errorType: ErrorType.warning),
            );
            return;
          }
          if (planStepController.selectedOption != null) {
            planStepController.setPlan(
              mapStringToEnum(planStepController.selectedOption!),
            );
          }
          context.push(RouterApp.summary, extra: widget.flowTestamentEnum);
        },
      ),
    );
  }

  EnumPlan mapStringToEnum(String option) {
    switch (option) {
      case 'Teste':
        return EnumPlan.TESTE;
      case 'Basico':
        return EnumPlan.BASICO;
      case 'Pro':
        return EnumPlan.PRO;
      default:
        return EnumPlan.TESTE;
    }
  }
}
