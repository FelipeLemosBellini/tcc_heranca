import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class SeeDetailsController extends BaseController {
  final TestamentController _testamentController =
      GetIt.I.get<TestamentController>();
  final FirestoreRepository firestoreRepository;

  SeeDetailsController({required this.firestoreRepository});

  void setCurrentTestament(TestamentModel testament) {
    _testamentController.setTestamentToEdit(testament);
  }

  Future<void> updateDateProveOfLife() async {
    _testamentController.setDateLastProveOfLife(DateTime.now());
  }

  Future<Either<ExceptionMessage, void>>
  updateDateProveOfLifeTestament() async {
    ExceptionMessage? exceptionMessage;
    final response = await firestoreRepository.getUser();

    await response.fold(
      (error) async {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (UserModel user) async {
        final testamentResult = await firestoreRepository.getTestamentByAddress(
          user.address,
        );

        await testamentResult.fold(
          (error) async {
            exceptionMessage = error;
          },
          (TestamentModel testament) async {
            final updatedTestament = testament.copyWith(
              lastProveOfLife: DateTime.now(),
            );

            _testamentController.setTestamentToEdit(updatedTestament);

            var response = await firestoreRepository.updateTestament(
              addressTestator: user.address,
              testament: updatedTestament,
            );
            response.fold((error) {
              exceptionMessage = error;
            }, (_) {});
            notifyListeners();
          },
        );
      },
    );
    return exceptionMessage != null ? Left(exceptionMessage!) : Right(null);
  }

  Future<void> deleteTestament(TestamentModel testament) async {
    final response = await firestoreRepository.getUser();

    await response.fold(
      (error) async {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (UserModel user) async {
        await firestoreRepository.deleteTestament(
          address: user.address,
          testament: testament,
        );
        await firestoreRepository.updateBalance(
          userId: user.uid,
          balance: user.balance + testament.value,
        );
        notifyListeners();
      },
    );
  }

  Future<Either<ExceptionMessage, void>> rescueInheritance(
    TestamentModel testamentModel,
  ) async {
    ExceptionMessage? exceptionMessage;
    late UserModel user;
    final response = await firestoreRepository.getUser();

    await response.fold(
      (error) async {
        exceptionMessage = error;
      },
      (UserModel success) async {
        user = success;
      },
    );

    final responseRescue = await firestoreRepository.rescueInheritance(
      testamentModel,
      user.address,
    );

    await responseRescue.fold((error) async {
      exceptionMessage = error;
    }, (_) {});

    return exceptionMessage == null ? Right(null) : Left(exceptionMessage!);
  }

  Future<Either<ExceptionMessage, TestamentModel>> getTestamentByAddress(
      String address,
      ) async {
    final responseUser = await firestoreRepository.getUser();

    return await responseUser.fold(
          (error) async => Left(error),
          (user) async {
        final responseTestament = await firestoreRepository.getTestamentByAddress(user.address);

        return responseTestament.fold(
              (error) => Left(error),
              (testament) => Right(testament),
        );
      },
    );
  }

}
