import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

import '../../../../core/exceptions/exception_message.dart';

class CreateAccountController extends BaseController {
  final FirebaseAuthRepository firebaseAuthRepository;
  final FirestoreRepository firestoreRepository;

  CreateAccountController({
    required this.firebaseAuthRepository,
    required this.firestoreRepository,
  });

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    String? uid;
    bool successCreateAccount = false;

    Either<ExceptionMessage, String> response = await firebaseAuthRepository
        .createAccount(email: email, password: password);

    response.fold(
          (ExceptionMessage error) {
        setMessage(
          AlertData(
            message: error.errorMessage,
            errorType: ErrorType.error,
          ),
        );
      },
          (String success) {
        uid = success;
        successCreateAccount = true;
        setMessage(
          AlertData(
            message: "Conta criada com sucesso",
            errorType: ErrorType.success,
          ),
        );
      },
    );

    await Future.delayed(Duration(seconds: 2));
    setLoading(false);
    return successCreateAccount;
  }
}
