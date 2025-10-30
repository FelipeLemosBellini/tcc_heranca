import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';

class ListUsersController extends BaseController {
  final BackofficeFirestoreInterface backofficeFirestoreInterface;

  ListUsersController({required this.backofficeFirestoreInterface});

  List<UserModel> _users = [];
  EnumDocumentsFrom? _selectedFilter;

  List<UserModel> get listUsers => _users;
  EnumDocumentsFrom? get selectedFilter => _selectedFilter;

  Future<void> getUsers({EnumDocumentsFrom? from}) async {
    _selectedFilter = from;
    var response = await backofficeFirestoreInterface.getUsersPendentes(
      from: from,
    );

    response.fold((error) {}, (success) {
      _users = success;
      notifyListeners();
    });
  }
}
