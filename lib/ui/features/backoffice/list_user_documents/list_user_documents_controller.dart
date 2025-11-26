import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/events/update_users_event.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class ListUserDocumentsController extends BaseController {
  final StorageRepositoryInterface storageRepository;
  final BackofficeFirestoreInterface backofficeFirestoreInterface;
  final BlockchainRepository blockchainRepository;
  final UserRepositoryInterface userRepositoryInterface;
  final InheritanceRepositoryInterface inheritanceRepository;

  ListUserDocumentsController({
    required this.storageRepository,
    required this.backofficeFirestoreInterface,
    required this.blockchainRepository,
    required this.userRepositoryInterface,
    required this.inheritanceRepository,
  });

  List<Document> _documents = [];
  List<TextEditingController> addressesControllers = [];
  List<TextEditingController> amountsControllers = [];
  List<TextEditingController> reasonControllers = [];

  List<FocusNode> reasonFocusNodes = [];
  List<FocusNode> addressFocusNodes = [];
  List<FocusNode> amountFocusNodes = [];

  EnumDocumentsFrom? newEnumDocumentsFromStatus;

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
    for (var node in reasonFocusNodes) {
      node.dispose();
    }
  }

  Future<void> getDocumentsByUserId({
    required BuildContext context,
    required String requesterId,
    String? testatorId,
    EnumDocumentsFrom? from,
  }) async {
    _currentTestatorId = testatorId;
    _hasFinalDocuments = false;
    newEnumDocumentsFromStatus = from;
    if (from != EnumDocumentsFrom.kyc && testatorId != null) {
      var responseInheritance = await inheritanceRepository
          .getInheritanceByUserIdAndTestatorId(testatorId, requesterId);
      responseInheritance.fold(
        (onLeft) {
          AlertHelper.showAlertSnackBar(
            context: context,
            alertData: AlertData(
              message: "Erro ao buscar os dados.",
              errorType: ErrorType.error,
            ),
          );
        },
        (inheritance) {
          newEnumDocumentsFromStatus =
              inheritance.heirStatus == HeirStatus.consultaSaldoSolicitado
                  ? EnumDocumentsFrom.balanceRequest
                  : EnumDocumentsFrom.inheritanceRequest;
          if (newEnumDocumentsFromStatus == EnumDocumentsFrom.balanceRequest) {
            addressesControllers.add(TextEditingController());
            addressFocusNodes.add(FocusNode());
            amountsControllers.add(TextEditingController());
            amountFocusNodes.add(FocusNode());
          }
          notifyListeners();
        },
      );
    }

    for (final controller in reasonControllers) {
      controller.dispose();
    }
    for (final node in reasonFocusNodes) {
      node.dispose();
    }
    reasonControllers = [];
    reasonFocusNodes = [];
    decisions.clear();

    setLoading(true);

    final response = await backofficeFirestoreInterface.getDocumentsByUserId(
      userId: requesterId,
      testatorId: testatorId,
      from: newEnumDocumentsFromStatus,
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
          reasonFocusNodes.add(FocusNode());
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
    bool hasError = false;
    setLoading(true);
    final testatorId = _currentTestatorId;
    if (testatorId == null || testatorId.isEmpty) {
      setMessage(
        AlertData(
          message: "Houve um erro, tente novamente mais tarde",
          errorType: ErrorType.warning,
        ),
      );
      setLoading(false);
      return;
    }
    final status =
        hasFinalDocuments
            ? (hasInvalidDocuments
                ? HeirStatus.transferenciaSaldoRecusado
                : HeirStatus.transferenciaSaldoRealizada)
            : (hasInvalidDocuments
                ? HeirStatus.consultaSaldoRecusado
                : HeirStatus.consultaSaldoAprovado);

    UserModel? testatorModel;
    var responseAddressTestator = await userRepositoryInterface.getUserByCpf(
      cpf: cpfTestator,
    );
    await responseAddressTestator.fold(
      (onLeft) {
        setMessage(
          AlertData(
            message: "Houve um erro, tente novamente mais tarde",
            errorType: ErrorType.warning,
          ),
        );
        setLoading(false);
        hasError = true;
      },
      (onRight) async {
        testatorModel = onRight;
      },
    );
    if (hasError) return;
    if (testatorModel == null) {
      setMessage(
        AlertData(message: "Erro ao buscar dados", errorType: ErrorType.error),
      );

      setLoading(false);
      return;
    }
    if (status == HeirStatus.consultaSaldoAprovado ||
        status == HeirStatus.transferenciaSaldoRealizada) {
      var responseReown = await blockchainRepository.reownWasInitialized();
      await responseReown.fold(
        (onLeft) {
          setMessage(
            AlertData(
              message: "Houve um erro, tente novamente mais tarde",
              errorType: ErrorType.warning,
            ),
          );
          setLoading(false);
          hasError = true;
        },
        (wasInitialized) async {
          if (!wasInitialized) {
            await blockchainRepository.init(context: context);
            await blockchainRepository.connectWallet();
          }
        },
      );
      if (hasError) return;
    }
    if (status == HeirStatus.consultaSaldoAprovado) {
      var responseBalance = await blockchainRepository.vaultBalanceByAddress(
        address: testatorModel!.address!,
      );
      await responseBalance.fold(
        (onLeft) {
          setMessage(
            AlertData(
              message: "Houve um erro, tente novamente mais tarde",
              errorType: ErrorType.warning,
            ),
          );
          setLoading(false);
          hasError = true;
        },
        (BigInt balance) async {
          backofficeFirestoreInterface.sendEmailWithBalance(
            balance: balance.toString(),
            requestUserId: requesterId,
            cpf: testatorModel?.cpf ?? '',
          );
        },
      );
    } else if (status == HeirStatus.transferenciaSaldoRealizada) {
      if (addressesControllers.isNotEmpty &&
          amountsControllers.length == addressesControllers.length) {
        List<String> addresses = [];
        List<BigInt> listAmounts = [];

        for (var action in addressesControllers) {
          addresses.add(action.text);
        }
        for (var action in amountsControllers) {
          listAmounts.add(BigInt.parse(action.text));
        }

        var responseDistribution = await blockchainRepository.distributeVault(
          testatorAddress: testatorModel?.address ?? "",
          amounts: listAmounts,
          addresses: addresses,
        );
        await responseDistribution.fold(
          (onLeft) {
            setMessage(
              AlertData(
                message: "Erro ao distribuir.",
                errorType: ErrorType.error,
              ),
            );
            setLoading(false);
            hasError = true;
          },
          (_) async {

          },
        );
      } else {
        setMessage(
          AlertData(
            message: "Preencha corretamente os campos",
            errorType: ErrorType.warning,
          ),
        );
        setLoading(false);
        hasError = true;
      }
    }
    if (hasError) return;
    final result = await backofficeFirestoreInterface.updateInheritanceStatus(
      requesterId: requesterId,
      testatorId: testatorId,
      status: status,
    );

    await result.fold(
      (error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
        setLoading(false);
        hasError = true;
      },
      (_) async {
        if (status == HeirStatus.consultaSaldoRecusado) {
          setMessage(
            AlertData(
              message: "Consulta reprovada",
              errorType: ErrorType.success,
            ),
          );
        }
        if (status == HeirStatus.consultaSaldoAprovado) {
          setMessage(
            AlertData(message: "Email enviado", errorType: ErrorType.success),
          );
        }
        if (status == HeirStatus.transferenciaSaldoRealizada) {
          setMessage(
            AlertData(
              message: "Distribuição iniciada",
              errorType: ErrorType.success,
            ),
          );
        }
        if (status == HeirStatus.transferenciaSaldoRecusado) {
          setMessage(
            AlertData(
              message: "Transferencia reprovada com sucesso",
              errorType: ErrorType.success,
            ),
          );
        }
        context.pop();
      },
    );

    setLoading(false);
  }

  void addHeir() async {
    amountFocusNodes.add(FocusNode());
    amountsControllers.add(TextEditingController());
    addressFocusNodes.add(FocusNode());
    addressesControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeHeir(int index) {
    amountFocusNodes.removeAt(index);
    amountsControllers.removeAt(index);
    addressFocusNodes.removeAt(index);
    addressesControllers.removeAt(index);
    notifyListeners();
  }
}
