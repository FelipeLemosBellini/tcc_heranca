import 'package:flutter/material.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';

class CardTestamentInfoWidget extends StatelessWidget {
  final TestamentModel testament;
  final Function() seeDetails;

  const CardTestamentInfoWidget({super.key, required this.testament, required this.seeDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary6,
      shadowColor: AppColors.primaryLight5,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(testament.title, style: AppFonts.bodyLargeBold),
            const SizedBox(height: 8),
            Text(
              "Criado em: ${testament.dateCreated.dateFormatted}",
              style: AppFonts.labelSmallLight.copyWith(color: AppColors.primaryLight2),
            ),
            const SizedBox(height: 8),
            Text(
              "Prova de vida: ${testament.lastProveOfLife.dateFormatted}",
              style: AppFonts.labelSmallBold.copyWith(color: AppColors.error2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: AppColors.white),
            ),
            Text("Endereço dos herdeiros:", style: AppFonts.labelSmallBold),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: testament.listHeir.length,
              itemBuilder: (context, index) {
                final heir = testament.listHeir[index];
                return Text(
                  heir.address,
                  style: AppFonts.bodySmallRegular.copyWith(color: AppColors.primaryLight2),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Valor:", style: AppFonts.labelSmallBold),
                    const SizedBox(height: 8),
                    Text(
                      "${testament.value} ETH",
                      style: AppFonts.labelMediumBold.copyWith(color: AppColors.primaryLight2),
                    ),
                  ],
                ),
                PillButtonWidget(onTap: seeDetails, text: "Ver detalhes"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
