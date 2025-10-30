import 'package:flutter/material.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentController extends ChangeNotifier {
  TestamentModel _testament = TestamentModel.createWithDefaultValues();

  TestamentModel get testament => _testament;

  void setDateCreated(DateTime date) {
    _testament.dateCreated = date;
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

  void setTestamentToEdit(TestamentModel oldTestament) {
    _testament = oldTestament;
    notifyListeners();
  }
}
