import 'package:flutter/material.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/preview_place_holder.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class UploadTileSimple extends StatelessWidget {
  final String label;
  final Function() attach;
  final bool hasSelected;

  const UploadTileSimple({
    super.key,
    required this.label,
    required this.attach,
    required this.hasSelected,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
          ElevatedButtonWidget(text: "Anexar", onTap: attach),
          Text(
            hasSelected ? "Imagem salva" : "",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
