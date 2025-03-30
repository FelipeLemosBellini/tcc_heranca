import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

enum ThematicButtonEnum { green, red, blue }

class ElevatedButtonThematicWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? padding;
  final ThematicButtonEnum thematicEnum;

  const ElevatedButtonThematicWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.padding,
    required this.thematicEnum,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: padding ?? const EdgeInsets.all(24).copyWith(bottom: 40),
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _colorBackground(thematicEnum),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _colorBackground(thematicEnum).withOpacity(0.4), // Sombra mais definida
              blurRadius: 25, // Mais difuso
              spreadRadius: 5, // Aumenta a área da sombra
              offset: const Offset(0, 10), // Mantém para baixo
            ),
          ],
        ),
        child: Text(text, style: AppFonts.labelHeadBold.copyWith(color: _colorFont(thematicEnum))),
      ),
    );
  }

  Color _colorBackground(ThematicButtonEnum thematicButtonEnum) {
    switch (thematicButtonEnum) {
      case ThematicButtonEnum.blue:
        return AppColors.primaryLight2;
      case ThematicButtonEnum.red:
        return AppColors.error2;
      case ThematicButtonEnum.green:
        return AppColors.success2;
    }
  }

  Color _colorFont(ThematicButtonEnum thematicButtonEnum) {
    switch (thematicButtonEnum) {
      case ThematicButtonEnum.blue:
        return AppColors.primary;
      case ThematicButtonEnum.red:
        return AppColors.error;
      case ThematicButtonEnum.green:
        return AppColors.success;
    }
  }
}
