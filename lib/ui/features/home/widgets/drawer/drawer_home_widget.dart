import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                onTap: () {
                  if (!widget.isHome) widget.openHome?.call();
                },
                iconEnable: Icons.home,
                iconDisable: Icons.home_outlined,
                isIn: widget.isHome,
              ),
              ItemDrawerWidget(
                title: "Transações",
                onTap: () {},
                iconEnable: Icons.history,
                iconDisable: Icons.history_outlined,
                isIn: isHistoryTransactions,
              ),
              ItemDrawerWidget(
                title: "Sobre nós",
                onTap: () {
                  if (!widget.isAboutUs) widget.openAboutUs?.call();
                },
                iconEnable: Icons.people,
                iconDisable: Icons.people_alt_outlined,
                isIn: isHistoryTransactions,
              ),
              ItemDrawerWidget(
                title: "Documentação",
                onTap: () {},
                iconEnable: Icons.menu_book,
                iconDisable: Icons.menu_book_outlined,
                isIn: isDocumentation,
              ),
              ItemDrawerWidget(
                title: "Roadmap",
                onTap: () {},
                iconEnable: Icons.rocket_launch,
                iconDisable: Icons.rocket_launch_outlined,
                isIn: isRoadmap,
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
                onTap: () => widget.signOut?.call(),
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
