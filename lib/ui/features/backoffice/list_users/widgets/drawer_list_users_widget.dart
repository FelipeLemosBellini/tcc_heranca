import 'package:flutter/material.dart';
import 'package:tcc/ui/features/home/widgets/drawer/base_drawer_widget.dart';
import 'package:tcc/ui/features/home/widgets/drawer/sign_out_widget.dart';

class DrawerListUsersWidget extends StatelessWidget {
  final Function() signOut;

  const DrawerListUsersWidget({super.key, required this.signOut});

  @override
  Widget build(BuildContext context) {
    return BaseDrawerWidget(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [const Spacer(), SignOutWidget(onTap: signOut)],
        ),
      ),
    );
  }
}
