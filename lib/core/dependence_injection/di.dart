import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/local_storage/local_storage_service.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_controller.dart';
import 'package:tcc/ui/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/features/auth/login/login_controller.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_controller.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/features/backoffice/list_users/list_users_controller.dart';
import 'package:tcc/ui/features/heir/heir/heir_controller.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_controller.dart';
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

  static void setDependencies() async {
    getIt.registerLazySingleton<EventBus>(() => EventBus());

    //Controllers Notifiers
    getIt.registerLazySingleton(() => TestamentController());

    //Local Storage
    getIt.registerSingletonAsync<LocalStorageService>(
      () async => LocalStorageService.init(),
    );

    await getIt.allReady();
    //Repositories
    getIt.registerSingleton<FirestoreRepository>(FirestoreRepository());
    getIt.registerLazySingleton<StorageRepository>(() => StorageRepository());
    getIt.registerLazySingleton<KycRepository>(
      () => KycRepository(storageRepository: getIt.get<StorageRepository>()),
    );
    getIt.registerLazySingleton<FirebaseAuthRepository>(
      () => FirebaseAuthRepository(),
    );
    getIt.registerLazySingleton<BackofficeFirestoreRepository>(
      () => BackofficeFirestoreRepository(),
    );

    //Controllers
    getIt.registerFactory<MaterialDesignController>(
      () => MaterialDesignController(),
    );
    getIt.registerFactory<ForgotPasswordController>(
      () => ForgotPasswordController(
        firebaseAuthRepository: getIt.get<FirebaseAuthRepository>(),
      ),
    );
    getIt.registerFactory<CreateAccountController>(
      () => CreateAccountController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
        firebaseAuthRepository: getIt.get<FirebaseAuthRepository>(),
      ),
    );
    getIt.registerFactory(
      () => LoginController(
        firebaseAuthRepository: FirebaseAuthRepository(),
        firestoreRepositoryInterface: getIt.get<FirestoreRepository>(),
        localStorageService: getIt.get<LocalStorageService>(),
        kycRepository: getIt.get<KycRepository>(),
      ),
    );
    getIt.registerFactory(() => LoginWalletController());
    getIt.registerFactory(() => AddressStepController());
    getIt.registerFactory(
      () => AmountStepController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
      ),
    );
    getIt.registerFactory(() => ProveOfLiveStepController());
    getIt.registerFactory(
      () => SummaryController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
      ),
    );
    getIt.registerFactory(
      () => SeeDetailsController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
      ),
    );
    getIt.registerFactory<PlanStepController>(() => PlanStepController());
    getIt.registerFactory<RequestInheritanceController>(
      () => RequestInheritanceController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
      ),
    );
    getIt.registerFactory<KycController>(
      () => KycController(
        kycRepository: KycRepository(
          storageRepository: getIt.get<StorageRepository>(),
        ),
      ),
    );

    //Controllers LazySingletons
    getIt.registerLazySingleton(
      () => HomeController(
        authRepository: getIt.get<FirebaseAuthRepository>(),
        firestoreRepository: getIt.get<FirestoreRepository>(),
        localStorageService: getIt.get<LocalStorageService>(),
      ),
    );
    getIt.registerLazySingleton(
      () => TestatorController(
        firestoreRepository: getIt.get<FirestoreRepository>(),
      ),
    );
    getIt.registerLazySingleton(
      () =>
          HeirController(firestoreRepository: getIt.get<FirestoreRepository>()),
    );
    getIt.registerLazySingleton(() => WalletController());

    getIt.registerFactory(
      () => ListUsersController(
        backofficeFirestoreInterface:
            getIt.get<BackofficeFirestoreRepository>(),
      ),
    );

    getIt.registerFactory(
      () => ListUserDocumentsController(
        kycRepositoryInterface: getIt.get<KycRepository>(),
      ),
    );
  }
}
