import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class AmountStepView extends StatefulWidget {
  const AmountStepView({super.key});

  @override
  State<AmountStepView> createState() => _AmountStepViewState();
}

class _AmountStepViewState extends State<AmountStepView> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criação de Testamento'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insira um valor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Pegando o valor digitado
                  String amount = _amountController.text.trim();

                  // if (amount.isNotEmpty) {
                  //   // Navegar para a próxima etapa e passar o valor
                  //   // Navigator.push(
                  //   //   context,
                  //     // MaterialPageRoute(
                  //     //   builder: (context) => AddressStepView(amount: amount),
                  //     // ),
                  //   );
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Por favor, insira um valor válido!'),
                  //       backgroundColor: Colors.red,
                  //     ),
                  //   );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
