import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final List<Map<String, String>> heirs = [
    {'address': '0x234712347123412834', 'percentage': '20'},
    {'address': '0x823573475734534534', 'percentage': '20'},
    {'address': '0x841234727934578389', 'percentage': '60'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: 'Novo Testamento',
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
          Text('Valor: 5 ETH', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 24),
          Text('Frequência da Prova de Vida: Trimestral', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 24),
          Text('Herdeiros:', style: AppFonts.bodyMediumLight),
          const SizedBox(height: 18),
          ListView.builder(
            itemCount: heirs.length,
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
                  title: Text("${heirs[index]['address']}", style: AppFonts.bodyMediumRegular.copyWith(color: AppColors.primary5)),
                  subtitle: Text(
                    "Participação: ${heirs[index]['percentage']}%",
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
