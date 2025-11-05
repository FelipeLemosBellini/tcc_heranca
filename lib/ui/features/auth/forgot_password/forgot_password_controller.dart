import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class ForgotPasswordController extends BaseController {
  final FirebaseAuthRepositoryInterface firebaseAuthRepository;

  ForgotPasswordController({required this.firebaseAuthRepository});

  Future<bool> sendEmailToResetPassword(String email) async {
    setLoading(true);
    bool successSendEmail = false;
     Either<ExceptionMessage, void> response =
        await firebaseAuthRepository.forgotPassword(email: email);
    response.fold((ExceptionMessage error) {
       setMessage(AlertData(message: error.errorMessage, errorType: ErrorType.error));
     }, (_) {
      successSendEmail = true;
     });
    Future.delayed(Duration(seconds: 2));
    setLoading(false);
    return successSendEmail;
  }
}
