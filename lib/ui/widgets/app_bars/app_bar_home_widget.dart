import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class AppBarHomeWidget extends PreferredSize {
  final String title;
  final Function() onTap;

  AppBarHomeWidget({super.key, required this.title, required this.onTap})
    : super(
        preferredSize: Size.fromHeight(64),
        child: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.primary5),
            child: Stack(
              children: [
                Center(child: Text(title, style: AppFonts.headlineSmall)),
              ],
            ),
          ),
        ),
      );
}
