import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class NumberEnablerWidget extends StatelessWidget {
  final int counter;

  const NumberEnablerWidget({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.gray7,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("OBS: A soma dos herdeiros deve \nser igual a 100%", style: AppFonts.bodySmallBold),
            SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    "Soma das porcentagens \ninseridas: $counter %",
                    style: AppFonts.bodySmallMedium,
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  flex: 1,
                  child:
                      counter > 100
                          ? Icon(Icons.close_sharp, color: AppColors.error3)
                          : counter == 100
                          ? Icon(Icons.verified, color: AppColors.success2)
                          : SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
