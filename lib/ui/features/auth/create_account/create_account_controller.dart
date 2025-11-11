import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/auth_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class CreateAccountController extends BaseController {
  final AuthRepositoryInterface authRepository;
  final UserRepositoryInterface userRepository;

  CreateAccountController({
    required this.authRepository,
    required this.userRepository,
  });

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    bool successCreateAccount = false;

    Either<ExceptionMessage, String> response = await authRepository
        .createAccount(email: email, password: password);

    await response.fold(
      (ExceptionMessage error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (String userId) async {
        final newUser = UserModel(
          id: userId,
          name: name,
          email: email,
          kycStatus: KycStatus.waiting,
          createdAt: DateTime.now(),
        );

        final profileResponse = await userRepository.createProfile(
          newUser,
          userId,
        );

        profileResponse.fold(
          (error) {
            successCreateAccount = false;
            setMessage(
              AlertData(
                message: "Erro ao salvar perfil: ${error.errorMessage}",
                errorType: ErrorType.error,
              ),
            );
          },
          (_) {
            successCreateAccount = true;
            setMessage(
              AlertData(
                message: "Conta criada com sucesso!",
                errorType: ErrorType.success,
              ),
            );
          },
        );
      },
    );

    await Future.delayed(Duration(seconds: 2));
    setLoading(false);
    return successCreateAccount;
  }
}
