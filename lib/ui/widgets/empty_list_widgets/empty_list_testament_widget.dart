import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';

class EmptyListTestamentWidget extends StatelessWidget {
  final String text;
  final Function() onTap;

  const EmptyListTestamentWidget({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: AppFonts.labelLargeMedium),
        SizedBox(height: 8),
        ButtonIconWidget(onTap: onTap, actionButtonEnum: ActionButtonEnum.reload),
      ],
    );
  }
}
