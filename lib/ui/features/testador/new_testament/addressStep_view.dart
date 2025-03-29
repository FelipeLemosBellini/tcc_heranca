import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class AddressStepView extends StatefulWidget {
  final String amount;
  const AddressStepView({super.key, required this.amount});

  @override
  State<AddressStepView> createState() => _AddressStepViewState();
}

class _AddressStepViewState extends State<AddressStepView> {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Navigator.pop(context);
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
    );
  }
}
