import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class AmountStepController extends BaseController {
  final UserRepository userRepository;

  TestamentController testamentController = GetIt.I.get<TestamentController>();

  AmountStepController({required this.userRepository});

  final TextEditingController _amountController = TextEditingController();

  TextEditingController get amountController => _amountController;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      _amountController.text = testamentController.testament.value.toString();
    }
  }

  Future<Either<Exception, UserModel>> getUser() async {
    final result = await userRepository.getUser();

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
}
