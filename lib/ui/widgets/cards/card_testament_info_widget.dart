import 'package:flutter/material.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/helpers/extensions.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';

class CardTestamentInfoWidget extends StatelessWidget {
  final RequestInheritanceModel testament;
  final Function() seeDetails;

  const CardTestamentInfoWidget({
    super.key,
    required this.testament,
    required this.seeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: seeDetails,
      child: Card(
        color: AppColors.primary6,
        shadowColor: AppColors.primaryLight5,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Testamento de: ",
                    style: AppFonts.labelSmallRegular.copyWith(
                      color: AppColors.primaryLight2,
                    ),
                  ),
                  Text(
                    testament.name ?? 'Não informado',
                    style: AppFonts.labelSmallBold.copyWith(
                      color: AppColors.primaryLight2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Portador do CPF: ",
                    style: AppFonts.labelSmallRegular.copyWith(
                      color: AppColors.primaryLight2,
                    ),
                  ),
                  Text(
                    testament.cpf?.formatCpf() ?? '---',
                    style: AppFonts.labelSmallBold.copyWith(
                      color: AppColors.primaryLight2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (testament.createdAt != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Solicitado em: ",
                      style: AppFonts.labelSmallRegular.copyWith(
                        color: AppColors.primaryLight2,
                      ),
                    ),
                    Text(
                      testament.createdAt!.formatDateWithHour(),
                      style: AppFonts.labelSmallBold.copyWith(
                        color: AppColors.primaryLight2,
                      ),
                    ),
                  ],
                ),
              if (testament.createdAt != null) const SizedBox(height: 8),
              if (testament.heirStatus != null)
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: borderColorHeirStatus(
                        testament.heirStatus!,
                      ).withOpacity(0.2),
                      width: 3,
                    ),
                    color: backgroundColorHeirStatus(testament.heirStatus!),
                  ),
                  child: Text(
                    testament.heirStatus?.label ?? "",
                    style: AppFonts.labelSmallMedium.copyWith(
                      color: textColorHeirStatus(testament.heirStatus!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color backgroundColorHeirStatus(HeirStatus status) {
    switch (status) {
      case HeirStatus.consultaSaldoAprovado ||
          HeirStatus.transferenciaSaldoRealizada:
        return AppColors.success;
      case HeirStatus.consultaSaldoRecusado ||
          HeirStatus.transferenciaSaldoRecusado:
        return AppColors.error;
      case HeirStatus.consultaSaldoSolicitado ||
          HeirStatus.transferenciaSaldoSolicitado:
        return AppColors.warning;
    }
  }

  Color textColorHeirStatus(HeirStatus status) {
    switch (status) {
      case HeirStatus.consultaSaldoAprovado ||
          HeirStatus.transferenciaSaldoRealizada:
        return AppColors.white;
      case HeirStatus.consultaSaldoRecusado ||
          HeirStatus.transferenciaSaldoRecusado:
        return AppColors.white;
      case HeirStatus.consultaSaldoSolicitado ||
          HeirStatus.transferenciaSaldoSolicitado:
        return AppColors.black;
    }
  }

  Color borderColorHeirStatus(HeirStatus status) {
    switch (status) {
      case HeirStatus.consultaSaldoAprovado ||
          HeirStatus.transferenciaSaldoRealizada:
        return AppColors.white;
      case HeirStatus.consultaSaldoRecusado ||
          HeirStatus.transferenciaSaldoRecusado:
        return AppColors.white;
      case HeirStatus.consultaSaldoSolicitado ||
          HeirStatus.transferenciaSaldoSolicitado:
        return AppColors.black;
    }
  }
}
