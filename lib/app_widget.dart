import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.primary7,
        primaryColor: AppColors.primary,
        indicatorColor: AppColors.primary,
        progressIndicatorTheme: ProgressIndicatorThemeData(),
        dividerTheme: DividerThemeData(
          endIndent: 1,
          indent: 1,
          space: 1,
          thickness: 1,
          color: AppColors.gray5,
        ),
        navigationBarTheme: NavigationBarThemeData(
          surfaceTintColor: Colors.black,
          backgroundColor: AppColors.primary5,
          elevation: 1,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((Set<WidgetState> states) {
            return states.contains(WidgetState.selected)
                ? AppFonts.labelSmallBold
                : AppFonts.labelSmallLight;
          }),
          indicatorColor: AppColors.primary2,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: AppColors.primary,
          selectionHandleColor: AppColors.primary,
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
      ),
      routerConfig: RouterApp.router,
    );
  }
}
