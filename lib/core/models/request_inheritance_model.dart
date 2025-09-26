import 'package:tcc/core/enum/heir_status.dart';

class RequestInheritanceModel {
  //preciso disso vamos criar uma colecao de heranca, que vai armazenar o nome do cliente, cpf, userId do cliente, request by id do solicitante, heirStatus, id da heranca
  final String id;
  String? userId; // userId do cliente
  final String cpf; // cpf do cliente
  String? name; // nome do cliente
  String? requestById; // userId do solicitante
  final HeirStatus heirStatus; // status da heranca

  RequestInheritanceModel({
    required this.id,
    required this.userId,
    required this.cpf,
    required this.name,
    required this.requestById,
    required this.heirStatus,
  });

  factory RequestInheritanceModel.fromMap(Map<String, dynamic> json) {
    return RequestInheritanceModel(
      id: json['id'],
      userId: json['userId'],
      cpf: json['cpf'],
      name: json['name'],
      requestById: json['requestById'],
      heirStatus: json['heirStatus']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cpf': cpf,
      'name': name,
      'requestById': requestById,
      'heirStatus': heirStatus.name,
    };
  }
}