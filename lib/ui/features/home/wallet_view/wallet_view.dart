
import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final String enderecoUsuario = "0x1234...ABCD";

  final double saldoEth = 2.345;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Para evitar overflow
            children: [
              Text(
                "Saldo da Conta",
                style: AppFonts.labelMediumMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "$saldoEth ETH",
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "Endereço da Carteira",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                enderecoUsuario,
                style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
