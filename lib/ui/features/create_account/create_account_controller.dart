import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class CreateAccountController extends BaseController {
  final FirebaseAuthRepository firebaseAuthRepository;
  final FirestoreRepository firestoreRepository;

  CreateAccountController({required this.firebaseAuthRepository, required this.firestoreRepository});

  Future<bool> createAccount({required String name, required String email, required String password}) async {
    setLoading(true);
    // String uid = "";
    bool successCreateAccount = false;
    // Either<Exception, String> response = await firebaseAuthRepository.createAccount(email: email, password: password);
    // response.fold(
    //   (error) {
    //     setMessage(AlertData(message: "Erro ao criar a conta", errorType: ErrorType.error));
    //   },
    //   (String success) async {
    //     uid = success;
    //   },
    // );
    //
    // if (uid.isNotEmpty) {
      // Either<Exception, void> responseCreateProfile = await firestoreRepository.createProfile(
      //   uid,
      //   UserModel(name: name, email: email),
      // );
      //
      // responseCreateProfile.fold(
      //   (error) {
      //     setMessage(AlertData(message: "Erro ao criar a conta", errorType: ErrorType.error));
      //   },
      //   (_) {
          successCreateAccount = true;
      //   },
      // );
    // }

    Future.delayed(Duration(seconds: 2));
    setLoading(false);
    return successCreateAccount;
  }
}
