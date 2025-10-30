import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/local_storage/local_storage_service.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_controller.dart';
import 'package:tcc/ui/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/features/auth/login/login_controller.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_controller.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/features/backoffice/list_users/list_users_controller.dart';
import 'package:tcc/ui/features/heir/heir/heir_controller.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_controller.dart';
import 'package:tcc/ui/features/heir/request_vault/request_vault_controller.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/home/wallet/wallet_controller.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/features/vault/vault_controller.dart';
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
    getIt.registerSingleton<UserRepository>(UserRepository());
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
        userRepository: getIt.get<UserRepository>(),
        firebaseAuthRepository: getIt.get<FirebaseAuthRepository>(),
      ),
    );
    getIt.registerFactory(
      () => LoginController(
        firebaseAuthRepository: getIt.get<FirebaseAuthRepository>(),
        userRepository: getIt.get<UserRepository>(),
        localStorageService: getIt.get<LocalStorageService>(),
        kycRepository: getIt.get<KycRepository>(),
      ),
    );
    getIt.registerFactory(() => LoginWalletController());

    getIt.registerFactory<RequestInheritanceController>(
      () => RequestInheritanceController(
        inheritanceRepository: getIt.get<InheritanceRepository>(),
        userRepository: getIt.get<UserRepository>(),
        storageRepository: getIt.get<StorageRepository>(),
      ),
    );

    getIt.registerSingleton<InheritanceRepository>(
      InheritanceRepository(storageRepository: getIt.get<StorageRepository>()),
    );

    getIt.registerFactory<RequestVaultController>(
      () => RequestVaultController(
        inheritanceRepository: getIt.get<InheritanceRepository>(),
        userRepository: getIt.get<UserRepository>(),
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
        userRepository: getIt.get<UserRepository>(),
        localStorageService: getIt.get<LocalStorageService>(),
      ),
    );
    getIt.registerLazySingleton(() => TestatorController());
    getIt.registerLazySingleton(
      () => HeirController(userRepository: getIt.get<UserRepository>()),
    );
    getIt.registerLazySingleton(
      () => WalletController(
        userRepository: getIt.get<UserRepository>(),
        homeController: getIt.get<HomeController>(),
      ),
    );

    getIt.registerFactory(
      () => ListUsersController(
        backofficeFirestoreInterface:
            getIt.get<BackofficeFirestoreRepository>(),
      ),
    );

    getIt.registerFactory(
      () => ListUserDocumentsController(
        kycRepositoryInterface: getIt.get<KycRepository>(),
        storageRepository: getIt.get<StorageRepository>(),
        backofficeFirestoreInterface:
            getIt.get<BackofficeFirestoreRepository>(),
      ),
    );

    getIt.registerFactory(() => VaultController());
  }
}
