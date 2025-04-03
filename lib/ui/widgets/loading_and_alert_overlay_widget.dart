import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

import 'dialogs/alert_helper.dart';

class LoadingAndAlertOverlayWidget extends StatelessWidget {
  final bool isLoading;
  final AlertData? alertData;
  final Widget child;

  const LoadingAndAlertOverlayWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.alertData,
  });

  @override
  Widget build(BuildContext context) {
    if (alertData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AlertHelper.showAlertSnackBar(context: context, alertData: alertData);
      });
    }

    return Stack(
      children: [
        Align(alignment: Alignment.topCenter, child: child),
        Visibility(
          visible: isLoading,
          child: Container(
            color: AppColors.primaryLight2.withOpacity(0.2),
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 6),
          ),
        ),
      ],
    );
  }
}
