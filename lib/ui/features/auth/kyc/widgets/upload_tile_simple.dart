import 'package:flutter/material.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/preview_place_holder.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class UploadTileSimple extends StatelessWidget {
  final String label;
  final Function() imageFront;
  final bool hasSelected;

  const UploadTileSimple({
    super.key,
    required this.label,
    required this.imageFront,
    required this.hasSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget _action(String text, VoidCallback onTap) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 180,
          maxWidth: 280,
          minHeight: 48,
        ),
        child: ElevatedButtonWidget(text: text, onTap: onTap),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;
        final previewSize = isCompact ? 68.0 : 84.0;

        final labelText = Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        );

        final preview = PreviewPlaceholder(size: previewSize);

        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isCompact ? WrapAlignment.start : WrapAlignment.end,
          children: [
            _action('Anexar frente', () {
              imageFront.call();
            }),
          ],
        );

        final contentRow = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            preview,
            const SizedBox(width: 12),
            Expanded(child: labelText),
            const SizedBox(width: 8),
            actions,
          ],
        );

        final contentColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                preview,
                const SizedBox(width: 12),
                Expanded(child: labelText),
              ],
            ),
            const SizedBox(height: 10),
            actions,
            Text(
              hasSelected ? "Imagem salva" : "",
              style: TextStyle(color: Colors.white),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceVariant.withOpacity(.35),
            borderRadius: BorderRadius.circular(14),
          ),
          child: isCompact ? contentColumn : contentRow,
        );
      },
    );
  }
}
