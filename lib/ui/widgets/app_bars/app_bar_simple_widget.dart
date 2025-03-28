import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class AppBarSimpleWidget extends PreferredSize {
  final String title;
  final Function() onTap;

  AppBarSimpleWidget({super.key, required this.title, required this.onTap})
    : super(
        preferredSize: Size.fromHeight(64),
        child: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.arrow_back, size: 24, color: Colors.white),
                  ),
                ),
              ),
              Center(child: Text(title, style: AppFonts.headlineSmall)),
            ],
          ),
        ),
      );
}
