import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';

class ListUserDocumentsController extends BaseController{
  final KycRepositoryInterface kycRepositoryInterface;

  ListUserDocumentsController({required this.kycRepositoryInterface});

  List<UserDocument> _documents = [];

  List<UserDocument> get listDocuments => _documents;

  Future<void> getDocumentsByUserId({required String userId}) async{
    var response = await kycRepositoryInterface.getDocumentsByUserId(userId: userId);
    response.fold((error){}, (success){
      _documents = success;
    });
  }

}