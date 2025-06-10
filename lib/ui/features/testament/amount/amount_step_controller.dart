import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class AmountStepController extends BaseController {
  final FirestoreRepository firestoreRepository;

  TestamentController testamentController = GetIt.I.get<TestamentController>();

  AmountStepController({required this.firestoreRepository});

  final TextEditingController _amountController = TextEditingController();

  TextEditingController get amountController => _amountController;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      _amountController.text = testamentController.testament.value.toString();
    }
  }

  Future<Either<Exception, UserModel>> getUser() async {
    final result = await firestoreRepository.getUser();

    return result.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Erro ao carregar dados do usuário",
            errorType: ErrorType.error,
          ),
        );
        notifyListeners();
        return Left(error);
      },
      (user) {
        return Right(user);
      },
    );
  }

  void clearTestament() {
    testamentController.clearTestament();
  }

  Future<Either<Exception, Unit>> setAmount(
    double value,
    FlowTestamentEnum flow,
  ) async {
    final userResult = await getUser();

    return userResult.fold(
      (error) {
        return Left(error);
      },
      (user) async {
        double availableBalance = user.balance;

        if (flow == FlowTestamentEnum.edit) {
          final oldTestamentResult = await firestoreRepository
              .getTestamentByAddress(user.address);

          double oldValue = 0.0;
          oldTestamentResult.fold(
            (error) {
              oldValue = 0.0;
            },
            (oldTestament) {
              oldValue = oldTestament.value;
            },
          );

          availableBalance += oldValue;
        }

        if (availableBalance >= value) {
          testamentController.setValue(value);
          return const Right(unit);
        } else {
          return Left(Exception("Saldo insuficiente"));
        }
      },
    );
  }
}
