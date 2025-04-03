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
          selectedIcon: Icon(Icons.account_balance_wallet),
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Carteira',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.doc_text),
          selectedIcon: Icon(CupertinoIcons.doc_text_fill), //CupertinoIcons.doc_text_fill
          label: 'Testador',
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
