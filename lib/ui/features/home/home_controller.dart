import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/local_storage/local_storage_service.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class HomeController extends BaseController {
  final FirebaseAuthRepositoryInterface authRepository;
  final UserRepository userRepository;
  final LocalStorageService localStorageService;

  UserModel? currentUser;

  String? get address => currentUser?.address;

  double? get balance => 0;

  HomeController({
    required this.authRepository,
    required this.userRepository,
    required this.localStorageService,
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
    localStorageService.cleanAllData();
    authRepository.signOut();
  }
}
