import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';

class TestamentModel {
  String title;
  DateTime dateCreated;
  DateTime lastProveOfLife;
  List<HeirModel> listHeir;
  EnumProveOfLiveRecorrence proveOfLiveRecorrence;
  double value;

  TestamentModel({
    required this.value,
    required this.dateCreated,
    required this.lastProveOfLife,
    required this.proveOfLiveRecorrence,
    required this.title,
    required this.listHeir,
  });

  factory TestamentModel.createWithDefaultValues() {
    return TestamentModel(
      title: '',
      dateCreated: DateTime.now(),
      lastProveOfLife: DateTime.now(),
      proveOfLiveRecorrence: EnumProveOfLiveRecorrence.TRIMESTRAL,
      listHeir: [],
      value: 0,
    );
  }
}
