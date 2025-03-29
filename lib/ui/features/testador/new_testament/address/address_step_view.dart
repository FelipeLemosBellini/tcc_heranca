import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/features/testador/new_testament/address/address_step_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:flutter/services.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class AddressStepView extends StatefulWidget {
  final String amount;

  const AddressStepView({super.key, required this.amount});

  @override
  State<AddressStepView> createState() => _AddressStepViewState();
}

class _AddressStepViewState extends State<AddressStepView> {
  AddressStepController addressStepController =
  GetIt.I.get<AddressStepController>();

  // Listas para armazenar os controladores de cada linha de endereço e porcentagem
  List<TextEditingController> addressControllers = [TextEditingController()];
  List<TextEditingController> percentageControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: addressStepController,
      builder: (context, _) => LoadingAndAlertOverlayWidget(
        isLoading: addressStepController.isLoading,
        alertData: addressStepController.alertData,
        child: Scaffold(
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
                  'Insira um endereço',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Exibindo dinamicamente as linhas de texto
                Expanded(
                  child: ListView.builder(
                    itemCount: addressControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: TextFieldWidget(
                                controller: addressControllers[index],
                                hintText: 'Endereço',
                                focusNode: FocusNode(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFieldWidget(
                                controller: percentageControllers[index],
                                hintText: '%',
                                focusNode: FocusNode(),
                                keyboardType: TextInputType.number,
                                obscureText: false,
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
                ),

                // Botão para adicionar uma nova linha de entrada
                Center(
                  child: ElevatedButtonWidget(
                    text: '+',
                    onTap: () {
                      setState(() {
                        addressControllers.add(TextEditingController());
                        percentageControllers.add(TextEditingController());
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),
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
                        onPressed: () {
                          for (int i = 0; i < addressControllers.length; i++) {
                            String address = addressControllers[i].text.trim();
                            String percentage = percentageControllers[i].text.trim();
                            print('Endereço: $address, Porcentagem: $percentage');
                          }
                        },
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
        ),
      ),
    );
  }
}
