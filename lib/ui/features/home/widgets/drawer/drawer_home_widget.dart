import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

import 'item_drawer_widget.dart' show ItemDrawerWidget;

class DrawerHomeWidget extends StatefulWidget {
  final Function() signOut;

  const DrawerHomeWidget({super.key, required this.signOut});

  @override
  State<DrawerHomeWidget> createState() => _DrawerHomeWidgetState();
}

class _DrawerHomeWidgetState extends State<DrawerHomeWidget> {
  bool isInHome = true;
  bool isInAboutUs = false;
  bool isInSettings = false;

  void disableAll() {
    setState(() {
      isInHome = false;
      isInAboutUs = false;
      isInSettings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppColors.primary6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(20),
          ), // Arredonda apenas o lado direito
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("App", style: AppFonts.labelLargeRegular),
              SizedBox(height: 16),
              ItemDrawerWidget(
                title: "Home",
                onTap: () {},
                iconEnable: Icons.home,
                iconDisable: Icons.home_outlined,
                isIn: isInHome,
              ),
              ItemDrawerWidget(
                title: "Sobre nós",
                onTap: () {},
                iconEnable: Icons.people,
                iconDisable: Icons.people_alt_outlined,
                isIn: isInAboutUs,
              ),
              const Spacer(),
              ItemDrawerWidget(
                title: "Configurações",
                onTap: () {},
                iconEnable: Icons.settings,
                iconDisable: Icons.settings_outlined,
                isIn: isInSettings,
              ),
              GestureDetector(
                onTap: () => widget.signOut.call(),
                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.error2,
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: AppColors.error),
                      SizedBox(width: 8),
                      Text(
                        "Sair",
                        style: AppFonts.labelLargeMedium.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
