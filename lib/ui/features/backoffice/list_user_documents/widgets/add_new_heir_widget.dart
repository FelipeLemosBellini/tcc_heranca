import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class AddNewHeirWidget extends StatelessWidget {
  final Function() onTap;

  const AddNewHeirWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary3,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
