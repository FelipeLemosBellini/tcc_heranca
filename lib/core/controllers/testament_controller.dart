import 'package:flutter/material.dart';
import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentController extends ChangeNotifier {
  TestamentModel _testament = TestamentModel.createWithDefaultValues();

  List<TestamentModel> listTestament = [];

  TestamentModel get testament => _testament;

  void setTitle(String title) {
    _testament.title = title;
    notifyListeners();
  }

  void setDateCreated(DateTime date) {
    _testament.dateCreated = date;
    notifyListeners();
  }

  void setDateLastProveOfLife(DateTime date) {
    _testament.lastProveOfLife = date;
    notifyListeners();
  }

  void setListHeir(List<HeirModel> listHeir) {
    _testament.listHeir = listHeir;
    notifyListeners();
  }

  void setProveOfLiveRecorrence(EnumProveOfLiveRecorrence value) {
    _testament.proveOfLiveRecorrence = value;
    notifyListeners();
  }

  void setValue(double value) {
    _testament.value = value;
    notifyListeners();
  }

  void clearTestament() {
    _testament = TestamentModel.createWithDefaultValues();
    notifyListeners();
  }

  void saveTestament(TestamentModel testament) {
    listTestament.add(testament);
    notifyListeners();
  }

  Future<List<TestamentModel>> getAllTestaments () async {
    return listTestament;
  }


}
