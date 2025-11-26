import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_repository.dart';
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository.dart';
import 'package:tcc/core/repositories/firebase_auth/auth_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository_interface.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/ui/features/auth/create_account/create_account_controller.dart';
import 'package:tcc/ui/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:tcc/ui/features/auth/login/login_controller.dart';
import 'package:tcc/ui/features/auth/login_wallet/login_wallet_controller.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';
import 'package:tcc/ui/features/backoffice/completed_processes/completed_processes_controller.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_testators_controller.dart';
import 'package:tcc/ui/features/backoffice/list_users/list_users_controller.dart';
import 'package:tcc/ui/features/heir/heir/heir_controller.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_controller.dart';
import 'package:tcc/ui/features/heir/request_vault/request_vault_controller.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/see_details_inheritance_controller.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/testator/testator/testator_controller.dart';
import 'package:tcc/ui/features/vault/vault_controller.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_controller.dart';

abstract class DI {
  static final GetIt getIt = GetIt.instance;

  static Future<void> setDependencies() async {
    getIt.registerLazySingleton<EventBus>(() => EventBus());

    //Controllers Notifiers
    getIt.registerLazySingleton(() => TestamentController());

    await getIt.allReady();
    //Repositories
    getIt.registerSingleton<BlockchainRepository>(BlockchainRepository());
    getIt.registerSingleton<UserRepository>(UserRepository());
    getIt.registerLazySingleton<StorageRepository>(() => StorageRepository());
    getIt.registerLazySingleton<KycRepositoryInterface>(
      () => KycRepository(storageRepository: getIt.get<StorageRepository>()),
    );
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    getIt.registerLazySingleton<BackofficeFirestoreInterface>(
      () => BackofficeFirestoreRepository(),
    );
    getIt.registerLazySingleton<InheritanceRepositoryInterface>(
      () => InheritanceRepository(
        storageRepository: getIt.get<StorageRepository>(),
      ),
    );

    //Controllers
    getIt.registerFactory<MaterialDesignController>(
      () => MaterialDesignController(),
    );
    getIt.registerFactory<ForgotPasswordController>(
      () => ForgotPasswordController(
        firebaseAuthRepository: getIt.get<AuthRepository>(),
      ),
    );
    getIt.registerFactory<CreateAccountController>(
      () => CreateAccountController(
        userRepository: getIt.get<UserRepository>(),
        authRepository: getIt.get<AuthRepository>(),
      ),
    );
    getIt.registerFactory(
      () => LoginController(
        firebaseAuthRepository: getIt.get<AuthRepository>(),
        userRepository: getIt.get<UserRepository>(),
        kycRepository: getIt.get<KycRepositoryInterface>(),
      ),
    );
    getIt.registerFactory(() => LoginWalletController());

    getIt.registerFactory<RequestInheritanceController>(
      () => RequestInheritanceController(
        inheritanceRepository: getIt.get<InheritanceRepositoryInterface>(),
      ),
    );

    getIt.registerFactory<RequestVaultController>(
      () => RequestVaultController(
        inheritanceRepository: getIt.get<InheritanceRepositoryInterface>(),
        userRepository: getIt.get<UserRepository>(),
      ),
    );

    getIt.registerFactory<KycController>(
      () => KycController(
        kycRepository: getIt.get<KycRepositoryInterface>(),
        userRepository: getIt.get<UserRepository>(),
      ),
    );

    //Controllers LazySingletons
    getIt.registerLazySingleton(
      () => HomeController(
        authRepository: getIt.get<AuthRepository>(),
        userRepository: getIt.get<UserRepository>(),
        blockchainRepository: getIt.get<BlockchainRepository>(),
      ),
    );
    getIt.registerLazySingleton(
      () => TestatorController(
        blockchainRepository: getIt.get<BlockchainRepository>(),
        userRepository: getIt.get<UserRepository>(),
      ),
    );
    getIt.registerLazySingleton(
      () => HeirController(
        inheritanceRepository: getIt.get<InheritanceRepositoryInterface>(),
      ),
    );

    getIt.registerFactory(
      () => ListUsersController(
        backofficeFirestoreInterface: getIt.get<BackofficeFirestoreInterface>(),
      ),
    );

    getIt.registerFactory(
      () => ListUserTestatorsController(
        backofficeFirestoreInterface: getIt.get<BackofficeFirestoreInterface>(),
      ),
    );

    getIt.registerFactory(
      () => ListUserDocumentsController(
        storageRepository: getIt.get<StorageRepository>(),
        backofficeFirestoreInterface: getIt.get<BackofficeFirestoreInterface>(),
        blockchainRepository: getIt.get<BlockchainRepository>(),
        userRepositoryInterface: getIt.get<UserRepository>(),
        inheritanceRepository: getIt.get<InheritanceRepositoryInterface>(),
      ),
    );

    getIt.registerFactory(
      () => CompletedProcessesController(
        backofficeFirestoreInterface: getIt.get<BackofficeFirestoreInterface>(),
      ),
    );

    getIt.registerFactory<VaultController>(
      () => VaultController(
        blockchainRepository: getIt.get<BlockchainRepository>(),
      ),
    );
    getIt.registerFactory<SeeDetailsInheritanceController>(
      () => SeeDetailsInheritanceController(
        inheritanceRepository: getIt.get<InheritanceRepositoryInterface>(),
        storageRepository: getIt.get<StorageRepository>(),
      ),
    );
  }
}
