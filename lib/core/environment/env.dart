import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  //supabase credentials
  static String get supabaseUrl => dotenv.env["SUPABASE_URL"] ?? '';

  static String get supabaseKey => dotenv.env["SUPABASE_KEY"] ?? '';


  static Future<void> start() async {
    await dotenv.load(fileName: "./tcc_heranca.env");
  }
}