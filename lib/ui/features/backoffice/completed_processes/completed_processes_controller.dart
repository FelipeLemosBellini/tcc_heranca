import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class CompletedProcessesController extends BaseController {
  final BackofficeFirestoreInterface backofficeFirestoreInterface;

  CompletedProcessesController({required this.backofficeFirestoreInterface});

  List<RequestInheritanceModel> _processes = [];

  List<RequestInheritanceModel> get processes => _processes;

  Future<void> loadCompleted() async {
    setLoading(true);
    final result =
        await backofficeFirestoreInterface.getCompletedInheritances();

    await result.fold(
      (error) async {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (list) async {
        _processes = list;
        notifyListeners();
      },
    );
    setLoading(false);
  }
}
