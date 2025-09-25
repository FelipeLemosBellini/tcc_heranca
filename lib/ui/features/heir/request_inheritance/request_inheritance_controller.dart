import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';

class RequestInheritanceController extends BaseController {
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final InheritanceRepository inheritanceRepository;

  RequestInheritanceController({
    required this.userRepository,
    required this.storageRepository,
    required this.inheritanceRepository,
  });

  Future<void> createRequestInheritance({
    required String cpf,
    required String rg,
    required XFile procuracaoDoInventariante,
    required XFile certidaoDeObito,
    required XFile documentoCpf,
    required XFile enderecoDoInventariante,
    required XFile testamento,
    required XFile transferenciaDeAtivos,
  }) async {}
}
