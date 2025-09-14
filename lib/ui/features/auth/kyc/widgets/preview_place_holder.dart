import 'package:flutter/material.dart';

class PreviewPlaceholder extends StatelessWidget {
  final double size;

  const PreviewPlaceholder({super.key, this.size = 84});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceVariant.withOpacity(.25);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: bg,
        child: const Icon(Icons.image, size: 32),
      ),
    );
  }
}
