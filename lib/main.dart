import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/app_widget.dart';
import 'package:tcc/core/dependence_injection/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDP5sJRjZlHkXd0r4qynDsZG355CE6-_B8",
      appId: "tcc-heranca",
      messagingSenderId: "",
      projectId: "tcc-heranca",
      storageBucket: "tcc-heranca.firebasestorage.app",
    ),
  );
  DI.setDependencies();
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => MyApp(),
  // ));
  runApp(MyApp());
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => const MyApp(),
  // ));*/
}
