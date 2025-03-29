import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class PillButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String text;
  final bool showArrow;

  const PillButtonWidget({
    super.key,
    required this.onTap,
    required this.text,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: AppColors.primary4,
      splashColor: AppColors.primary4,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      onTap: () => onTap.call(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary7,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: AppColors.primary2, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: AppFonts.titleSmall),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
