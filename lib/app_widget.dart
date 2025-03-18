import 'package:flutter/material.dart';
import 'package:tcc/core/routers/routers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: RouterApp.router,
    );
  }
}
