import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/new_testament/address/address_step_view.dart';
import 'package:tcc/ui/features/new_testament/amount/amount_step_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class AmountStepView extends StatefulWidget {
  const AmountStepView({super.key});

  @override
  State<AmountStepView> createState() => _AmountStepViewState();
}

class _AmountStepViewState extends State<AmountStepView> {
  final TextEditingController _amountController = TextEditingController();
  AmountStepController amountStepController = GetIt.I.get<AmountStepController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: "Novo testamento",
        onTap: () {
          context.pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBarWidget(progress: 0.25),
            Text('Insira um valor', style: AppFonts.bodyLargeBold),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _amountController,
              keyboardType: TextInputType.number,
              focusNode: FocusNode(),
              hintText: 'Valor em ETH',
              onlyNumber: true,
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButtonWidget(
        text: "Next",
        onTap: () {
          String amount = _amountController.text.trim();

          //VALIDACAO DE CAMPO VAZIO PARA IR PARA O PROX PASSO
          if (amount.isNotEmpty && amount != '0' && amount != '0.0') {
            amountStepController.setAmount(double.parse(amount));
            context.push(RouterApp.addressStep);
          } else {
            AlertHelper.showAlertSnackBar(
              context: context,
              alertData: AlertData(
                message: 'Preencha a quantidade de ETH',
                errorType: ErrorType.warning,
              ),
            );
          }
        },
      ),
    );
  }
}
