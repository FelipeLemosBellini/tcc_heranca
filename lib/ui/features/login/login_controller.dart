import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class LoginController extends BaseController {
  final FirebaseAuthRepository firebaseAuthRepository;

  LoginController({required this.firebaseAuthRepository});

  String messageError = "";

  Future<bool> login(String email, String password) async {
    setLoading(true);
    bool loginSuccess = false;

    // Either<ExceptionMessage, bool> response =
    //     await firebaseAuthRepository.login(email: email, password: password);
    // response.fold((ExceptionMessage error) {
    setMessage(AlertData(message: "Erro login", errorType: ErrorType.error));

    Future.delayed(Duration(seconds: 2));
    setMessage(AlertData(message: "warning", errorType: ErrorType.warning));

    Future.delayed(Duration(seconds: 2));
    setMessage(AlertData(message: "success", errorType: ErrorType.success));
    // }, (bool success) {
    loginSuccess = true;
    // });
    setLoading(false);
    return loginSuccess;
  }
}
