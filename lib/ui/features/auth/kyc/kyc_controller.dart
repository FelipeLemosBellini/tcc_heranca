import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class KycController extends BaseController {
  final KycRepositoryInterface kycRepository;
  final UserRepositoryInterface userRepository;

  KycController({required this.userRepository, required this.kycRepository});

  // Controllers
  final cpfController = TextEditingController();
  final rgController = TextEditingController();

  Document? cpfDocument;
  Document? proofResidenceDocument;

  XFile? cpfFront;
  XFile? proofResidence;

  @override
  void dispose() {
    super.dispose();
    cpfController.dispose();
    rgController.dispose();
  }

  Future<void> getUser() async {
    setLoading(true);
    final response = await userRepository.getUser();
    response.fold((error) {}, (user) {
      cpfController.text = user.cpf ?? '';
      rgController.text = user.rg ?? '';
    });

    final responseDocuments = await kycRepository.getDocumentsByUserId();
    responseDocuments.fold((e) {}, (listDocuments) {
      for (Document document in listDocuments) {
        if (document.typeDocument == TypeDocument.cpf) {
          cpfDocument = document;
        }
        if (document.typeDocument == TypeDocument.proofResidence) {
          proofResidenceDocument = document;
        }
      }
    });
    notifyListeners();
    setLoading(false);
  }

  bool validateCpf(String raw) {
    final cpf = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    var rem = (sum * 10) % 11;
    if (rem == 10) rem = 0;
    if (rem != int.parse(cpf[9])) return false;

    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    rem = (sum * 10) % 11;
    if (rem == 10) rem = 0;
    if (rem != int.parse(cpf[10])) return false;

    return true;
  }

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  bool _validateInput({required String cpf, required String rg}) {
    final cleanCpf = _digitsOnly(cpf);
    if (cleanCpf.isEmpty || rg.trim().isEmpty) {
      setMessage(
        AlertData(message: 'Preencha CPF e RG.', errorType: ErrorType.warning),
      );
      return false;
    }
    if (!validateCpf(cleanCpf)) {
      setMessage(
        AlertData(message: 'CPF inválido.', errorType: ErrorType.error),
      );
      return false;
    }
    if (rg.trim().length < 5) {
      setMessage(
        AlertData(message: 'RG inválido.', errorType: ErrorType.error),
      );
      return false;
    }
    return true;
  }

  Future<bool> submit({required bool isEdit}) async {
    if (!_validateInput(cpf: cpfController.text, rg: rgController.text)) {
      return false;
    }
    setLoading(true);

    bool cpfOk = false;
    bool proofOk = false;

    if (cpfFront != null) {
      Document userCpfDocument = Document(
        reviewStatus: ReviewStatusDocument.pending,
        typeDocument: TypeDocument.cpf,
        uploadedAt: DateTime.now(),
        from: EnumDocumentsFrom.kyc,
      );
      var cpfResponse = await kycRepository.submit(
        userDocument: userCpfDocument,
        xFile: cpfFront!,
      );

      cpfResponse.fold((error) {}, (success) {
        cpfOk = true;
      });
    }

    if (proofResidence != null) {
      Document userProofDocument = Document(
        reviewStatus: ReviewStatusDocument.pending,
        typeDocument: TypeDocument.proofResidence,
        uploadedAt: DateTime.now(),
        from: EnumDocumentsFrom.kyc,
      );
      var proofResponse = await kycRepository.submit(
        userDocument: userProofDocument,
        xFile: proofResidence!,
      );

      proofResponse.fold((error) {}, (success) {
        proofOk = true;
      });
    }

    var responseUpdateKycStatus = await kycRepository.setStatusKyc(
      kycStatus: KycStatus.submitted,
      cpf: cpfController.text,
      rg: rgController.text,
    );
    var statusOk = false;
    responseUpdateKycStatus.fold(
      (error) {
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (_) {
        statusOk = true;
      },
    );

    setLoading(false);

    bool deuCertoOsDocuments = cpfOk || proofOk;
    return deuCertoOsDocuments && statusOk;
  }
}
