import 'package:tcc/core/enum/heir_status.dart';

class RequestInheritanceModel {
  //preciso disso vamos criar uma colecao de heranca, que vai armazenar o nome do cliente, cpf, userId do cliente, request by id do solicitante, heirStatus, id da heranca
  String? id;
  String? userId; // userId do cliente
  String? cpf; // cpf do cliente
  String? name; // nome do cliente
  String? requestById; // userId do solicitante
  HeirStatus? heirStatus; // status da heranca

  RequestInheritanceModel({
    this.id,
    this.userId,
    this.cpf,
    this.name,
    this.requestById,
    this.heirStatus,
  });

  factory RequestInheritanceModel.fromMap(Map<String, dynamic> json) {
    return RequestInheritanceModel(
      userId: json['userId'],
      cpf: json['cpf'],
      name: json['name'],
      requestById: json['requestById'],
      heirStatus: HeirStatus.toEnum(json['heirStatus'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cpf': cpf,
      'name': name,
      'requestById': requestById,
      'heirStatus': heirStatus?.value,
    };
  }
}