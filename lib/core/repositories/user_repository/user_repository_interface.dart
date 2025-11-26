import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<Either<ExceptionMessage, UserModel>> getUser();

  Future<Either<ExceptionMessage, UserModel>> getUserByCpf({
    required String cpf,
  });

  Future<Either<ExceptionMessage, void>> createProfile(
    UserModel data,
    String id,
  );

  Future<Either<ExceptionMessage, String>> getUserName(String userId);

  Future<Either<ExceptionMessage, void>> setAddressUserAndHasVault(
    String address,
  );

  Future<Either<ExceptionMessage, UserModel>> getUserById({required String id});
}
