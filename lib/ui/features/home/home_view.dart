import 'package:flutter/material.dart';
import 'package:tcc/ui/features/testador/testador_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CarteiraScreen(),
    const TestadorView(),
    const HerdeiroScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carteira de Cripto'), centerTitle: true),
      body:
      IndexedStack(children: _screens, index: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assured_workload),
            label: 'Testador',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.balance),
            label: 'Herdeiro',
          ),
        ],
      ),
    );
  }
}

class CarteiraScreen extends StatelessWidget {
  const CarteiraScreen({super.key});

  final String enderecoUsuario = "0x1234...ABCD";
  final double saldoEth = 2.345;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Para evitar overflow
            children: [
              const Text(
                "Saldo da Conta",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class HerdeiroScreen extends StatelessWidget {
  const HerdeiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Herdeiro Screen"));
  }
}
