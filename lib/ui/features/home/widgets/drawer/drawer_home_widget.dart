import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/features/home/widgets/drawer/base_drawer_widget.dart';
import 'package:tcc/ui/features/home/widgets/drawer/sign_out_widget.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

import 'item_drawer_widget.dart' show ItemDrawerWidget;

class DrawerHomeWidget extends StatefulWidget {
  final Function()? signOut;
  final Function()? openHome;
  final Function()? openAboutUs;
  final bool isHome;
  final bool isAboutUs;

  const DrawerHomeWidget({
    super.key,
    required this.signOut,
    this.openHome,
    this.openAboutUs,
    this.isHome = false,
    this.isAboutUs = false,
  });

  @override
  State<DrawerHomeWidget> createState() => _DrawerHomeWidgetState();
}

class _DrawerHomeWidgetState extends State<DrawerHomeWidget> {
  bool isHistoryTransactions = false;
  bool isDocumentation = false;
  bool isRoadmap = false;
  bool isInSettings = false;

  @override
  Widget build(BuildContext context) {
    return BaseDrawerWidget(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ethernium", style: AppFonts.labelLargeRegular),
            SizedBox(height: 16),
            ItemDrawerWidget(
              title: "Home",
              onTap: () {
                if (!widget.isHome) widget.openHome?.call();
              },
              iconEnable: Icons.home,
              iconDisable: Icons.home_outlined,
              isIn: widget.isHome,
            ),
            ItemDrawerWidget(
              title: "Sobre nós",
              onTap: () {
                if (!widget.isAboutUs) widget.openAboutUs?.call();
              },
              iconEnable: Icons.people,
              iconDisable: Icons.people_alt_outlined,
              isIn: widget.isAboutUs,
            ),

            const Spacer(),
            SignOutWidget(onTap: () => widget.signOut?.call()),
          ],
        ),
      ),
    );
  }
}
