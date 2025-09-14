import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class LoginController extends BaseController {
  final FirebaseAuthRepositoryInterface firebaseAuthRepository;
  final KycRepository kycRepository;

  LoginController({
    required this.kycRepository,
    required this.firebaseAuthRepository,
  });

  Future<KycStatus> login(String email, String password) async {
    setLoading(true);
    bool loginSuccess = false;

    late KycStatus kycStatus;
    Either<ExceptionMessage, bool> response = await firebaseAuthRepository
        .login(email: email, password: password);
    response.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Erro ao entrar na sua conta",
            errorType: ErrorType.error,
          ),
        );
      },
      (bool success) {
        loginSuccess = success;
      },
    );

    if (loginSuccess) {
      var responseKyc = await kycRepository.getStatusKyc();
      responseKyc.fold((error) {}, (success) {
        kycStatus = success;
      });
    }
    setLoading(false);
    return kycStatus;
  }
}
