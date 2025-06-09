import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';

class TestamentModel {
  String testamentAddress;
  String title;
  DateTime dateCreated;
  DateTime lastProveOfLife;
  List<HeirModel> listHeir;
  EnumPlan plan;
  EnumProveOfLiveRecurring proveOfLiveRecurring;
  double value;

  TestamentModel({
    required this.testamentAddress,
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
      testamentAddress: '',
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
      'title': title,
      'dateCreated': dateCreated.toIso8601String(),
      'lastProveOfLife': lastProveOfLife.toIso8601String(),
      'listHeir': listHeir.map((heir) => heir.toMap()).toList(),
      'plan': plan.name, // ou plan.toString(), dependendo do enum
      'proveOfLiveRecurring': proveOfLiveRecurring.name,
      'value': value,
    };
  }

  factory TestamentModel.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return TestamentModel(
      testamentAddress: doc["testamentAddress"],
      value: doc["value"],
      dateCreated: doc["dateCreated"],
      lastProveOfLife: doc["lastProveOfLife"],
      proveOfLiveRecurring: doc["proveOfLiveRecurring"],
      title: doc["title"],
      listHeir: doc["listHeir"],
      plan: doc["plan"],
    );
  }

  factory TestamentModel.fromMap(Map<String, dynamic> map) {
    return TestamentModel(
      testamentAddress: map['testament'],
      title: map['title'],
      dateCreated: DateTime.parse(map['dateCreated']),
      lastProveOfLife: DateTime.parse(map['lastProveOfLife']),
      listHeir:
          (map['listHeir'] as List)
              .map((heirMap) => HeirModel.fromMap(heirMap))
              .toList(),
      plan: EnumPlan.values.firstWhere((e) => e.name == map['plan']),
      proveOfLiveRecurring: EnumProveOfLiveRecurring.values.firstWhere(
        (e) => e.name == map['proveOfLiveRecurring'],
      ),
      value: (map['value'] as num).toDouble(),
    );
  }

  factory TestamentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return TestamentModel.fromMap({
      ...data,
      'testament': doc.id,
    });
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

  TestamentModel copyWith({
    String? testamentAddress,
    String? title,
    DateTime? dateCreated,
    DateTime? lastProveOfLife,
    List<HeirModel>? listHeir,
    EnumPlan? plan,
    EnumProveOfLiveRecurring? proveOfLiveRecurring,
    double? value,
  }) {
    return TestamentModel(
      testamentAddress: testamentAddress ?? this.testamentAddress,
      title: title ?? this.title,
      dateCreated: dateCreated ?? this.dateCreated,
      lastProveOfLife: lastProveOfLife ?? this.lastProveOfLife,
      listHeir: listHeir ?? this.listHeir,
      plan: plan ?? this.plan,
      proveOfLiveRecurring: proveOfLiveRecurring ?? this.proveOfLiveRecurring,
      value: value ?? this.value,
    );
  }

}
