import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.labelSmallMedium),
        const SizedBox(height: 4),
        Text(value, style: AppFonts.bodyTitleRegular),
      ],
    );
  }
}
