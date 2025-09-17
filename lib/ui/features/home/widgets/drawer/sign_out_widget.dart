import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class SignOutWidget extends StatelessWidget {
  final Function() onTap;

  const SignOutWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error2,
          borderRadius: BorderRadius.all(Radius.circular(36)),
        ),
        child: Row(
          children: [
            Icon(Icons.exit_to_app, color: AppColors.error),
            SizedBox(width: 8),
            Text(
              "Sair",
              style: AppFonts.labelLargeMedium.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
