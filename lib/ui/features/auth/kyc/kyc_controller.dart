import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/kyc_model.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class KycController extends BaseController {
  final KycRepository kycRepository;

  KycController({required this.kycRepository});

  KycModel? _kyc;
  Uint8List? _docFront;
  Uint8List? _docBack;
  Uint8List? _proofResidence;

  KycModel? get kyc => _kyc;
  Uint8List? get docFront => _docFront;
  Uint8List? get docBack => _docBack;
  Uint8List? get proofResidence => _proofResidence;

  Future<void> load() async {
    setLoading(true);
    final Either<ExceptionMessage, KycModel?> response =
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

  Future<bool> saveDraft({required String cpf, required String rg}) async {
    if (!_validateInput(cpf: cpf, rg: rg)) return false;
    setLoading(true);
    final draft = KycModel(
      cpf: _digitsOnly(cpf),
      rg: rg.trim(),
      status: KycStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final Either<ExceptionMessage, void> res =
        await kycRepository.saveDraft(draft);

    bool ok = false;
    res.fold(
      (err) => setMessage(
        AlertData(message: err.errorMessage, errorType: ErrorType.error),
      ),
      (_) {
        _kyc = draft;
        ok = true;
        setMessage(
          AlertData(
            message: 'Rascunho do KYC salvo.',
            errorType: ErrorType.success,
          ),
        );
      },
    );
    setLoading(false);
    return ok;
  }

  Future<bool> submit({required String cpf, required String rg}) async {
    if (!_validateInput(cpf: cpf, rg: rg)) return false;
    setLoading(true);
    final submission = KycModel(
      cpf: _digitsOnly(cpf),
      rg: rg.trim(),
      status: KycStatus.submitted,
      createdAt: _kyc?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final Either<ExceptionMessage, void> res =
        await kycRepository.submit(submission);

    bool ok = false;
    res.fold(
      (err) => setMessage(
        AlertData(message: err.errorMessage, errorType: ErrorType.error),
      ),
      (_) {
        _kyc = submission;
        ok = true;
        setMessage(
          AlertData(
            message: 'KYC enviado para análise.',
            errorType: ErrorType.success,
          ),
        );
      },
    );
    setLoading(false);
    return ok;
  }
}
