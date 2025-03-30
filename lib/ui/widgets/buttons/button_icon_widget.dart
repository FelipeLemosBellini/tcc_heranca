import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

enum ActionButtonEnum { edit, delete, send }

class ButtonIconWidget extends StatelessWidget {
  final Function() onTap;
  final ActionButtonEnum actionButtonEnum;

  const ButtonIconWidget({super.key, required this.onTap, required this.actionButtonEnum});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _colorBackground(actionButtonEnum),
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
            child: Icon(_icon(actionButtonEnum), size: 24, color: _colorIcon(actionButtonEnum)),
          ),
        ),
      ],
    );
  }

  Color _colorBackground(ActionButtonEnum actionButton) {
    switch (actionButton) {
      case ActionButtonEnum.edit:
        return AppColors.primaryLight2;
      case ActionButtonEnum.delete:
        return AppColors.error2;
      case ActionButtonEnum.send:
        return AppColors.success2;
    }
  }

  Color _colorIcon(ActionButtonEnum actionButton) {
    switch (actionButton) {
      case ActionButtonEnum.edit:
        return AppColors.primary;
      case ActionButtonEnum.delete:
        return AppColors.error;
      case ActionButtonEnum.send:
        return AppColors.success;
    }
  }

  IconData _icon(ActionButtonEnum actionButton) {
    switch (actionButton) {
      case ActionButtonEnum.edit:
        return Icons.mode_edit_outlined;
      case ActionButtonEnum.delete:
        return Icons.delete_outline_outlined;
      case ActionButtonEnum.send:
        return Icons.send_outlined;
    }
  }
}
