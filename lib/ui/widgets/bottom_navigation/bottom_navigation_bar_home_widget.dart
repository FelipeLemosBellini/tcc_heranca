import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          icon: Icon(CupertinoIcons.money_dollar),
          selectedIcon: Icon(CupertinoIcons.money_dollar),
          label: 'Cofre',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Herdeiro',
        ),
      ],
    );
  }
}
