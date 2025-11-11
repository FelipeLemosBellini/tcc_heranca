import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/app_widget.dart';
import 'package:tcc/core/dependence_injection/di.dart';
import 'package:tcc/core/environment/env.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //start environment variables
  await Env.start();

  //start supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseKey,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
      autoRefreshToken: true,
    ),
  );

  await DI.setDependencies();

  await GetIt.I.allReady();

  runApp(MyApp());
}
