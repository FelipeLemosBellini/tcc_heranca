import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class CompletedProcessesController extends BaseController {
  final BackofficeFirestoreInterface backofficeFirestoreInterface;
  final UserRepositoryInterface userRepository;

  CompletedProcessesController({
    required this.backofficeFirestoreInterface,
    required this.userRepository,
  });

  List<RequestInheritanceModel> _processes = [];
  Map<String, String> _responsibles = {};

  List<RequestInheritanceModel> get processes => _processes;
  String responsibleNameOf(String? userId) {
    if (userId == null || userId.isEmpty) return '---';
    return _responsibles[userId] ?? '---';
  }

  Future<void> loadCompleted() async {
    setLoading(true);
    final result = await backofficeFirestoreInterface.getCompletedInheritances();

    await result.fold(
      (error) async {
        setMessage(AlertData(message: error.errorMessage, errorType: ErrorType.error));
      },
      (list) async {
        _processes = list;
        await _loadResponsibles();
        notifyListeners();
      },
    );
    setLoading(false);
  }

  Future<void> _loadResponsibles() async {
    final ids = _processes
        .map((e) => e.requestById)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    final Map<String, String> names = {};

    for (final id in ids) {
      final result = await userRepository.getUserName(id);
      result.fold(
        (error) => names[id] = '---',
        (value) => names[id] = value,
      );
    }

    _responsibles = names;
  }
}
