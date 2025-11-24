import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary2, AppColors.primary2.withOpacity(.92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Informe CPF e RG, e anexe a frente/verso do documento e o comprovante de residência.',
              style: AppFonts.bodySmallMedium,
            ),
          ),
        ],
      ),
    );
  }
}
