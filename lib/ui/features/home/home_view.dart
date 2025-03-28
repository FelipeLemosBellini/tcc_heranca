import 'package:flutter/material.dart';
import 'package:tcc/ui/features/home/wallet_view/wallet_view.dart';
import 'package:tcc/ui/features/testador/testador_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_home_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const WalletView(),
    const TestadorView(),
    const HerdeiroScreen(),
  ];

  final List<String> _titles = [
    'Carteira',
    'Testamentos Criados',
    'Heranças Recebidas',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHomeWidget(title: _titles[_selectedIndex], onTap: () {}),
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

class HerdeiroScreen extends StatelessWidget {
  const HerdeiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Herdeiro Screen"));
  }
}
