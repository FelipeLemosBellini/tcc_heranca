import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/auth_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class HomeController extends BaseController {
  final AuthRepositoryInterface authRepository;
  final UserRepositoryInterface userRepository;

  UserModel? currentUser;

  String? get address => currentUser?.address;

  double? get balance => 0;

  HomeController({
    required this.authRepository,
    required this.userRepository,
  });

  Future<void> loadUserData() async {
    // setLoading(true);

    final result = await userRepository.getUser();

    result.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Erro ao carregar dados do usuário",
            errorType: ErrorType.error,
          ),
        );
      },
      (user) {
        currentUser = user;
      },
    );

    // setLoading(false);
  }

  void signOut() {
    authRepository.signOut();
  }
}
