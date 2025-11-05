import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';

class DbMappings {
  DbMappings._();

  /// Flux mapping (documents origin)
  static const Map<EnumDocumentsFrom, int> _fluxByEnum = {
    EnumDocumentsFrom.kyc: 1,
    EnumDocumentsFrom.balanceRequest: 2,
    EnumDocumentsFrom.inheritanceRequest: 3,
  };

  static const Map<int, EnumDocumentsFrom> _fluxById = {
    1: EnumDocumentsFrom.kyc,
    2: EnumDocumentsFrom.balanceRequest,
    3: EnumDocumentsFrom.inheritanceRequest,
  };

  static int? fluxToId(EnumDocumentsFrom? flux) => flux == null ? null : _fluxByEnum[flux];

  static EnumDocumentsFrom? fluxFromId(int? id) => id == null ? null : _fluxById[id];

  /// Document status mapping
  static const Map<ReviewStatusDocument, int> _documentStatusByEnum = {
    ReviewStatusDocument.pending: 1,
    ReviewStatusDocument.approved: 2,
    ReviewStatusDocument.invalid: 3,
  };

  static const Map<int, ReviewStatusDocument> _documentStatusById = {
    1: ReviewStatusDocument.pending,
    2: ReviewStatusDocument.approved,
    3: ReviewStatusDocument.invalid,
  };

  static int documentStatusToId(ReviewStatusDocument status) => _documentStatusByEnum[status]!;

  static ReviewStatusDocument documentStatusFromId(int? id) =>
      _documentStatusById[id] ?? ReviewStatusDocument.invalid;

  /// KYC status mapping
  static const Map<KycStatus, int> _kycStatusByEnum = {
    KycStatus.waiting: 4,
    KycStatus.submitted: 5,
    KycStatus.approved: 6,
    KycStatus.rejected: 7,
  };

  static const Map<int, KycStatus> _kycStatusById = {
    4: KycStatus.waiting,
    5: KycStatus.submitted,
    6: KycStatus.approved,
    7: KycStatus.rejected,
  };

  static int kycStatusToId(KycStatus status) => _kycStatusByEnum[status]!;

  static KycStatus kycStatusFromId(int? id) => _kycStatusById[id] ?? KycStatus.rejected;

  /// Heir status mapping
  static const Map<HeirStatus, int> _heirStatusByEnum = {
    HeirStatus.consultaSaldoSolicitado: 8,
    HeirStatus.consultaSaldoAprovado: 9,
    HeirStatus.consultaSaldoRecusado: 10,
    HeirStatus.transferenciaSaldoSolicitado: 11,
    HeirStatus.transferenciaSaldoRealizada: 12,
    HeirStatus.transferenciaSaldoRecusado: 13,
  };

  static const Map<int, HeirStatus> _heirStatusById = {
    8: HeirStatus.consultaSaldoSolicitado,
    9: HeirStatus.consultaSaldoAprovado,
    10: HeirStatus.consultaSaldoRecusado,
    11: HeirStatus.transferenciaSaldoSolicitado,
    12: HeirStatus.transferenciaSaldoRealizada,
    13: HeirStatus.transferenciaSaldoRecusado,
  };

  static int heirStatusToId(HeirStatus status) => _heirStatusByEnum[status]!;

  static HeirStatus heirStatusFromId(int? id) =>
      _heirStatusById[id] ?? HeirStatus.consultaSaldoSolicitado;

  /// Document type mapping
  static const Map<TypeDocument, int> _documentTypeByEnum = {
    TypeDocument.cpf: 1,
    TypeDocument.proofResidence: 2,
    TypeDocument.deathCertificate: 3,
    TypeDocument.procuracaoAdvogado: 4,
    TypeDocument.testamentDocument: 5,
    TypeDocument.transferAssetsOrder: 6,
    TypeDocument.inventoryProcess: 7,
  };

  static const Map<int, TypeDocument> _documentTypeById = {
    1: TypeDocument.cpf,
    2: TypeDocument.proofResidence,
    3: TypeDocument.deathCertificate,
    4: TypeDocument.procuracaoAdvogado,
    5: TypeDocument.testamentDocument,
    6: TypeDocument.transferAssetsOrder,
    7: TypeDocument.inventoryProcess,
  };

  static int documentTypeToId(TypeDocument type) => _documentTypeByEnum[type]!;

  static TypeDocument documentTypeFromId(int? id) =>
      _documentTypeById[id] ?? TypeDocument.cpf;
}
