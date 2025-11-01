import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class ListUserDocumentsController extends BaseController {
  final KycRepositoryInterface kycRepositoryInterface;
  final StorageRepository storageRepository;
  final BackofficeFirestoreInterface backofficeFirestoreInterface;

  ListUserDocumentsController({
    required this.kycRepositoryInterface,
    required this.storageRepository,
    required this.backofficeFirestoreInterface,
  });

  List<Document> _documents = [];
  List<TextEditingController> reasonControllers = [];
  List<FocusNode> focusNodes = [];
  String? _currentTestatorCpf;
  bool _hasFinalDocuments = false;

  final Map<String, bool?> decisions = {};

  List<Document> get listDocuments => _documents;
  String? get currentTestatorCpf => _currentTestatorCpf;
  bool get hasFinalDocuments => _hasFinalDocuments;

  @override
  void dispose() {
    for (var controller in reasonControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  Future<void> getDocumentsByUserId({
    required String userId,
    String? testatorCpf,
    EnumDocumentsFrom? from,
  }) async {
    _currentTestatorCpf = testatorCpf;

    for (final controller in reasonControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    reasonControllers = [];
    focusNodes = [];
    decisions.clear();

    setLoading(true);

    final response = await backofficeFirestoreInterface.getDocumentsByUserId(
      userId: userId,
      testatorCpf: testatorCpf,
      from: from,
    );

    response.fold((error) {
      setMessage(
        AlertData(
          message: error.errorMessage,
          errorType: ErrorType.error,
        ),
      );
    }, (success) {
      _documents = success;
      _hasFinalDocuments = _documents.any((doc) =>
          doc.typeDocument == TypeDocument.transferAssetsOrder ||
          doc.typeDocument == TypeDocument.testamentDocument ||
          doc.typeDocument == TypeDocument.inventoryProcess);
      for (int i = 0; i < _documents.length; i++) {
        reasonControllers.add(TextEditingController());
        focusNodes.add(FocusNode());
      }
      notifyListeners();
    });

    setLoading(false);
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
    var response = await backofficeFirestoreInterface.updateStatusUser(
      hasInvalidDocument: hasInvalidDocument,
      userId: userId,
    );
    setLoading(false);
  }

  Future<void> updateInheritanceStatus({
    required bool hasInvalidDocuments,
    required String requesterId,
    required String testatorCpf,
  }) async {
    if (testatorCpf.isEmpty) return;
    final status = hasFinalDocuments
        ? (hasInvalidDocuments
            ? HeirStatus.transferenciaSaldoRecusado
            : HeirStatus.transferenciaSaldoRealizada)
        : (hasInvalidDocuments
            ? HeirStatus.consultaSaldoRecusado
            : HeirStatus.consultaSaldoAprovado);
    final result = await backofficeFirestoreInterface.updateInheritanceStatus(
      requesterId: requesterId,
      testatorCpf: testatorCpf,
      status: status,
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
      (_) {},
    );
  }

  Future<File?> getFile({required String path}) async {
    var response = await storageRepository.getFile(path: path);
    return response;
  }

  void openPdf(String path) async {
    setLoading(true);
    File? response = await getFile(path: path);
    if (response != null) {
      OpenFilex.open(response.absolute.path, type: 'application/pdf');
    }
    setLoading(false);
  }
}
