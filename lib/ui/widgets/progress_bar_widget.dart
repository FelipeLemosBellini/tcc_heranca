import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final EdgeInsets? padding;
  final double progress;

  const ProgressBarWidget({super.key, this.padding, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 16),
      child: LinearProgressIndicator(
        minHeight: 6,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.primaryLight3,
        backgroundColor: AppColors.primary5,
        value: progress,
      ),
    );
  }
}
