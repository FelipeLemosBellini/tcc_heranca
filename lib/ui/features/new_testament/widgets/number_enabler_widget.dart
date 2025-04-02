import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class NumberEnablerWidget extends StatelessWidget {
  final int counter;

  const NumberEnablerWidget({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    TextStyle counterStyle =
        counter == 100
            ? AppFonts.bodySmallMedium.copyWith(color: AppColors.success2)
            : counter > 100
            ? AppFonts.bodySmallMedium.copyWith(color: AppColors.error2)
            : AppFonts.bodySmallMedium;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.gray7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("OBS: A soma dos herdeiros deve ser igual a 100%", style: AppFonts.bodySmallBold),
          SizedBox(height: 8),
          Row(
            children: [
              Text("Soma das porcentagens inseridas: ", style: AppFonts.bodySmallMedium),
              Text("$counter", style: counterStyle),
              SizedBox(width: 4),
              Icon(Icons.verified),
            ],
          ),
        ],
      ),
    );
  }
}
