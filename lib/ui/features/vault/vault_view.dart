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

class VaultView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const VaultView({super.key, required this.flowTestamentEnum});

  @override
  State<VaultView> createState() => _VaultViewState();
}

class _VaultItem {
  final String asset;
  final double amount;
  const _VaultItem({required this.asset, required this.amount});
}

class _VaultViewState extends State<VaultView> {
  final AmountStepController amountStepController = GetIt.I.get<AmountStepController>();
  final FocusNode _amountFocus = FocusNode();


  final TextEditingController _amountCtl = TextEditingController();
  String _selectedAsset = 'ETH';
  final List<_VaultItem> _items = [];

  @override
  void initState() {
    super.initState();
    amountStepController.initController(widget.flowTestamentEnum);
  }

  @override
  void dispose() {
    _amountFocus.dispose();
    _amountCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: widget.flowTestamentEnum == FlowTestamentEnum.creation
            ? "Novo Cofre"
            : "Edite o Cofre",
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
            const SizedBox(height: 24),
            Text('Adicionar saldos ao cofre', style: AppFonts.bodyLargeBold),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    controller: _amountCtl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    focusNode: _amountFocus,
                    hintText: 'Quantidade',
                    onlyNumber: true,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('ETH', style: AppFonts.bodyMediumMedium),
                ),
                const SizedBox(width: 8),
                ButtonIconWidget(
                  actionButtonEnum: ActionButtonEnum.add,
                  onTap: () {
                    final raw = _amountCtl.text.trim();
                    final value = double.tryParse(raw);
                    if (value == null || value <= 0) {
                      AlertHelper.showAlertSnackBar(
                        context: context,
                        alertData: AlertData(
                          message: 'Informe um valor válido',
                          errorType: ErrorType.warning,
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _items.add(_VaultItem(asset: _selectedAsset, amount: value));
                      _amountCtl.clear();
                      _amountFocus.requestFocus();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum saldo adicionado ainda',
                        style: AppFonts.bodySmallLight,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final it = _items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.savings_outlined),
                            title: Text('${it.asset}'),
                            subtitle: Text('${it.amount}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => setState(() => _items.removeAt(index)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 6),
              child: Row(
                children: [
                  Text('Total', style: AppFonts.bodyLargeBold),
                  const Spacer(),
                  Text(
                    _items.fold<double>(0, (acc, it) => acc + it.amount).toStringAsFixed(6) + ' ETH',
                    style: AppFonts.bodyLargeBold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        child: ElevatedButtonWidget(
          text: "Next",
          onTap: () async {
            // Gate de conteúdo
            if (_items.isEmpty) {
              AlertHelper.showAlertSnackBar(
                context: context,
                alertData: AlertData(
                  message: 'Adicione pelo menos um saldo',
                  errorType: ErrorType.warning,
                ),
              );
              return;
            }

            final total = _items.fold<double>(0, (acc, it) => acc + it.amount);
            // final result = await amountStepController.setAmount(total, widget.flowTestamentEnum);
            // result.fold(
            //   (error) {
            //     AlertHelper.showAlertSnackBar(
            //       context: context,
            //       alertData: AlertData(
            //         message: 'Saldo Insuficiente',
            //         errorType: ErrorType.error,
            //       ),
            //     );
            //   },
            //   (_) {
            //     context.push(RouterApp.addressStep, extra: widget.flowTestamentEnum);
            //   },
            // );
          },
        ),
      ),
    );
  }
}
