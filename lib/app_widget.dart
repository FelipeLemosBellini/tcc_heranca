import 'package:flutter/material.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/helpers/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
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
