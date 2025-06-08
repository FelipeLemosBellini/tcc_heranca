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

    // 1. Criação da conta no Firebase Auth
    Either<ExceptionMessage, String> response = await firebaseAuthRepository
        .createAccount(email: email, password: password);

    await response.fold(
      (ExceptionMessage error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (String userId) async {
        uid = userId;

        // 2. Cria o UserModel
        final newUser = UserModel(uid: uid!, name: name, email: email);

        // 3. Salva o perfil no Firestore
        final profileResponse = await firestoreRepository.createProfile(
          uid!,
          newUser.toMap(),
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
