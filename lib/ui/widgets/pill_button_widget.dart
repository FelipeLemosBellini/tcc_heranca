import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class PillButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String text;

  const PillButtonWidget({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      onTap: () => onTap.call(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(
            color: AppColors.navyBlue,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.navyBlue,
          ),
        ),
      ),
    );
  }
}
