import 'package:tcc/core/models/heir_model.dart';

class TestamentModel {
  String title;
  DateTime dateCreated;
  DateTime lastProveOfLife;
  List<HeirModel> listHeir;
  double value;

  TestamentModel({
    required this.value,
    required this.dateCreated,
    required this.lastProveOfLife,
    required this.title,
    required this.listHeir,
  });

  factory TestamentModel.createWithDefaultValues() {
    return TestamentModel(
      title: '',
      dateCreated: DateTime.now(),
      lastProveOfLife: DateTime.now(),
      listHeir: [],
      value: 0,
    );
  }
}
