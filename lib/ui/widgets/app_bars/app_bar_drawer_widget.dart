import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class AppBarDrawerWidget extends PreferredSize {
  final String title;
  final Function() openDrawer;

  AppBarDrawerWidget({super.key, required this.title, required this.openDrawer})
    : super(
        preferredSize: Size.fromHeight(64),
        child: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.primary5),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(onPressed: openDrawer, icon: Icon(Icons.menu)),
                  ),
                ),
                Center(child: Text(title, style: AppFonts.labelHeadBold)),
              ],
            ),
          ),
        ),
      );
}
