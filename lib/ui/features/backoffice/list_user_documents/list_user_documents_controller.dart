import 'package:flutter/material.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';

class ListUserDocumentsController extends BaseController {
  final KycRepositoryInterface kycRepositoryInterface;

  ListUserDocumentsController({required this.kycRepositoryInterface});

  List<Document> _documents = [];
  List<TextEditingController> reasonControllers = [];
  List<FocusNode> focusNodes = [];

  final Map<String, bool?> decisions = {};

  List<Document> get listDocuments => _documents;

  @override
  dispose() {
    for (var controller in reasonControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  Future<void> getDocumentsByUserId({required String userId}) async {
    var response = await kycRepositoryInterface.getDocumentsByUserId(
      userId: userId,
    );
    response.fold((error) {}, (success) {
      _documents = success;
      for (int i = 0; i < _documents.length; i++) {
        reasonControllers.add(TextEditingController());
        focusNodes.add(FocusNode());
      }
      notifyListeners();
    });
  }

  Future<void> submit({required Document documents}) async {
    setLoading(true);
    final decision = decisions[documents.idDocument]!;
    final status =
        decision ? ReviewStatusDocument.approved : ReviewStatusDocument.invalid;

    final result = await kycRepositoryInterface.updateDocument(
      docId: documents.idDocument!,
      reviewStatus: status,
      reason: documents.reviewMessage,
    );

    result.fold((error) {}, (_) {});

    notifyListeners();

    setLoading(false);
  }

  Future<void> updateKycStatus({
    required bool hasInvalidDocument,
    required String userId,
  }) async {
    setLoading(true);
    var response = await kycRepositoryInterface.updateStatusUser(
      hasInvalidDocument: hasInvalidDocument,
      userId: userId,
    );
    setLoading(false);
  }
}
