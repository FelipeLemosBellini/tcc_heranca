import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class BaseDrawerWidget extends StatelessWidget {
  final Widget child;

  const BaseDrawerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.primary6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(20),
          ), // Arredonda apenas o lado direito
        ),
        child: child,
      ),
    );
  }
}
