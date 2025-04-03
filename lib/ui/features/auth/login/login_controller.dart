import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class LoginController extends BaseController {
  final FirebaseAuthRepositoryInterface firebaseAuthRepository;

  LoginController({required this.firebaseAuthRepository});

  Future<bool> login(String email, String password) async {
    setLoading(true);
    bool loginSuccess = false;

     Either<ExceptionMessage, bool> response =
         await firebaseAuthRepository.login(email: email, password: password);
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
    setLoading(false);
    return loginSuccess;
  }
}
