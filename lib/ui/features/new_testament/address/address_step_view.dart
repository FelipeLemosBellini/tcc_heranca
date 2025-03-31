import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/new_testament/address/address_step_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:flutter/services.dart';
import 'package:tcc/ui/widgets/progress_bar_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class AddressStepView extends StatefulWidget {
  const AddressStepView({super.key});

  @override
  State<AddressStepView> createState() => _AddressStepViewState();
}

class _AddressStepViewState extends State<AddressStepView> {
  AddressStepController addressStepController = GetIt.I.get<AddressStepController>();

  // Listas para armazenar os controladores de cada linha de endereço e porcentagem
  List<TextEditingController> addressControllers = [TextEditingController()];
  List<TextEditingController> percentageControllers = [TextEditingController()];

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
                title: "Novo testamento",
                onTap: () {
                  context.pop();
                },
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ProgressBarWidget(progress: 0.5),
                  Text('Insira o endereço dos herdeiros', style: AppFonts.bodyLargeBold),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: addressControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFieldWidget(
                                controller: addressControllers[index],
                                hintText: 'Endereço',
                                focusNode: FocusNode(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFieldWidget(
                                controller: percentageControllers[index],
                                hintText: '%',
                                focusNode: FocusNode(),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                setState(() {
                                  if (addressControllers.length == 1) {
                                    AlertHelper.showAlertSnackBar(
                                      context: context,
                                      alertData: AlertData(
                                        message: 'Você deve ter pelo menos um endereço!',
                                        errorType: ErrorType.warning,
                                      ),
                                    );
                                  } else {
                                    addressControllers.removeAt(index);
                                    percentageControllers.removeAt(index);
                                  }
                                });
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
                      onTap: () {
                        setState(() {
                          addressControllers.add(TextEditingController());
                          percentageControllers.add(TextEditingController());
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),

              bottomSheet: ElevatedButtonWidget(
                text: "Next",
                onTap: () {
                  // if (addressControllers.any((element) => element.text.isEmpty) ||
                  //     percentageControllers.any((element) => element.text.isEmpty)) {
                  //   AlertHelper.showAlertSnackBar(
                  //     context: context,
                  //     alertData: AlertData(
                  //       message: 'Preencha todos os campos!',
                  //       errorType: ErrorType.warning,
                  //     ),
                  //   );
                  //   return;
                  // }
                  // if (isValidEthereumAddress(addressControllers.last.text) == false) {
                  //   AlertHelper.showAlertSnackBar(
                  //     context: context,
                  //     alertData: AlertData(
                  //       message: 'Endereço Ethereum inválido!',
                  //       errorType: ErrorType.warning,
                  //     ),
                  //   );
                  //   return;
                  // }
                  // for (int i = 0; i < addressControllers.length; i++) {
                  //   String address = addressControllers[i].text.trim();
                  //   String percentage = percentageControllers[i].text.trim();
                  //   print('Endereço: $address, Porcentagem: $percentage');
                  // }

                  context.push(RouterApp.proofOfLifeStep);
                },
              ),
            ),
          ),
    );
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
