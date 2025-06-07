import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';

class TestamentModel {
  int id;
  String title;
  DateTime dateCreated;
  DateTime lastProveOfLife;
  List<HeirModel> listHeir;
  EnumPlan plan;
  EnumProveOfLiveRecurring proveOfLiveRecurring;
  double value;

  TestamentModel({
    required this.id,
    required this.value,
    required this.dateCreated,
    required this.lastProveOfLife,
    required this.proveOfLiveRecurring,
    required this.title,
    required this.listHeir,
    required this.plan,
  });

  factory TestamentModel.createWithDefaultValues() {
    return TestamentModel(
      id: 0,
      title: '',
      dateCreated: DateTime.now(),
      lastProveOfLife: DateTime.now(),
      proveOfLiveRecurring: EnumProveOfLiveRecurring.TRIMESTRAL,
      listHeir: [],
      value: 0,
      plan: EnumPlan.TESTE,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateCreated': dateCreated.toIso8601String(),
      'lastProveOfLife': lastProveOfLife.toIso8601String(),
      'listHeir': listHeir.map((heir) => heir.toMap()).toList(),
      'plan': plan.name, // ou plan.toString(), dependendo do enum
      'proveOfLiveRecurring': proveOfLiveRecurring.name,
      'value': value,
    };
  }

  factory TestamentModel.fromMap(Map<String, dynamic> map) {
    return TestamentModel(
      id: map['id'],
      title: map['title'],
      dateCreated: DateTime.parse(map['dateCreated']),
      lastProveOfLife: DateTime.parse(map['lastProveOfLife']),
      listHeir: (map['listHeir'] as List)
          .map((heirMap) => HeirModel.fromMap(heirMap))
          .toList(),
      plan: EnumPlan.values.firstWhere((e) => e.name == map['plan']),
      proveOfLiveRecurring: EnumProveOfLiveRecurring.values
          .firstWhere((e) => e.name == map['proveOfLiveRecurring']),
      value: (map['value'] as num).toDouble(),
    );
  }

  DateTime proofLifeExpiration() {
    late DateTime expiration;
    switch (proveOfLiveRecurring) {
      case EnumProveOfLiveRecurring.TRIMESTRAL:
        expiration = lastProveOfLife.add(Duration(days: 90));
        break;
      case EnumProveOfLiveRecurring.SEMESTRAL:
        expiration = lastProveOfLife.add(Duration(days: 180));
        break;
      case EnumProveOfLiveRecurring.ANUAL:
        expiration = lastProveOfLife.add(Duration(days: 360));
        break;
    }
    return expiration;
  }
}