import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? padding;

  const ElevatedButtonWidget({super.key, required this.text, required this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,
      margin: padding ?? const EdgeInsets.all(24),
      width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navyBlue,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
