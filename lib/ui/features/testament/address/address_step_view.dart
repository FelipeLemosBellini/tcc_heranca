import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/address/address_step_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testament/widgets/number_enabler_widget.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class AddressStepView extends StatefulWidget {
  final FlowTestamentEnum flowTestamentEnum;

  const AddressStepView({super.key, required this.flowTestamentEnum});

  @override
  State<AddressStepView> createState() => _AddressStepViewState();
}

class _AddressStepViewState extends State<AddressStepView> {
  AddressStepController addressStepController = GetIt.I.get<AddressStepController>();

  @override
  void initState() {
    addressStepController.initController(widget.flowTestamentEnum);
    super.initState();
  }

  @override
  void dispose() {
    for (var node in addressStepController.focusNodes) {
      node.dispose();
    }
    for (var controller in addressStepController.addressControllers) {
      controller.dispose();
    }
    for (var controller in addressStepController.percentageControllers) {
      controller.removeListener(addressStepController.checkAllFieldsUnfocused);
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: addressStepController,
      builder:
          (context, _) => LoadingAndAlertOverlayWidget(
            isLoading: addressStepController.isLoading,
            alertData: addressStepController.alertData,
            child: Scaffold(
              appBar: AppBarSimpleWidget(
                title:
                    widget.flowTestamentEnum == FlowTestamentEnum.creation
                        ? "Novo testamento"
                        : "Edite o testamento",
                onTap: () {
                  context.pop();
                },
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ProgressBarWidget(progress: 0.50),
                  Text('Insira o endereço dos herdeiros', style: AppFonts.bodyLargeBold),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: addressStepController.addressControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFieldWidget(
                                controller: addressStepController.addressControllers[index],
                                hintText: 'Endereço',
                                focusNode: FocusNode(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFieldWidget(
                                controller: addressStepController.percentageControllers[index],
                                hintText: '%',
                                focusNode: addressStepController.focusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                _removeField(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ButtonIconWidget(
                      actionButtonEnum: ActionButtonEnum.add,
                      onTap: () => addressStepController.addNewField(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  NumberEnablerWidget(counter: addressStepController.counterPercentage),
                  SizedBox(height: 100),
                ],
              ),
              bottomSheet: ElevatedButtonWidget(text: "Next", onTap: () => _next()),
            ),
          ),
    );
  }

  void _removeField(int index) {
    if (addressStepController.addressControllers.length == 1) {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(
          message: 'Você deve ter pelo menos um endereço!',
          errorType: ErrorType.warning,
        ),
      );
    } else {
      addressStepController.removeField(index);
    }
  }

  void _next() {
    if (addressStepController.counterPercentage != 100) {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(
          message: 'A soma das porcentagens deve ser igual a 100%',
          errorType: ErrorType.warning,
        ),
      );
      return;
    }
    if (addressStepController.addressControllers.any((element) => element.text.isEmpty) ||
        addressStepController.percentageControllers.any((element) => element.text.isEmpty)) {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(message: 'Preencha todos os campos!', errorType: ErrorType.warning),
      );
      return;
    }
    if (isValidEthereumAddress(addressStepController.addressControllers.last.text) == false) {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(message: 'Endereço Ethereum inválido!', errorType: ErrorType.warning),
      );
      return;
    }
    List<HeirModel> heirs = [];
    for (int i = 0; i < addressStepController.addressControllers.length; i++) {
      String address = addressStepController.addressControllers[i].text.trim();
      String percentage = addressStepController.percentageControllers[i].text.trim();
      heirs.add(HeirModel(address: address, percentage: int.parse(percentage)));
    }
    addressStepController.setListHeir(heirs);
    context.push(RouterApp.proofOfLifeStep, extra: widget.flowTestamentEnum);
  }
}

bool isValidEthereumAddress(String address) {
  try {
    // EthereumAddress.fromHex(address);
    return true;
  } catch (e) {
    return false;
  }
}
