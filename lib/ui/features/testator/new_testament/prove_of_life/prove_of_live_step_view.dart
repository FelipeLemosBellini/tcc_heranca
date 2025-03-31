import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class ProveOfLiveStepView extends StatefulWidget {
  const ProveOfLiveStepView({super.key});

  @override
  State<ProveOfLiveStepView> createState() => _ProveOfLiveStepViewState();
}

class _ProveOfLiveStepViewState extends State<ProveOfLiveStepView> {
  String? selectedOption;
  final List<String> options = ['Trimestral', 'Semestral', 'Anual'];

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
            const Text(
              'Prova de Vida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dropdown Button
            DropdownButton<String>(
              value: selectedOption,
              hint: const Text('Selecione a frequência'),
              isExpanded: true,
              items: options.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
            ),

            const SizedBox(height: 30),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: AppColors.gray5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
