import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/amount/amount_step_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class AmountStepView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const AmountStepView({super.key, required this.flowTestamentEnum});

  @override
  State<AmountStepView> createState() => _AmountStepViewState();
}

class _AmountStepViewState extends State<AmountStepView> {
  final AmountStepController amountStepController = GetIt.I.get<AmountStepController>();
  final FocusNode _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    amountStepController.initController(widget.flowTestamentEnum);
  }

  @override
  void dispose() {
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: widget.flowTestamentEnum == FlowTestamentEnum.creation
            ? "Novo testamento"
            : "Edite o testamento",
        onTap: () {
          amountStepController.clearTestament();
          context.pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBarWidget(progress: 0.25),
            const SizedBox(height: 24),
            Text('Insira um valor', style: AppFonts.bodyLargeBold),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    controller: amountStepController.amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    focusNode: _amountFocus,
                    hintText: 'Quantidade',
                    onlyNumber: true,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary6,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.network(
                        "https://worldvectorlogo.com/download/ethereum-eth.svg",
                        placeholderBuilder: (_) {
                          return Icon(
                            Icons.monetization_on,
                            color: AppColors.primaryLight2,
                            size: 32,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.primaryLight2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ButtonIconWidget(
                actionButtonEnum: ActionButtonEnum.add,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButtonWidget(
        text: "Next",
        onTap: () async {
          String amountText = amountStepController.amountController.text.trim();

          if (amountText.isNotEmpty && double.tryParse(amountText) != null && double.parse(amountText) > 0) {
            final result = await amountStepController.setAmount(double.parse(amountText), widget.flowTestamentEnum);
            result.fold(
                  (error) {
                AlertHelper.showAlertSnackBar(
                  context: context,
                  alertData: AlertData(
                    message: "Saldo Insuficiente",
                    errorType: ErrorType.error,
                  ),
                );
              },
                  (_) {
                context.push(RouterApp.addressStep, extra: widget.flowTestamentEnum);
              },
            );
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
