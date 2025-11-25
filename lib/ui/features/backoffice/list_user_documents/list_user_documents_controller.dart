import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class ListUserDocumentsController extends BaseController {
  final StorageRepositoryInterface storageRepository;
  final BackofficeFirestoreInterface backofficeFirestoreInterface;
  final BlockchainRepository blockchainRepository;
  final UserRepositoryInterface userRepositoryInterface;

  ListUserDocumentsController({
    required this.storageRepository,
    required this.backofficeFirestoreInterface,
    required this.blockchainRepository,
    required this.userRepositoryInterface,
  });

  List<Document> _documents = [];
  List<TextEditingController> reasonControllers = [];
  List<FocusNode> focusNodes = [];
  String? _currentTestatorId;
  bool _hasFinalDocuments = false;

  final Map<String, bool?> decisions = {};

  List<Document> get listDocuments => _documents;

  String? get currentTestatorId => _currentTestatorId;

  bool get hasFinalDocuments => _hasFinalDocuments;

  @override
  void dispose() {
    super.dispose();
    for (var controller in reasonControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  Future<void> getDocumentsByUserId({
    required String userId,
    String? testatorId,
    EnumDocumentsFrom? from,
  }) async {
    _currentTestatorId = testatorId;
    _hasFinalDocuments = false;

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
      testatorId: testatorId,
      from: from,
      onlyPending: testatorId != null && testatorId.isNotEmpty,
    );

    response.fold(
      (error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (success) {
        _documents = success;
        _hasFinalDocuments = _documents.any(
          (doc) =>
              doc.typeDocument == TypeDocument.transferAssetsOrder ||
              doc.typeDocument == TypeDocument.testamentDocument ||
              doc.typeDocument == TypeDocument.inventoryProcess,
        );
        for (int i = 0; i < _documents.length; i++) {
          reasonControllers.add(TextEditingController());
          focusNodes.add(FocusNode());
        }
        notifyListeners();
      },
    );

    setLoading(false);
  }

  Future<void> submit({required Document documents}) async {
    setLoading(true);
    final docId = documents.id;
    if (docId == null) {
      setLoading(false);
      return;
    }
    final decision = decisions[docId]!;

    final result = await backofficeFirestoreInterface.changeStatusDocument(
      documentId: docId,
      status: decision,
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

  Future<void> updateInheritanceStatus({
    required bool hasInvalidDocuments,
    required String requesterId,
    required String cpfTestator,
    required BuildContext context,
  }) async {
    final testatorId = _currentTestatorId;
    if (testatorId == null || testatorId.isEmpty) return;
    final status =
        hasFinalDocuments
            ? (hasInvalidDocuments
                ? HeirStatus.transferenciaSaldoRecusado
                : HeirStatus.transferenciaSaldoRealizada)
            : (hasInvalidDocuments
                ? HeirStatus.consultaSaldoRecusado
                : HeirStatus.consultaSaldoAprovado);

    if (status == HeirStatus.transferenciaSaldoRealizada ||
        status == HeirStatus.consultaSaldoAprovado) {
      UserModel? testatorModel;
      var responseAddressTestator = await userRepositoryInterface.getUserByCpf(
        cpf: cpfTestator,
      );
      await responseAddressTestator.fold((onLeft) {}, (onRight) async {
        testatorModel = onRight;
      });
      if (testatorModel == null) {
        AlertHelper.showAlertSnackBar(
          context: context,
          alertData: AlertData(
            message: "Erro ao buscar dados",
            errorType: ErrorType.error,
          ),
        );
        return;
      }
      if (status == HeirStatus.consultaSaldoAprovado) {
        var responseReown = await blockchainRepository.reownWasInitialized();
        await responseReown.fold((onLeft) {}, (wasInitialized) async {
          if (!wasInitialized) {
            await blockchainRepository.init(context: context);
            await blockchainRepository.connectWallet();
          }

          var responseBalance = await blockchainRepository
              .vaultBalanceByAddress(address: testatorModel!.address!);
          await responseBalance.fold((onLeft) {}, (BigInt balance) async {
            backofficeFirestoreInterface.sendEmailWithBalance(
              balance: balance.toString(),
              requestUserId: requesterId,
            );
          });
        });
      }
    }
    final result = await backofficeFirestoreInterface.updateInheritanceStatus(
      requesterId: requesterId,
      testatorId: testatorId,
      status: status,
    );

    await result.fold((error) {
      setMessage(
        AlertData(message: error.errorMessage, errorType: ErrorType.error),
      );
    }, (_) async {});
  }
}
