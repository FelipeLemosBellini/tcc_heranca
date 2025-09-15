import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class LoginController extends BaseController {
  final FirebaseAuthRepositoryInterface firebaseAuthRepository;
  final FirestoreRepositoryInterface firestoreRepositoryInterface;
  final KycRepository kycRepository;

  LoginController({
    required this.kycRepository,
    required this.firebaseAuthRepository,
    required this.firestoreRepositoryInterface
  });

  Future<LoginSuccess> login(String email, String password) async {
    setLoading(true);
    bool wasLogged = false;
    LoginSuccess loginSuccess = LoginSuccess();

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
        wasLogged = success;
      },
    );

    if (wasLogged) {
      var responseKyc = await kycRepository.getStatusKyc();
      responseKyc.fold((error) {}, (success) {
        loginSuccess.kycStatus = success;
      });

      var user = await firestoreRepositoryInterface.getUser();
      user.fold((error) {}, (success) {
        loginSuccess.isAdmin = success.isAdmin;
      });



    }
    setLoading(false);
    return loginSuccess;
  }
}

class LoginSuccess{
  bool? isAdmin;
  KycStatus? kycStatus;
  LoginSuccess({
    this.isAdmin,
    this.kycStatus
  });
  }
}
