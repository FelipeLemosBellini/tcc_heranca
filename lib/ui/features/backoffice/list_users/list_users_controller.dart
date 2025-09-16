import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';

class ListUsersController extends BaseController{
  final BackofficeFirestoreInterface backofficeFirestoreInterface;

  ListUsersController({required this.backofficeFirestoreInterface});

  List<UserModel> _users = [];

  List<UserModel> get listUsers => _users;

  Future<void> getUsers() async{
    var response = await backofficeFirestoreInterface.getUsers();

    response.fold((error){}, (success){
      _users = success;
    });
  }

}