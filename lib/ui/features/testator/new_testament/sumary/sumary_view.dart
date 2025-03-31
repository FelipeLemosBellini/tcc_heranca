import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';

class SumaryView extends StatefulWidget {
  const SumaryView({super.key});

  @override
  State<SumaryView> createState() => _SumaryViewState();
}

class _SumaryViewState extends State<SumaryView> {
  final List<Map<String, String>> heirs = [
    {'address': '0x234712347123412834', 'percentage': '20'},
    {'address': '0x823573475734534534', 'percentage': '20'},
    {'address': '0x841234727934578389', 'percentage': '60'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Testamento'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Testamento',
              style: AppFonts.bodyHeadBold,
            ),
            const SizedBox(height: 20),
            Text(
              'Valor: 5 ETH',
              style: AppFonts.bodyMediumLight,
            ),
            const SizedBox(height: 20),
            Text(
              'Frequência da Prova de Vida: Trimestral',
              style: AppFonts.bodyMediumLight,
            ),
            const SizedBox(height: 20),
            Text(
              'Herdeiros:',
              style: AppFonts.bodyMediumLight,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: heirs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person, color: AppColors.primary),
                      title: Text(
                        "${heirs[index]['address']}",
                        style: AppFonts.bodyMediumLight,
                      ),
                      subtitle: Text(
                        "Participação: ${heirs[index]['percentage']}%",
                        style: AppFonts.bodyMediumLight,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButtonThematicWidget(
                  text: "Finalizar",
                  onTap: () {},
                  thematicEnum: ThematicButtonEnum.blue,
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
