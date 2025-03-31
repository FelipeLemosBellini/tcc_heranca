import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';

class HomeController extends BaseController {
  FirebaseAuthRepositoryInterface authRepository;

  HomeController({required this.authRepository});

  void signOut() {
    authRepository.signOut();
  }
}
