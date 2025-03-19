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
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.navyBlue,
          selectionColor: Colors.black26,
          selectionHandleColor: AppColors.navyBlue,
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
      ),
      routerConfig: RouterApp.router,
    );
  }
}
