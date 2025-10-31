import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testator_summary.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class ListUserTestatorsController extends BaseController {
  final BackofficeFirestoreInterface backofficeFirestoreInterface;

  ListUserTestatorsController({required this.backofficeFirestoreInterface});

  List<TestatorSummary> _testators = [];

  List<TestatorSummary> get testators => _testators;

  Future<void> loadTestators({required String requesterId}) async {
    _testators = [];
    notifyListeners();
    setLoading(true);
    final result = await backofficeFirestoreInterface.getTestatorsByRequester(
      requesterId: requesterId,
    );

    result.fold((error) {
      setMessage(
        AlertData(
          message: error.errorMessage,
          errorType: ErrorType.error,
        ),
      );
    }, (success) {
      _testators = success;
      notifyListeners();
    });
    setLoading(false);
  }
}
