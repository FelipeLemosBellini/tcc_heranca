import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class BottomNavigationBarHomeWidget extends StatelessWidget {
  final int selectedIndex;

  final Function(int) onItemTapped;

  const BottomNavigationBarHomeWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      destinations: [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Carteira',
        ),
        NavigationDestination(icon: Icon(Icons.assured_workload), label: 'Testador'),
        NavigationDestination(icon: Icon(Icons.balance), label: 'Herdeiro'),
      ],
    );
  }
}
