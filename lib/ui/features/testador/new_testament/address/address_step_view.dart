import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/features/testador/new_testament/address/address_step_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class AddressStepView extends StatefulWidget {
  final String amount;

  const AddressStepView({super.key, required this.amount});

  @override
  State<AddressStepView> createState() => _AddressStepViewState();
}

class _AddressStepViewState extends State<AddressStepView> {
  AddressStepController addressStepController = GetIt.I.get<AddressStepController>();

  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: addressStepController,
      builder:
          (context, _) => LoadingAndAlertOverlayWidget(
            isLoading: addressStepController.isLoading,
            alertData: addressStepController.alertData,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insira um endereço',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        border: OutlineInputBorder(),
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
                              minimumSize: Size(double.infinity, 60),
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
                              String address = _addressController.text.trim();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 60),
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
