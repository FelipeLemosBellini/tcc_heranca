import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? padding;
  final bool inverterColor;

  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.padding,
    this.inverterColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            margin: padding ?? const EdgeInsets.all(24).copyWith(bottom: 40),
            width: MediaQuery.sizeOf(context).width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: inverterColor ? AppColors.primary7 : AppColors.primary,
              borderRadius: BorderRadius.circular(30),
              border:
                  inverterColor
                      ? Border.all(color: AppColors.primary2, width: 2)
                      : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  // Sombra mais definida
                  blurRadius: 25,
                  // Mais difuso
                  spreadRadius: 5,
                  // Aumenta a área da sombra
                  offset: const Offset(0, 10), // Mantém para baixo
                ),
              ],
            ),
            child: Text(text, style: AppFonts.labelHeadBold),
          ),
        ),
      ],
    );
  }
}
