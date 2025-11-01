import 'package:flutter/material.dart';
import 'package:tcc/ui/features/home/widgets/drawer/base_drawer_widget.dart';
import 'package:tcc/ui/features/home/widgets/drawer/sign_out_widget.dart';

class DrawerListUsersWidget extends StatelessWidget {
  final VoidCallback goToPending;
  final VoidCallback goToCompleted;
  final VoidCallback signOut;

  const DrawerListUsersWidget({
    super.key,
    required this.goToPending,
    required this.goToCompleted,
    required this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDrawerWidget(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.people_alt_outlined, color: Colors.white),
              title: const Text('Usuários pendentes', style: TextStyle(color: Colors.white)),
              onTap: goToPending,
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in_outlined, color: Colors.white),
              title: const Text('Processos finalizados', style: TextStyle(color: Colors.white)),
              onTap: goToCompleted,
            ),
            const Spacer(),
            SignOutWidget(onTap: signOut),
          ],
        ),
      ),
    );
  }
}
