import 'package:flutter/material.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/preview_place_holder.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class UploadTileSimple extends StatelessWidget {
  final String label;
  final Function() attach;
  final bool hasAttach;
  final Document? document;

  const UploadTileSimple({
    super.key,
    required this.label,
    required this.attach,
    required this.hasAttach,
    this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray8,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: document?.reviewStatus == ReviewStatusDocument.approved,
            replacement: ElevatedButtonWidget(text: "Anexar", onTap: attach),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box, color: Colors.green),
                Text('Documento validado'),
              ],
            ),
          ),
          Visibility(
            visible: document?.reviewStatus == ReviewStatusDocument.invalid,
            child: Text(
              "Motivo da reprova: ${document?.reviewMessage ?? 'Motivo não informado'}",
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: hasAttach,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              child: Text(
                "Anexado",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
