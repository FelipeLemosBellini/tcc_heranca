import 'package:flutter/material.dart';
import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentController extends ChangeNotifier {
  TestamentModel _testament = TestamentModel.createWithDefaultValues();

  TestamentModel get testament => _testament;

  void setId(String addressTestator) {
    _testament.id = addressTestator;
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

  void setPlan(EnumPlan value) {
    _testament.plan = value;
    notifyListeners();
  }

  void clearTestament() {
    _testament = TestamentModel.createWithDefaultValues();
    notifyListeners();
  }

  void setUserId({required String addressTestator}) {
    _testament.userId = addressTestator;
    notifyListeners();
  }

  void setTestamentToEdit(TestamentModel oldTestament) {
    _testament = oldTestament;
    notifyListeners();
  }
}
