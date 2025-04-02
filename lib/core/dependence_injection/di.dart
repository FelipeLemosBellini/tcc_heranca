import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/create_account/create_account_controller.dart';
import 'package:tcc/ui/features/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/login/login_controller.dart';
import 'package:tcc/ui/features/new_testament/address/address_step_controller.dart';
import 'package:tcc/ui/features/new_testament/amount/amount_step_controller.dart';
import 'package:tcc/ui/features/new_testament/prove_of_life/prove_of_live_step_controller.dart';
import 'package:tcc/ui/features/new_testament/summary/summary_controller.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_controller.dart';
import 'package:tcc/ui/features/testator/testator_controller.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_controller.dart';

abstract class DI {
  static final GetIt getIt = GetIt.instance;

  static void setDependencies() {
    //Repositories
    getIt.registerLazySingleton<FirestoreRepositoryInterface>(() => FirestoreRepository());
    getIt.registerLazySingleton<FirebaseAuthRepositoryInterface>(() => FirebaseAuthRepository());

    //Controllers

    getIt.registerFactory<MaterialDesignController>(() => MaterialDesignController());
    getIt.registerFactory<ForgotPasswordController>(
      () => ForgotPasswordController(firebaseAuthRepository: FirebaseAuthRepository()),
    );
    getIt.registerFactory<CreateAccountController>(
      () => CreateAccountController(
        firestoreRepository: FirestoreRepository(),
        firebaseAuthRepository: FirebaseAuthRepository(),
      ),
    );
    getIt.registerFactory(() => LoginController(firebaseAuthRepository: FirebaseAuthRepository()));
    getIt.registerFactory(() => HomeController(authRepository: FirebaseAuthRepository()));
    getIt.registerFactory(() => AddressStepController());
    getIt.registerFactory(() => AmountStepController());
    getIt.registerFactory(() => ProveOfLiveStepController());
    getIt.registerFactory(() => SummaryController());
    getIt.registerFactory(() => TestatorController());
    getIt.registerFactory(() => SeeDetailsController());

    //Controller Notifier Testament
    getIt.registerSingleton(() => TestamentController());
  }
}
