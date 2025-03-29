import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

enum ErrorType { error, warning, success }

class AlertData {
  ErrorType errorType;
  String message;

  AlertData({required this.message, required this.errorType});
}

abstract class AlertHelper {
  static void showAlertSnackBar({AlertData? alertData, required BuildContext context}) {
    if (alertData != null) {
      switch (alertData.errorType) {
        case ErrorType.error:
          _showSnackBarError(context, alertData.message);
        case ErrorType.success:
          _showSnackBarSuccess(context, alertData.message);
        case ErrorType.warning:
          _showSnackBarWarning(context, alertData.message);
      }
    }
  }

  static void _showSnackBarSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      background: AppColors.primaryLight5,
      fontColor: AppColors.white,
    );
  }

  static void _showSnackBarError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      background: AppColors.error2,
      fontColor: AppColors.white,
    );
  }

  static void _showSnackBarWarning(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      background: AppColors.warning,
      fontColor: AppColors.black,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color background,
    required Color fontColor,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(message, style: AppFonts.labelMediumMedium.copyWith(color: fontColor)),
      duration: const Duration(seconds: 1),
      backgroundColor: background,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
