import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class ItemDrawerWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  final IconData iconEnable;
  final IconData iconDisable;
  final bool isIn;

  const ItemDrawerWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconEnable,
    required this.iconDisable,
    required this.isIn,
  });

  @override
  Widget build(BuildContext context) {
    Color background = isIn ? AppColors.primaryLight2 : AppColors.primary6;
    Color items = isIn ? AppColors.primary6 : AppColors.primaryLight2;
    IconData icon = isIn ? iconEnable : iconDisable;
    Decoration? boxDecoration =
        isIn
            ? BoxDecoration(color: background, borderRadius: BorderRadius.all(Radius.circular(36)))
            : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: boxDecoration,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, color: items),
            SizedBox(width: 8),
            Text(title, style: AppFonts.labelLargeMedium.copyWith(color: items)),
          ],
        ),
      ),
    );
  }
}
