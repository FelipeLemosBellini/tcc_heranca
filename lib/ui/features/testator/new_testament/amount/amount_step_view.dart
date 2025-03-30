import 'package:flutter/material.dart';
import 'package:tcc/ui/features/testator/new_testament/address/address_step_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

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
        title: const Text('Novo Testamento'),
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
            TextFieldWidget(
              controller: _amountController,
              keyboardType: TextInputType.number,
              focusNode: FocusNode(),
              hintText: 'Valor em ETH',
            ),
            const SizedBox(height: 20),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                String amount = _amountController.text.trim();

                //VALIDACAO DE CAMPO VAZIO PARA IR PARA O PROX PASSO
                if (amount.isNotEmpty) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => AddressStepView(amount: amount),
                     ),
                   );
                 } else {
                   AlertHelper.showAlertSnackBar(context: context,
                       alertData: AlertData(message: 'Preencha a quantidade de ETH',
                           errorType: ErrorType.warning));
                 }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
