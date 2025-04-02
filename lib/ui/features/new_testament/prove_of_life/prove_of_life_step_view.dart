import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/new_testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';

class ProveOfLifeStepView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const ProveOfLifeStepView({super.key, required this.flowTestamentEnum});

  @override
  State<ProveOfLifeStepView> createState() => _ProveOfLifeStepViewState();
}

class _ProveOfLifeStepViewState extends State<ProveOfLifeStepView> {
  String? selectedOption;
  final List<String> options = ['Trimestral', 'Semestral', 'Anual'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: widget.flowTestamentEnum == FlowTestamentEnum.creation
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
            ProgressBarWidget(progress: .75),
            Text('Prova de Vida', style: AppFonts.bodyLargeBold),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedOption,
              hint: const Text('Selecione a frequência'),
              style: AppFonts.bodyMediumMedium,
              isExpanded: true,
              borderRadius: BorderRadius.all(Radius.circular(36)),
              items:
                  options.map((String item) {
                    return DropdownMenuItem<String>(value: item, child: Text(item));
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButtonWidget(
        text: "Next",
        onTap: () {
          context.push(RouterApp.summary);
        },
      ),
    );
  }
}
