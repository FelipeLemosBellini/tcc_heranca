import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_controller.dart';
import 'package:tcc/ui/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/features/auth/login/login_controller.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_controller.dart';
import 'package:tcc/ui/features/heir/heir_controller.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/home/wallet/wallet_controller.dart';
import 'package:tcc/ui/features/testament/address/address_step_controller.dart';
import 'package:tcc/ui/features/testament/amount/amount_step_controller.dart';
import 'package:tcc/ui/features/testament/plan/plan_step_controller.dart';
import 'package:tcc/ui/features/testament/prove_of_life/prove_of_live_step_controller.dart';
import 'package:tcc/ui/features/testament/summary/summary_controller.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_controller.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_controller.dart';

abstract class DI {
  static final GetIt getIt = GetIt.instance;

  static void setDependencies() {

    getIt.registerLazySingleton<EventBus>(() => EventBus());

    //Controllers Notifiers
    getIt.registerLazySingleton(() => TestamentController());

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
    getIt.registerFactory(() => LoginWalletController());
    getIt.registerFactory(() => AddressStepController());
    getIt.registerFactory(() => AmountStepController());
    getIt.registerFactory(() => ProveOfLiveStepController());
    getIt.registerFactory(() => SummaryController());
    getIt.registerFactory(() => SeeDetailsController());
    getIt.registerFactory(() => PlanStepController());

    //Controllers LazySingletons
    getIt.registerLazySingleton(() => HomeController(authRepository: FirebaseAuthRepository(), firestoreRepository: FirestoreRepository()));
    getIt.registerLazySingleton(() => TestatorController());
    getIt.registerLazySingleton(() => HeirController());
    getIt.registerLazySingleton(() => WalletController());
  }
}
