import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';

class TestamentModel {
  int id;
  String title;
  DateTime dateCreated;
  DateTime lastProveOfLife;
  List<HeirModel> listHeir;
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
    );
  }

  DateTime proofLifeExpiration() {
    late DateTime expiration;
    switch (proveOfLiveRecurring) {
      case EnumProveOfLiveRecurring.TRIMESTRAL:
        expiration = lastProveOfLife.add(Duration(days: 90));
      case EnumProveOfLiveRecurring.SEMESTRAL:
        expiration = lastProveOfLife.add(Duration(days: 180));
      case EnumProveOfLiveRecurring.ANUAL:
        expiration = lastProveOfLife.add(Duration(days: 360));
    }
    return expiration;
  }
}
