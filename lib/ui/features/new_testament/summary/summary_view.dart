import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/new_testament/summary/summary_controller.dart';
import 'package:tcc/ui/features/new_testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';

class SummaryView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const SummaryView({super.key, required this.flowTestamentEnum});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late SummaryController summaryController;

  @override
  void initState() {
    super.initState();
    summaryController = GetIt.I.get<SummaryController>();
  }

  late TestamentModel testament = summaryController.getTestament();

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
          Text('Valor: ${testament.value} ETH', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 24),
          Text('Frequência da Prova de Vida: ${testament.proveOfLiveRecorrence}', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 24),
          Text('Herdeiros:', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 18),
          ListView.builder(
            itemCount: testament.listHeir.length,
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
                  title: Text(testament.listHeir[index].address, style: AppFonts.bodyMediumRegular.copyWith(color: AppColors.primary5)),
                  subtitle: Text(
                    "Participação: ${testament.listHeir[index].percentage}%",
                    style: AppFonts.bodyMediumRegular.copyWith(color: AppColors.primary5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: ElevatedButtonWidget(text: "Finalizar", onTap: () {}),
    );
  }
}
