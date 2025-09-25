import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class KycController extends BaseController {
  final KycRepository kycRepository;

  KycController({required this.kycRepository});

  UserDocument? _kyc;
  Uint8List? _docFront;
  Uint8List? _docBack;
  Uint8List? _proofResidence;

  UserDocument? get kyc => _kyc;

  Uint8List? get docFront => _docFront;

  Uint8List? get docBack => _docBack;

  Uint8List? get proofResidence => _proofResidence;

  Future<void> load() async {
    setLoading(true);
    final Either<ExceptionMessage, UserDocument?> response =
        await kycRepository.getCurrent();

    response.fold(
      (err) => setMessage(
        AlertData(message: err.errorMessage, errorType: ErrorType.error),
      ),
      (data) {
        _kyc = data;
      },
    );
    setLoading(false);
  }

  void setDocFront(Uint8List? bytes) {
    _docFront = bytes;
    notifyListeners();
  }

  void setDocBack(Uint8List? bytes) {
    _docBack = bytes;
    notifyListeners();
  }

  void setProofResidence(Uint8List? bytes) {
    _proofResidence = bytes;
    notifyListeners();
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

  Future<bool> submit({
    required String cpf,
    required String rg,
    required XFile cpfFront,
    required XFile proofResidence,
  }) async {
    if (!_validateInput(cpf: cpf, rg: rg)) return false;
    setLoading(true);

    bool cpfOk = false;
    bool proofOk = false;
    UserDocument userCpfDocument = UserDocument(
      content: cpf,
      reviewStatus: ReviewStatusDocument.pending,
      typeDocument: TypeDocument.cpf,
      uploadedAt: DateTime.now(),
    );
    var cpfResponse = await kycRepository.submit(
      userDocument: userCpfDocument,
      xFile: cpfFront,
    );

    cpfResponse.fold((error) {}, (success) {
      cpfOk = true;
    });

    UserDocument userProofDocument = UserDocument(
      content: rg,
      reviewStatus: ReviewStatusDocument.pending,
      typeDocument: TypeDocument.proofResidence,
      uploadedAt: DateTime.now(),
    );
    var proofResponse = await kycRepository.submit(
      userDocument: userProofDocument,
      xFile: proofResidence,
    );

    proofResponse.fold((error) {}, (success) {
      proofOk = true;
    });

    var responseUpdateKycStatus = await kycRepository.setStatusKyc(
      kycStatus: KycStatus.submitted,
      cpf: cpf,
      rg: rg,
    );

    responseUpdateKycStatus.fold((error) {}, (success) {});

    setLoading(false);
    return cpfOk && proofOk;
  }
}
