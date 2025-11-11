import 'package:flutter/material.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class StatusBanner extends StatelessWidget {
  final HeirStatus status;

  const StatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;
    switch (status) {
      case HeirStatus.consultaSaldoAprovado:
      case HeirStatus.transferenciaSaldoRealizada:
        background = Colors.green.withOpacity(0.15);
        foreground = Colors.green.shade800;
        break;
      case HeirStatus.consultaSaldoRecusado:
      case HeirStatus.transferenciaSaldoRecusado:
        background = Colors.red.withOpacity(0.15);
        foreground = Colors.red.shade700;
        break;
      case HeirStatus.consultaSaldoSolicitado:
      case HeirStatus.transferenciaSaldoSolicitado:
        background = Colors.orange.withOpacity(0.15);
        foreground = Colors.orange.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status.label,
              style: AppFonts.bodySmallMedium.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
