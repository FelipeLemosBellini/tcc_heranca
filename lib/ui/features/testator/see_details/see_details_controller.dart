import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
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

  void updateDateProveOfLife() {
    _testamentController.setDateLastProveOfLife(DateTime.now());
  }

  void updateDateProveOfLifeTestament() async {
    var response = await firestoreRepository.getUser();

    response.fold(
          (error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
          (UserModel user) async {
        final testamentResult = await firestoreRepository.getTestamentByAddress(user.address);

        testamentResult.fold(
              (error) {
            setMessage(
              AlertData(message: error.errorMessage, errorType: ErrorType.error),
            );
          },
              (TestamentModel testament) async {
            final updatedTestament = testament.copyWith(
              lastProveOfLife: DateTime.now(),
            );

            _testamentController.setTestamentToEdit(updatedTestament);

            await firestoreRepository.updateTestament(
              addressTestator: user.address,
              testament: updatedTestament,
            );

            notifyListeners();
          },
        );
      },
    );
  }



  void deleteTestament(TestamentModel testament) async {
    var response = await firestoreRepository.getUser();

    response.fold(
      (error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (UserModel user) {
        firestoreRepository.deleteTestament(
          address: user.address,
          testament: testament,
        );
        notifyListeners();
      },
    );
  }
}
