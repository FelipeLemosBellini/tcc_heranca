import 'package:flutter/material.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/widgets/add_new_heir_widget.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class ListAddressAndAmountWidget extends StatelessWidget {
  final List<TextEditingController> addressController;
  final List<TextEditingController> amountController;
  final List<FocusNode> addressFocusNode;
  final List<FocusNode> amountFocusNode;
  final Function(int) remove;

  const ListAddressAndAmountWidget({
    super.key,
    required this.addressController,
    required this.amountController,
    required this.addressFocusNode,
    required this.amountFocusNode,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      itemBuilder: (context, index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldWidget(
                    hintText: "Digite o endereço do beneficiário",
                    controller: addressController[index],
                    focusNode: addressFocusNode[index],
                  ),
                  TextFieldWidget(
                    hintText: "Digite o valor que deve ser enviado",
                    controller: amountController[index],
                    focusNode: amountFocusNode[index],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onlyNumber: true,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => remove(index),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary3,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.remove),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(),
        );
      },
      itemCount: addressController.length,
    );
  }
}
