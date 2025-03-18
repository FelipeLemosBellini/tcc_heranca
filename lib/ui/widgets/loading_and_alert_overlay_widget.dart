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
        AlertHelper.showAlertSnackBar(
          context: context,
          alertData: alertData,
        );
      });
    }

    return Stack(
      children: [
        child,
        Visibility(
          visible: isLoading,
          child: Container(
            color: AppColors.navyBlue.withOpacity(0.1),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
