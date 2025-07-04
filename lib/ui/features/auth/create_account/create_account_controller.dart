import 'dart:math' as math;

import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:web3dart/credentials.dart';

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

    await response.fold(
      (ExceptionMessage error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (String userId) async {
        final newUser = UserModel(
          uid: userId,
          name: name,
          email: email,
          address: await generateWalletAddress(),
          balance: 1.0,
        );

        final profileResponse = await firestoreRepository.createProfile(
          userId,
          newUser,
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

  Future<String> generateWalletAddress() async {
    final credentials = EthPrivateKey.createRandom(math.Random.secure());
    final address = await credentials.extractAddress();
    return address.hexEip55;
  }
}
