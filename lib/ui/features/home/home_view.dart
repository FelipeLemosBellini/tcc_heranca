import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const Text("Transações"),
    const Text("Configurações"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira de Cripto'),
        centerTitle: true,
      ),
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Carteira"),
          BottomNavigationBarItem(icon: Icon(Icons.assured_workload), label: "Testador"),
          BottomNavigationBarItem(icon: Icon(Icons.balance), label: "Herdeiro"),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  final String enderecoUsuario = "0x1234...ABCD";
  final double saldoEth = 2.345;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Saldo da Conta",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$saldoEth ETH",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
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
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
