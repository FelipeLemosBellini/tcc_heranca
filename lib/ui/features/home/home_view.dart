import 'package:flutter/material.dart';
import 'package:tcc/ui/features/home/wallet_view/wallet_view.dart';
import 'package:tcc/ui/features/testador/testador_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_home_widget.dart';
import 'package:tcc/ui/widgets/bottom_navigation/bottom_navigation_bar_home_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [const WalletView(), const TestadorView(), const HerdeiroScreen()];

  final List<String> _titles = ['Carteira', 'Testamentos Criados', 'Heranças Recebidas'];

  late PageController _pageController;

  void _onItemTapped(int index) {
    
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHomeWidget(title: _titles[_selectedIndex], onTap: () {}),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _screens,
      ),

      // IndexedStack(children: _screens, index: _selectedIndex),
      bottomNavigationBar: BottomNavigationBarHomeWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
