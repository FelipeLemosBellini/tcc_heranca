import 'package:flutter/material.dart';
import 'package:tcc/core/enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentController extends ChangeNotifier {
  TestamentModel _testament = TestamentModel.createWithDefaultValues();

  List<TestamentModel> listTestament = [];

  TestamentModel get testament => _testament;

  void setId() {
    _testament.id = DateTime.now().microsecondsSinceEpoch;
    notifyListeners();
  }

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

  void setProveOfLiveRecurring(EnumProveOfLiveRecurring value) {
    _testament.proveOfLiveRecurring = value;
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

  void saveTestament() {
    setId();
    listTestament.add(testament);
    notifyListeners();
  }

  Future<List<TestamentModel>> getAllTestaments() async {
    return listTestament;
  }

  void setTestamentToEdit(TestamentModel oldTestament) {
    _testament = oldTestament;
  }

  void updateTestament() {
    int index = listTestament.indexWhere((index) => index.id == _testament.id);
    listTestament[index] = _testament;
  }

  void deleteTestament(TestamentModel oldTestament) {
    int index = listTestament.indexWhere((index) => index.id == oldTestament.id);

    listTestament.removeAt(index);
  }
}
