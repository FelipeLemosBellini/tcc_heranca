import 'package:open_filex/open_filex.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class SeeDetailsInheritanceController extends BaseController {
  final InheritanceRepository inheritanceRepository;
  final StorageRepository storageRepository;

  SeeDetailsInheritanceController({
    required this.inheritanceRepository,
    required this.storageRepository,
  });

  List<Document> _documents = [];

  List<Document> get documents => _documents;

  Future<void> loadDocuments({
    required String requesterId,
    required String testatorCpf,
  }) async {
    if (requesterId.isEmpty || testatorCpf.isEmpty) return;
    setLoading(true);
    final result = await inheritanceRepository.getDocumentsByInheritance(
      requesterId: requesterId,
      testatorCpf: testatorCpf,
    );

    result.fold(
      (error) {
        setMessage(
          AlertData(
            message: error.errorMessage,
            errorType: ErrorType.error,
          ),
        );
      },
      (docs) {
        _documents = docs;
        notifyListeners();
      },
    );

    setLoading(false);
  }

  Future<void> openDocument(Document document) async {
    if (document.pathStorage == null || document.pathStorage!.isEmpty) {
      setMessage(
        AlertData(
          message: 'Documento sem arquivo vinculado.',
          errorType: ErrorType.warning,
        ),
      );
      return;
    }

    setLoading(true);
    final file = await storageRepository.getFile(path: document.pathStorage!);
    if (file == null) {
      setMessage(
        AlertData(
          message: 'Não foi possível abrir o documento.',
          errorType: ErrorType.error,
        ),
      );
    } else {
      await OpenFilex.open(file.path);
    }
    setLoading(false);
  }
}
