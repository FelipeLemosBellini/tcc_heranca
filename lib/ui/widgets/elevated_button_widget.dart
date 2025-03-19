import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? padding;

  const ElevatedButtonWidget({super.key, required this.text, required this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          margin: padding ?? const EdgeInsets.all(24),
          width: MediaQuery.sizeOf(context).width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4), // Sombra mais definida
                blurRadius: 25, // Mais difuso
                spreadRadius: 5, // Aumenta a área da sombra
                offset: const Offset(0, 10), // Mantém para baixo
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  }
}
