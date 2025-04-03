import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final Function() onRefresh;

  const RefreshIndicatorWidget({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh.call(),
      color: AppColors.primary,
      backgroundColor: AppColors.primaryLight2,
      child: child,
    );
  }
}
